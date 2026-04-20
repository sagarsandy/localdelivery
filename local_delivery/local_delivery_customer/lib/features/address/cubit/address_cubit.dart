import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/location_service.dart';
import '../../../../core/session/user_session.dart';
import '../domain/models/address_model.dart';
import '../domain/use_cases/delete_address_use_case.dart';
import '../domain/use_cases/get_addresses_use_case.dart';
import '../domain/use_cases/save_address_use_case.dart';
import '../domain/use_cases/set_active_address_use_case.dart';
import 'address_state.dart';

class AddressCubit extends Cubit<AddressState> {
  AddressCubit(
    this._getAddressesUseCase,
    this._saveAddressUseCase,
    this._deleteAddressUseCase,
    this._setActiveAddressUseCase,
    this._locationService,
  ) : super(AddressInitial());

  final GetAddressesUseCase _getAddressesUseCase;
  final SaveAddressUseCase _saveAddressUseCase;
  final DeleteAddressUseCase _deleteAddressUseCase;
  final SetActiveAddressUseCase _setActiveAddressUseCase;
  final LocationService _locationService;

  // ─── Public helpers ───────────────────────────────────────────────────────

  /// Called from the splash screen on every app launch.
  ///
  /// Flow:
  ///  1. Load addresses for the signed-in user's phone.
  ///  2. If addresses exist → ensure one is marked active and return.
  ///  3. If no addresses → request location permission.
  ///     • Granted  → fetch current position → reverse-geocode → save.
  ///     • Denied   → quietly finish (no address set).
  Future<void> initializeAddresses() async {
    final phone = UserSession.instance.phoneNumber;
    if (phone == null || phone.isEmpty) {
      emit(const AddressLoaded([]));
      return;
    }

    emit(AddressLoading());

    final result = await _getAddressesUseCase.getAddresses(phone: phone);
    final addresses = result.fold((_) => <AddressModel>[], (list) => list);

    if (addresses.isEmpty) {
      // No saved addresses — try to auto-create one from device location.
      await _autoCreateFromLocation(phone);
    } else {
      final hasActive = addresses.any((a) => a.isActive);
      if (!hasActive) {
        // Silently mark the first address as active.
        await _setActiveAddressUseCase.setActiveAddress(
          phone: phone,
          addressId: addresses.first.id,
        );
        await loadAddresses(phone: phone);
      } else {
        emit(AddressLoaded(addresses));
      }
    }
  }

  /// Loads all addresses for [phone]. Used by the address list page.
  Future<void> loadAddresses({String? phone}) async {
    final resolvedPhone = phone ?? UserSession.instance.phoneNumber;
    if (resolvedPhone == null || resolvedPhone.isEmpty) {
      emit(const AddressLoaded([]));
      return;
    }
    emit(AddressLoading());
    final result =
        await _getAddressesUseCase.getAddresses(phone: resolvedPhone);
    result.fold(
      (failure) => emit(AddressError(failure.message)),
      (list) => emit(AddressLoaded(list)),
    );
  }

  /// Saves (creates or updates) an address.
  Future<void> saveAddress(AddressModel address) async {
    emit(AddressSaving());
    final result = await _saveAddressUseCase.saveAddress(address);
    result.fold(
      (failure) => emit(AddressError(failure.message)),
      (saved) => emit(AddressSaved(saved)),
    );
  }

  /// Deletes an address and reloads the list.
  Future<void> deleteAddress({required String addressId}) async {
    emit(AddressDeleting());
    final result =
        await _deleteAddressUseCase.deleteAddress(addressId: addressId);
    result.fold(
      (failure) => emit(AddressError(failure.message)),
      (_) => loadAddresses(),
    );
  }

  /// Marks [addressId] as the active address for the current user's phone.
  Future<void> setActiveAddress({required String addressId}) async {
    final phone = UserSession.instance.phoneNumber;
    if (phone == null || phone.isEmpty) return;
    await _setActiveAddressUseCase.setActiveAddress(
      phone: phone,
      addressId: addressId,
    );
    await loadAddresses(phone: phone);
  }

  // ─── Private helpers ──────────────────────────────────────────────────────

  Future<void> _autoCreateFromLocation(String phone) async {
    final hasPermission = await _locationService.requestPermission();
    if (!hasPermission) {
      emit(const AddressLoaded([]));
      return;
    }

    final addressModel = await _locationService.getCurrentAddress();
    if (addressModel == null) {
      emit(const AddressLoaded([]));
      return;
    }

    final saveResult = await _saveAddressUseCase.saveAddress(addressModel);
    saveResult.fold(
      (_) => emit(const AddressLoaded([])),
      (saved) => emit(AddressLoaded([saved])),
    );
  }
}
