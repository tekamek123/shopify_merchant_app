import 'package:equatable/equatable.dart';

sealed class AppFailure extends Equatable {
  final String message;
  const AppFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class NetworkFailure extends AppFailure {
  const NetworkFailure([super.message = 'No internet connection']);
}

class AuthFailure extends AppFailure {
  const AuthFailure([super.message = 'Authentication failed']);
}

class ServerFailure extends AppFailure {
  const ServerFailure([super.message = 'Server error occurred']);
}

class NotFoundFailure extends AppFailure {
  const NotFoundFailure([super.message = 'Resource not found']);
}

class CacheFailure extends AppFailure {
  const CacheFailure([super.message = 'Cache operation failed']);
}
