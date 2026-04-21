import 'package:equatable/equatable.dart';

abstract class OtpState extends Equatable {
  const OtpState();
  @override
  List<Object?> get props => [];
}

class OtpInitial extends OtpState {}
class OtpLoading extends OtpState {}
class OtpVerified extends OtpState {}
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
