import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:luckify/core/exceptions/auth_error.dart';
import 'package:luckify/core/logger/console_logger.dart';
import 'package:luckify/core/logger/logger.dart';
import 'package:luckify/domain/entity/user_entity.dart';
import 'package:luckify/domain/repository/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final AppLogger _logger;

  FirebaseAuthRepository({
    firebase_auth.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
    AppLogger? logger,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn(),
        _logger = logger ?? ConsoleLogger();

  @override
  Future<UserEntity> signInWithProvider(AuthProvider provider) async {
    if (provider == AuthProvider.google) {
      return _signInWithGoogle();
    }
    throw AuthException(AuthError.operationNotAllowed);
  }

  Future<UserEntity> _signInWithGoogle() async {
    try {
      _logger.i('Google 로그인 시작', tag: 'Auth');

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw AuthException(AuthError.cancelled);
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(credential);

      _logger.i('Google 로그인 성공', tag: 'Auth');
      return UserEntity.fromFirebase(userCredential.user!);
    } catch (e, stackTrace) {
      _logger.e('Google 로그인 실패', error: e, stackTrace: stackTrace, tag: 'Auth');

      if (e is AuthException) {
        rethrow;
      }

      if (e is firebase_auth.FirebaseAuthException) {
        switch (e.code) {
          case 'invalid-credential':
            throw AuthException(AuthError.invalidCredential, e);
          case 'account-exists-with-different-credential':
            throw AuthException(AuthError.accountExists, e);
          case 'network-request-failed':
            throw AuthException(AuthError.networkError, e);
          case 'too-many-requests':
            throw AuthException(AuthError.tooManyRequests, e);
          case 'user-disabled':
            throw AuthException(AuthError.userDisabled, e);
          case 'operation-not-allowed':
            throw AuthException(AuthError.operationNotAllowed, e);
          default:
            throw AuthException(AuthError.unknown, e);
        }
      }

      throw AuthException(AuthError.unknown, e is Exception ? e : null);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
      _logger.i('로그아웃 성공', tag: 'Auth');
    } catch (e, stackTrace) {
      _logger.e('로그아웃 실패', error: e, stackTrace: stackTrace, tag: 'Auth');
      rethrow;
    }
  }

  @override
  Stream<UserEntity> get authStateChanges =>
      _firebaseAuth.authStateChanges().map((user) =>
      user != null ? UserEntity.fromFirebase(user) : UserEntity.anonymousUser
      );

  @override
  UserEntity get currentUser {
    final user = _firebaseAuth.currentUser;
    return user != null
        ? UserEntity.fromFirebase(user)
        : UserEntity.anonymousUser;
  }
}