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
}
