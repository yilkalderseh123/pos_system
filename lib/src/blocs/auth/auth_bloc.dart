import 'package:bloc/bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Box<Map> userBox;

  AuthBloc(this.userBox) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
  }

  void _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      // Example logic for authentication using the Hive userBox
      final user = userBox.get(event.username);

      if (user != null && user['password'] == event.password) {
        emit(AuthAuthenticated(user['role'] ?? 'user'));
      } else {
        emit(AuthFailed('Invalid username or password'));
      }
    } catch (e) {
      emit(AuthFailed('An unexpected error occurred: $e'));
    }
  }
}
