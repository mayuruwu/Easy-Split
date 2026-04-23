part of 'auth_bloc.dart';

@immutable
sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

final class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String userId;

  const AuthAuthenticated(this.userId);

  @override
  List<Object?> get props => [userId];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}

class NewUserState extends AuthState {
  final String userId;
  const NewUserState(this.userId);

  @override
  List<Object?> get props => [userId];
}
