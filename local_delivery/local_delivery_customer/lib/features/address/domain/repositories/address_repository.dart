import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../models/address_model.dart';

abstract class AddressRepository {
  Future<Either<Failure, List<AddressModel>>> getAddresses({
    required String userId,
  });
  Future<Either<Failure, AddressModel>> saveAddress(AddressModel address);
  Future<Either<Failure, void>> deleteAddress({required String addressId});
}
