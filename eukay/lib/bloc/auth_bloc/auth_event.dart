part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthLoginRequest extends AuthEvent {
  final String email;
  final String password;

  AuthLoginRequest({
    required this.email,
    required this.password,
  });
}

final class AuthRegisterRequest extends AuthEvent {
  final String email;
  final String password;
  final String confirmPassword;
  final String name;
  final bool isSeller;

  AuthRegisterRequest({
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.name,
    this.isSeller = false,
  });
}
