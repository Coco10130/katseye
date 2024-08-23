import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthLoginRequest>((event, emit) async {
      emit(AuthLoading());

      try {
        final email = event.email;
        final password = event.password;

        if (password.length <= 8) {
          return emit(
              AuthLoginFailure("Password cannot be less than 8 characters"));
        }

        await Future.delayed(const Duration(seconds: 1), () {
          return emit(AuthLoginSuccess(id: "$email-$password"));
        });
      } catch (e) {
        return emit(AuthLoginFailure(e.toString()));
      }
    });

    on<AuthRegisterRequest>((event, emit) async {
      emit(AuthLoading());
      try {
        final email = event.email;
        final password = event.password;
        final confirmPassword = event.confirmPassword;
        final name = event.name;

        if (name.length < 4) {
          return emit(
              AuthRegisterFailure("User name must be at least 4 characters"));
        }

        if (password.length <= 8) {
          return emit(
              AuthRegisterFailure("Password cannot be less than 8 characters"));
        }

        if (password != confirmPassword) {
          return emit(AuthRegisterFailure("Passwords do not match"));
        }

        await Future.delayed(const Duration(seconds: 1), () {
          return emit(AuthRegisterSuccess(email: email, password: password, name: name));
        });
      } catch (e) {
        return emit(AuthRegisterFailure(e.toString()));
      }
    });
  }
}
