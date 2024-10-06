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

  AuthLoginFailure({required this.errorMessage});
}

final class AuthRegisterFailure extends AuthState {
  final String errorMessage;

  AuthRegisterFailure({required this.errorMessage});
}

final class AuthRegisterSuccess extends AuthState {
  final String successMessage;

  AuthRegisterSuccess({
    required this.successMessage,
  });
}

final class SendOtpSuccessState extends AuthState {
  final String otpHash, successMessage, email;

  SendOtpSuccessState(
      {required this.otpHash,
      required this.successMessage,
      required this.email});
}

final class ForgotPasswordFailedState extends AuthState {
  final String errorMessage;

  ForgotPasswordFailedState({required this.errorMessage});
}

final class VerifyOtpSuccessState extends AuthState {
  final String successMessage;
  final bool otpVerified;

  VerifyOtpSuccessState(
      {required this.successMessage, required this.otpVerified});
}

final class ResetPasswordSuccessState extends AuthState {
  final String successMessage;

  ResetPasswordSuccessState({required this.successMessage});
}

final class AuthLoading extends AuthState {}
