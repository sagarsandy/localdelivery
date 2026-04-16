import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/session/user_session.dart';
import '../domain/models/address_model.dart';
import '../domain/use_cases/get_addresses_use_case.dart';
import '../domain/use_cases/save_address_use_case.dart';
import 'address_state.dart';

class AddressCubit extends Cubit<AddressState> {
  AddressCubit(this._getAddressesUseCase, this._saveAddressUseCase)
      : super(AddressInitial());

  final GetAddressesUseCase _getAddressesUseCase;
  final SaveAddressUseCase _saveAddressUseCase;

  Future<void> loadAddresses() async {
    final userId = UserSession.instance.userId;
    if (userId == null) {
      emit(const AddressError('User not logged in.'));
      return;
    }
    emit(AddressLoading());
    final result = await _getAddressesUseCase.getAddresses(userId: userId);
    result.fold(
      (failure) => emit(AddressError(failure.message)),
      (addresses) => emit(AddressLoaded(addresses)),
    );
  }

  Future<void> saveAddress(AddressModel address) async {
    emit(AddressSaving());
    final result = await _saveAddressUseCase.saveAddress(address);
    result.fold(
      (failure) => emit(AddressError(failure.message)),
      (saved) => emit(AddressSaved(saved)),
    );
  }
}
