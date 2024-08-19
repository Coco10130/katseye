part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoginSuccess extends AuthState {
  final String id;

  AuthLoginSuccess({required this.id});
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
  final String name;
  final String email;
  final String password;

  AuthRegisterSuccess({
    required this.name,
    required this.email,
    required this.password,
  });
}

final class AuthLoading extends AuthState {}
