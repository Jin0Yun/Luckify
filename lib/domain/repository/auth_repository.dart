import 'package:luckify/domain/entity/user_entity.dart';

enum AuthProvider {
  google,
}

abstract class AuthRepository {
  Future<UserEntity> signInWithProvider(AuthProvider provider);
  Future<void> signOut();
  Stream<UserEntity> get authStateChanges;
  UserEntity get currentUser;
  Future<void> deleteAccount();
}