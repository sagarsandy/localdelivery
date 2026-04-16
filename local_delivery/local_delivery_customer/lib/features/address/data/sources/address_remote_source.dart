import '../dto/address_dto.dart';

abstract class AddressRemoteSource {
  Future<List<AddressDto>> fetchAddresses({required String userId});
  Future<AddressDto> saveAddress({required AddressDto dto});
  Future<void> deleteAddress({required String addressId});
}
