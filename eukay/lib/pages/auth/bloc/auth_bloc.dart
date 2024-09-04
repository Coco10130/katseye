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
        emit(AuthLoginFailure("Login failed. Please try again."));
      }
    } catch (e) {
      emit(AuthLoginFailure(e.toString()));
    }
  }

  FutureOr<void> authRegisterRequest(
      AuthRegisterRequest event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await _authRepository.registerRequest(
          event.userName, event.email, event.password, event.confirmPassword);

      if (response.isNotEmpty) {
        emit(AuthRegisterSuccess(successMessage: response));
      } else {
        emit(AuthRegisterFailure("Login failed. Please try again"));
      }
    } catch (e) {
      emit(AuthRegisterFailure(e.toString()));
    }
  }
}
