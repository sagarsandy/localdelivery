import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../models/address_model.dart';
import '../repositories/address_repository.dart';

class SaveAddressUseCase {
  const SaveAddressUseCase(this._repository);
  final AddressRepository _repository;

  Future<Either<Failure, AddressModel>> saveAddress(AddressModel address) =>
      _repository.saveAddress(address);
}
