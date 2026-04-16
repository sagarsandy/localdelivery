import 'package:equatable/equatable.dart';

abstract class OtpState extends Equatable {
  const OtpState();
  @override
  List<Object?> get props => [];
}

class OtpInitial extends OtpState {}
class OtpLoading extends OtpState {}

/// OTP verified and user already has a profile — navigate to home.
class OtpVerified extends OtpState {}

/// OTP verified but no profile found — prompt user to enter their name.
class OtpVerifiedNeedName extends OtpState {}

class OtpSavingName extends OtpState {}
class OtpResending extends OtpState {}
class OtpResent extends OtpState {}

class OtpError extends OtpState {
  const OtpError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
