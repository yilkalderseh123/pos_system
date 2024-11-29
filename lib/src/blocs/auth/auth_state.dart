abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String role; // Example: "admin", "user", etc.
  AuthAuthenticated(this.role);
}

class AuthFailed extends AuthState {
  final String message;
  AuthFailed(this.message);
}
