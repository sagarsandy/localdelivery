import '../dto/address_dto.dart';

abstract class AddressRemoteSource {
  /// Fetch all addresses belonging to [phone].
  Future<List<AddressDto>> fetchAddresses({required String phone});

  /// Save (create or update) an address. Returns the saved DTO with server id.
  Future<AddressDto> saveAddress({required AddressDto dto});

  /// Permanently delete an address document.
  Future<void> deleteAddress({required String addressId});

  /// Mark [addressId] as active and deactivate all other addresses for [phone].
  Future<void> setActiveAddress({
    required String phone,
    required String addressId,
  });
}
