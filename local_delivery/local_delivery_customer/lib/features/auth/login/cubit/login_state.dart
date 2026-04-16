import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  const LoginState();
  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}
class LoginLoading extends LoginState {}
class LoginOtpSent extends LoginState {}
class LoginError extends LoginState {
  const LoginError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
