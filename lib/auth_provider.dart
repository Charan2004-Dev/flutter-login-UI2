import 'package:flutter_riverpod/flutter_riverpod.dart';

// States for login
enum AuthStatus { initial, loading, success, error }

class AuthState {
  final AuthStatus status;
  final String? error;

  AuthState({this.status = AuthStatus.initial, this.error});

  AuthState copyWith({AuthStatus? status, String? error}) {
    return AuthState(status: status ?? this.status, error: error ?? this.error);
  }
}

// Mock authentication service
class AuthService {
  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    return email == "test@test.com" && password == "123456";
  }
}

// Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;
  AuthNotifier(this._authService) : super(AuthState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading);

    final success = await _authService.login(email, password);
    if (success) {
      state = state.copyWith(status: AuthStatus.success);
    } else {
      state = state.copyWith(
        status: AuthStatus.error,
        error: "Invalid email or password",
      );
    }
  }
}

// Providers
final authServiceProvider = Provider((ref) => AuthService());
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(authServiceProvider));
});
