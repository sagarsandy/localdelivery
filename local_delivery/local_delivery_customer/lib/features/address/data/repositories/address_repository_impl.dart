import 'package:dartz/dartz.dart';

import '../../../../core/utils/failure.dart';
import '../../domain/models/address_model.dart';
import '../../domain/repositories/address_repository.dart';
import '../dto/address_dto.dart';
import '../sources/address_remote_source.dart';

class AddressRepositoryImpl implements AddressRepository {
  const AddressRepositoryImpl(this._source);
  final AddressRemoteSource _source;

  @override
  Future<Either<Failure, List<AddressModel>>> getAddresses({
    required String phone,
  }) async {
    try {
      final dtos = await _source.fetchAddresses(phone: phone);
      return Right(dtos.map((dto) => dto.toDomain()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AddressModel>> saveAddress(
      AddressModel address) async {
    try {
      final dto = await _source.saveAddress(
        dto: AddressDto.fromDomain(address),
      );
      return Right(dto.toDomain());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAddress({
    required String addressId,
  }) async {
    try {
      await _source.deleteAddress(addressId: addressId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> setActiveAddress({
    required String phone,
    required String addressId,
  }) async {
    try {
      await _source.setActiveAddress(phone: phone, addressId: addressId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
