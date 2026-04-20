import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../repositories/address_repository.dart';

class DeleteAddressUseCase {
  const DeleteAddressUseCase(this._repository);
  final AddressRepository _repository;

  Future<Either<Failure, void>> deleteAddress({required String addressId}) =>
      _repository.deleteAddress(addressId: addressId);
}
