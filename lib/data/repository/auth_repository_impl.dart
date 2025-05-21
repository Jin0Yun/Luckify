import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:luckify/core/exceptions/auth_error.dart';
import 'package:luckify/core/logger/logger.dart';
import 'package:luckify/data/repository/base_repository.dart';
import 'package:luckify/domain/entity/user_entity.dart';
import 'package:luckify/domain/repository/auth_repository.dart';

class FirebaseAuthRepository extends BaseRepository implements AuthRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  FirebaseAuthRepository({
    firebase_auth.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
    AppLogger? logger,
  }) : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
       _googleSignIn = googleSignIn ?? GoogleSignIn(),
       super(logger: logger, tag: 'Auth');

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
}