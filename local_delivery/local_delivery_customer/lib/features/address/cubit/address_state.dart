import 'package:equatable/equatable.dart';
import '../domain/models/address_model.dart';

abstract class AddressState extends Equatable {
  const AddressState();
  @override
  List<Object?> get props => [];
}

class AddressInitial extends AddressState {}

class AddressLoading extends AddressState {}

class AddressLoaded extends AddressState {
  const AddressLoaded(this.addresses);
  final List<AddressModel> addresses;

  /// The currently active address, or null if none is set.
  AddressModel? get activeAddress =>
      addresses.where((a) => a.isActive).isNotEmpty
          ? addresses.firstWhere((a) => a.isActive)
          : null;

  @override
  List<Object?> get props => [addresses];
}

class AddressSaving extends AddressState {}

class AddressSaved extends AddressState {
  const AddressSaved(this.address);
  final AddressModel address;
  @override
  List<Object?> get props => [address];
}

class AddressDeleting extends AddressState {}

class AddressError extends AddressState {
  const AddressError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
