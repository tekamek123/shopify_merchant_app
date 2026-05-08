import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/auth/secure_storage.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_bloc.freezed.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SecureStorage _storage;

  AuthBloc({required SecureStorage storage})
      : _storage = storage,
        super(const AuthState.initial()) {
    on<AppStarted>(_onAppStarted);
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<TokenRefreshed>(_onTokenRefreshed);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    final token = await _storage.getToken();
    if (token != null) {
      emit(AuthState.authenticated(token: token));
    } else {
      emit(const AuthState.unauthenticated());
    }
  }

  Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    try {
      // Mock login logic - in real app, call repository
      await Future.delayed(const Duration(seconds: 2));
      const mockToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...';
      
      await _storage.saveToken(mockToken);
      emit(const AuthState.authenticated(token: mockToken));
    } catch (e) {
      emit(AuthState.unauthenticated(message: e.toString()));
    }
  }

  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    await _storage.deleteAll();
    emit(const AuthState.unauthenticated());
  }

  void _onTokenRefreshed(TokenRefreshed event, Emitter<AuthState> emit) {
    emit(AuthState.authenticated(token: event.token));
  }
}
