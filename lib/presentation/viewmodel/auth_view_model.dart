import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luckify/domain/repository/auth_repository.dart';
import 'package:luckify/presentation/viewmodel/auth_state.dart';

class AuthViewModel extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;

  AuthViewModel({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthState()) {
    _initialize();
  }

  void _initialize() {
    state = state.copyWith(user: _authRepository.currentUser);
    _authRepository.authStateChanges.listen((user) {
      state = state.copyWith(user: user);
    });
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _authRepository.signInWithProvider(AuthProvider.google);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _authRepository.signOut();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}