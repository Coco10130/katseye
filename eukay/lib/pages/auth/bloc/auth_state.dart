part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoginSuccess extends AuthState {
  final String token;

  AuthLoginSuccess({required this.token});
}

final class AuthLoginFailure extends AuthState {
  final String errorMessage;

  AuthLoginFailure(this.errorMessage);
}

final class AuthRegisterFailure extends AuthState {
  final String errorMessage;

  AuthRegisterFailure(this.errorMessage);
}

final class AuthRegisterSuccess extends AuthState {
  final String successMessage;

  AuthRegisterSuccess({
    required this.successMessage,
  });
}

final class AuthLoading extends AuthState {}
