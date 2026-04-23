part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class CheckAuthStatus extends AuthEvent {}

class GoogleLoginRequested extends AuthEvent {}

class LogIn extends AuthEvent {
  final String userId;
  LogIn(this.userId);
}

class LogOut extends AuthEvent {}
