import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/auth/secure_storage.dart';
import '../../../../core/auth/auth_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_bloc.freezed.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SecureStorage _storage;
  final AuthService _authService;

  AuthBloc({
    required SecureStorage storage,
    required AuthService authService,
  })  : _storage = storage,
        _authService = authService,
        super(const AuthState.initial()) {
    on<AppStarted>(_onAppStarted);
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<TokenRefreshed>(_onTokenRefreshed);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    final token = await _storage.getToken();
    if (token != null) {
      _authService.login();
      emit(AuthState.authenticated(token: token));
    } else {
      _authService.logout();
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
      _authService.login();
      emit(const AuthState.authenticated(token: mockToken));
    } catch (e) {
      _authService.logout();
      emit(AuthState.unauthenticated(message: e.toString()));
    }
  }

  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    await _storage.deleteAll();
    _authService.logout();
    emit(const AuthState.unauthenticated());
  }

  Future<void> _onTokenRefreshed(TokenRefreshed event, Emitter<AuthState> emit) async {
    await _storage.saveToken(event.accessToken);
    if (event.refreshToken != null) {
      await _storage.saveRefreshToken(event.refreshToken!);
    }
    _authService.login();
    emit(AuthState.authenticated(token: event.accessToken));
  }
}
