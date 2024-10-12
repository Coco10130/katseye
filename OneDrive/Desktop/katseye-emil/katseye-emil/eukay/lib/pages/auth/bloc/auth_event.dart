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
  final String email, userName, confirmPassword, password;

  AuthRegisterRequest({
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.userName,
  });
}

final class SendOtpEvent extends AuthEvent {
  final String email;

  SendOtpEvent({required this.email});
}

final class VerifyOtpEvent extends AuthEvent {
  final String email, otp, otpHash;

  VerifyOtpEvent({
    required this.email,
    required this.otp,
    required this.otpHash,
  });
}

final class ResetPasswordEvent extends AuthEvent {
  final String newPassword, confirmPassword, email;
  final bool otpVerified;

  ResetPasswordEvent({
    required this.newPassword,
    required this.confirmPassword,
    required this.email,
    required this.otpVerified,
  });
}
