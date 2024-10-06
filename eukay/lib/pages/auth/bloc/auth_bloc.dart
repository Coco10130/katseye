import 'dart:async';

import 'package:eukay/pages/auth/repo/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<AuthLoginRequest>(authLoginRequest);
    on<AuthRegisterRequest>(authRegisterRequest);
    on<SendOtpEvent>(sendOtpEvent);
    on<VerifyOtpEvent>(verifyOtpEvent);
    on<ResetPasswordEvent>(resetPasswordEvent);
  }

  FutureOr<void> authLoginRequest(
      AuthLoginRequest event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response =
          await _authRepository.loginRequest(event.email, event.password);

      if (response.isNotEmpty) {
        emit(AuthLoginSuccess(token: response));
      } else {
        emit(AuthLoginFailure(errorMessage: "Login failed. Please try again."));
      }
    } catch (e) {
      emit(AuthLoginFailure(errorMessage: e.toString()));
    }
  }

  FutureOr<void> authRegisterRequest(
      AuthRegisterRequest event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoading());

      if (event.email.isEmpty ||
          event.userName.isEmpty ||
          event.password.isEmpty ||
          event.confirmPassword.isEmpty) {
        return emit(
            AuthRegisterFailure(errorMessage: "Please fill up all fields"));
      } else if (event.password != event.confirmPassword) {
        return emit(
            AuthRegisterFailure(errorMessage: "Passwords do not match"));
      }

      final response = await _authRepository.registerRequest(
          event.userName, event.email, event.password, event.confirmPassword);

      if (response.isNotEmpty) {
        emit(AuthRegisterSuccess(successMessage: response));
      } else {
        emit(AuthRegisterFailure(
            errorMessage: "Login failed. Please try again"));
      }
    } catch (e) {
      emit(AuthRegisterFailure(errorMessage: e.toString()));
    }
  }

  FutureOr<void> sendOtpEvent(
      SendOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await _authRepository.sendOtp(event.email);

      if (response != null) {
        emit(SendOtpSuccessState(
          otpHash: response,
          successMessage: "OTP sent Successfuly!",
          email: event.email,
        ));
      } else {
        emit(ForgotPasswordFailedState(errorMessage: "Failed to send OTP"));
      }
    } catch (e) {
      emit(ForgotPasswordFailedState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> verifyOtpEvent(
      VerifyOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      final response = await _authRepository.verifyOtp(
          event.email, event.otp, event.otpHash);

      if (response) {
        emit(VerifyOtpSuccessState(
            successMessage: "OTP Verified Successfully",
            otpVerified: response));
      } else {
        throw Exception(response);
      }
    } catch (e) {
      emit(ForgotPasswordFailedState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> resetPasswordEvent(
      ResetPasswordEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      if (event.newPassword != event.confirmPassword) {
        return emit(
            ForgotPasswordFailedState(errorMessage: "Password does not match"));
      }

      if (event.newPassword.isEmpty || event.confirmPassword.isEmpty) {
        return emit(ForgotPasswordFailedState(
            errorMessage: "Please fill in both password fields"));
      }

      final response = await _authRepository.resetPassword(event.newPassword,
          event.confirmPassword, event.email, event.otpVerified);

      if (response) {
        emit(ResetPasswordSuccessState(
            successMessage: "Password Changed Successfully"));
      } else {
        throw Exception(response);
      }
    } catch (e) {
      emit(ForgotPasswordFailedState(errorMessage: e.toString()));
    }
  }
}
