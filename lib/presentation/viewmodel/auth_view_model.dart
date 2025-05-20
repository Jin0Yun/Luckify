import 'dart:async';
import 'package:luckify/domain/repository/auth_repository.dart';
import 'package:luckify/presentation/viewmodel/auth_state.dart';
import 'package:luckify/presentation/viewmodel/base_view_model.dart';

class AuthViewModel extends BaseViewModel<AuthState> {
  final AuthRepository _authRepository;
  StreamSubscription? _authSubscription;

  AuthViewModel({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const AuthState()) {
    _initialize();
  }

  void _initialize() {
    state = state.copyWith(user: _authRepository.currentUser);
    _authSubscription = _authRepository.authStateChanges.listen((user) {
      state = state.copyWith(user: user);
    });
  }

  @override
  AuthState setLoadingState(bool isLoading) {
    return state.copyWith(isLoading: isLoading);
  }

  @override
  AuthState setErrorState(String? error) {
    return state.copyWith(error: error);
  }

  @override
  AuthState clearErrorState() {
    return state.copyWith(error: null);
  }

  Future<void> signInWithGoogle() async {
    await runWithLoading(
      () => _authRepository.signInWithProvider(AuthProvider.google),
    );
  }

  Future<void> signOut() async {
    await runWithLoading(() => _authRepository.signOut());
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  bool get isLoggedIn => state.isLoggedIn;
}