import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class UserEntity {
  final String id;
  final String? displayName;
  final bool isAnonymous;

  const UserEntity({
    required this.id,
    this.displayName,
    this.isAnonymous = true,
  });

  static const anonymousUser = UserEntity(
    id: '',
    isAnonymous: true,
  );

  factory UserEntity.fromFirebase(firebase_auth.User firebaseUser) => UserEntity(
    id: firebaseUser.uid,
    displayName: firebaseUser.displayName,
    isAnonymous: firebaseUser.isAnonymous,
  );

  bool get isLoggedIn => !isAnonymous && id.isNotEmpty;
}