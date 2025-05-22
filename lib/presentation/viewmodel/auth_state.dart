import 'package:luckify/domain/entity/user_entity.dart';
import 'package:luckify/presentation/viewmodel/base_state.dart';

class AuthState implements BaseState {
  final UserEntity user;
  @override
  final bool isLoading;
  @override
  final String? error;

  const AuthState({
    this.user = UserEntity.anonymousUser,
    this.isLoading = false,
    this.error,
  });

  bool get isLoggedIn => user.isLoggedIn;

  AuthState copyWith({UserEntity? user, bool? isLoading, String? error}) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}