import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../models/address_model.dart';

abstract class AddressRepository {
  /// Fetch all addresses for [phone].
  Future<Either<Failure, List<AddressModel>>> getAddresses({
    required String phone,
  });

  Future<Either<Failure, AddressModel>> saveAddress(AddressModel address);

  Future<Either<Failure, void>> deleteAddress({required String addressId});

  /// Mark [addressId] as the active address, deactivating all others for [phone].
  Future<Either<Failure, void>> setActiveAddress({
    required String phone,
    required String addressId,
  });
}
