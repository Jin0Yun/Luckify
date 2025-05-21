import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:luckify/core/exceptions/auth_error.dart';
import 'package:luckify/data/repository/base_repository.dart';
import 'package:luckify/domain/entity/user_entity.dart';
import 'package:luckify/domain/repository/auth_repository.dart';

class FirebaseAuthRepository extends BaseRepository implements AuthRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _firestore;

  FirebaseAuthRepository({
    firebase_auth.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
    FirebaseFirestore? firestore,
    super.logger,
  }) : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
       _googleSignIn = googleSignIn ?? GoogleSignIn(),
       _firestore = firestore ?? FirebaseFirestore.instance,
       super(tag: 'Auth');

  AuthException _mapFirebaseAuthException(
    firebase_auth.FirebaseAuthException e,
  ) {
    switch (e.code) {
      case 'invalid-credential':
        return AuthException(AuthError.invalidCredential, e);
      case 'account-exists-with-different-credential':
        return AuthException(AuthError.accountExists, e);
      case 'network-request-failed':
        return AuthException(AuthError.networkError, e);
      case 'too-many-requests':
        return AuthException(AuthError.tooManyRequests, e);
      case 'user-disabled':
        return AuthException(AuthError.userDisabled, e);
      case 'operation-not-allowed':
        return AuthException(AuthError.operationNotAllowed, e);
      case 'requires-recent-login':
        return AuthException(AuthError.authenticationRequired, e);
      default:
        return AuthException(AuthError.unknown, e);
    }
  }

  @override
  Future<UserEntity> signInWithProvider(AuthProvider provider) {
    if (provider == AuthProvider.google) {
      return _signInWithGoogle();
    }
    throw AuthException(AuthError.operationNotAllowed);
  }

  Future<UserEntity> _signInWithGoogle() {
    return executeWithLogging(() async {
      try {
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        if (googleUser == null) {
          throw AuthException(AuthError.cancelled);
        }

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final credential = firebase_auth.GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final userCredential = await _firebaseAuth.signInWithCredential(
          credential,
        );
        return UserEntity.fromFirebase(userCredential.user!);
      } on AuthException {
        rethrow;
      } on firebase_auth.FirebaseAuthException catch (e) {
        throw _mapFirebaseAuthException(e);
      } catch (e) {
        throw AuthException(AuthError.unknown, e is Exception ? e : null);
      }
    }, 'Google 로그인');
  }

  @override
  Future<void> signOut() {
    return executeWithLogging(() async {
      await Future.wait([_firebaseAuth.signOut(), _googleSignIn.signOut()]);
    }, '로그아웃');
  }

  @override
  Stream<UserEntity> get authStateChanges =>
      _firebaseAuth.authStateChanges().map(
        (user) =>
            user != null
                ? UserEntity.fromFirebase(user)
                : UserEntity.anonymousUser,
      );

  @override
  UserEntity get currentUser {
    final user = _firebaseAuth.currentUser;
    return user != null
        ? UserEntity.fromFirebase(user)
        : UserEntity.anonymousUser;
  }

  Future<void> _deleteUserData(String userId) async {
    try {
      final userDocRef = _firestore.collection('users').doc(userId);
      final fortuneHistoriesRef = userDocRef.collection('fortune_histories');
      final fortuneHistories = await fortuneHistoriesRef.get();

      final batch = _firestore.batch();
      for (var doc in fortuneHistories.docs) {
        batch.delete(doc.reference);
      }
      batch.delete(userDocRef);

      await batch.commit();
      logger.i('사용자 데이터 삭제 완료: $userId', tag: tag);
    } catch (e) {
      logger.e('사용자 데이터 삭제 실패: ${e.toString()}', tag: tag);
      throw AuthException(AuthError.deletionFailed, e is Exception ? e : null);
    }
  }

  Future<bool> _tryDeleteUserAccount(firebase_auth.User user) async {
    try {
      await user.delete();
      return true;
    } on firebase_auth.FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        return await _reauthenticateAndDeleteAccount(user);
      }
      rethrow;
    }
  }

  Future<bool> _reauthenticateAndDeleteAccount(firebase_auth.User user) async {
    try {
      GoogleSignInAccount? googleUser = await _googleSignIn.signInSilently();
      if (googleUser == null) {
        googleUser = await _googleSignIn.signIn();
        if (googleUser == null) {
          return false;
        }
      }

      final googleAuth = await googleUser.authentication;
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await user.reauthenticateWithCredential(credential);
      await user.delete();
      return true;
    } catch (e) {
      logger.e('재인증 실패: ${e.toString()}', tag: tag);
      return false;
    }
  }

  @override
  Future<void> deleteAccount() {
    return executeWithLogging(() async {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw AuthException(AuthError.notAuthenticated);
      }
      final String userId = user.uid;

      await _deleteUserData(userId);
      bool accountDeleted = await _tryDeleteUserAccount(user);
      await signOut();

      if (!accountDeleted) {
        throw AuthException(AuthError.deletionFailed);
      }
    }, '회원 탈퇴');
  }
}