import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../models/address_model.dart';
import '../repositories/address_repository.dart';

class GetAddressesUseCase {
  const GetAddressesUseCase(this._repository);
  final AddressRepository _repository;

  Future<Either<Failure, List<AddressModel>>> getAddresses({required String phone}) =>
      _repository.getAddresses(phone: phone);
}
