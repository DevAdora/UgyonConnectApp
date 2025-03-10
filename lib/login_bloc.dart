// login_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginButtonPressed>(_onLoginButtonPressed);
  }

  // Define the function that handles the event when login is pressed
  Future<void> _onLoginButtonPressed(
      LoginButtonPressed event, Emitter<LoginState> emit) async {
    emit(LoginLoading());

    // Simulate login logic (e.g., API call)
    await Future.delayed(const Duration(seconds: 2)); // Simulated delay

    // Replace this with your authentication logic
    if (event.email == 'user@example.com' && event.password == 'password123') {
      emit(LoginInitial()); // Login success (you can define a LoginSuccess state)
    } else {
      emit(LoginFailure(error: 'Invalid email or password'));
    }
  }
}