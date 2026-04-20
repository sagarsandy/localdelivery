import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../repositories/address_repository.dart';

class SetActiveAddressUseCase {
  const SetActiveAddressUseCase(this._repository);
  final AddressRepository _repository;

  Future<Either<Failure, void>> setActiveAddress({
    required String phone,
    required String addressId,
  }) =>
      _repository.setActiveAddress(phone: phone, addressId: addressId);
}
