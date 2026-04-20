import 'package:equatable/equatable.dart';

abstract class SplashState extends Equatable {
  const SplashState();
  @override
  List<Object?> get props => [];
}

class SplashInitial extends SplashState {}

class SplashLoading extends SplashState {}

/// Emitted when initialization is complete and the app should navigate.
class SplashNavigate extends SplashState {
  const SplashNavigate(this.route);
  final String route;
  @override
  List<Object?> get props => [route];
}
