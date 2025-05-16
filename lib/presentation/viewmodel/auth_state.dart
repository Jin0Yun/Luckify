import 'package:luckify/domain/entity/user_entity.dart';

class AuthState {
  final UserEntity user;
  final bool isLoading;
  final String? error;

  AuthState({
    this.user = UserEntity.anonymousUser,
    this.isLoading = false,
    this.error,
  });

  bool get isLoggedIn => user.isLoggedIn;

  AuthState copyWith({
    UserEntity? user,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}