import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:local_delivery_ui/local_delivery_ui.dart';

import '../../../../core/session/user_session.dart';
import '../../../../di/service_locator.dart';
import '../../cubit/address_cubit.dart';
import '../../cubit/address_state.dart';
import '../../domain/models/address_model.dart';

class AddAddressPage extends StatelessWidget {
  const AddAddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: locator<AddressCubit>(),
      child: const _AddAddressView(),
    );
  }
}

class _AddAddressView extends StatefulWidget {
  const _AddAddressView();

  @override
  State<_AddAddressView> createState() => _AddAddressViewState();
}

class _AddAddressViewState extends State<_AddAddressView> {
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _stateController = TextEditingController();

  String? _addressError;
  String? _cityError;
  String? _stateError;
  String? _pincodeError;

  @override
  void dispose() {
    _addressController.dispose();
    _cityController.dispose();
    _pincodeController.dispose();
    _stateController.dispose();
    super.dispose();
  }

  bool _validate() {
    String? addressError;
    String? cityError;
    String? stateError;
    String? pincodeError;

    if (_addressController.text.trim().isEmpty) {
      addressError = 'Please enter your address';
    }
    if (_cityController.text.trim().isEmpty) {
      cityError = 'Please enter your city';
    }
    if (_stateController.text.trim().isEmpty) {
      stateError = 'Please enter your state';
    }
    if (_pincodeController.text.trim().isEmpty) {
      pincodeError = 'Please enter your pincode';
    } else if (_pincodeController.text.trim().length != 6) {
      pincodeError = 'Pincode must be 6 digits';
    }

    setState(() {
      _addressError = addressError;
      _cityError = cityError;
      _stateError = stateError;
      _pincodeError = pincodeError;
    });

    return addressError == null &&
        cityError == null &&
        stateError == null &&
        pincodeError == null;
  }

  void _submit(BuildContext context) {
    if (!_validate()) return;

    final phone = UserSession.instance.phoneNumber ?? '';
    if (phone.isEmpty) {
      LDToast.show(context,
          message: 'Unable to verify user. Please log in again.',
          type: LDToastType.error);
      return;
    }

    context.read<AddressCubit>().saveAddress(
          AddressModel(
            id: '',
            phone: phone,
            address: _addressController.text.trim(),
            city: _cityController.text.trim(),
            pincode: _pincodeController.text.trim(),
            state: _stateController.text.trim(),
            isActive: false,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddressCubit, AddressState>(
      listener: (context, state) {
        if (state is AddressSaved) {
          LDToast.show(context,
              message: 'Address saved!', type: LDToastType.success);
          context.pop();
        } else if (state is AddressError) {
          LDToast.show(context,
              message: state.message, type: LDToastType.error);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
            onPressed: () => context.pop(),
          ),
          title: const Text(
            'Add Address',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Divider(height: 1, color: Colors.grey.shade200),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Address ───────────────────────────────────────────────
              LDTextField(
                controller: _addressController,
                label: 'Address',
                hint: 'House / Flat No., Street, Area',
                textInputAction: TextInputAction.next,
                maxLines: 2,
                errorText: _addressError,
                onChanged: (_) {
                  if (_addressError != null) {
                    setState(() => _addressError = null);
                  }
                },
              ),
              const SizedBox(height: 14),

              // ── City ──────────────────────────────────────────────────
              LDTextField(
                controller: _cityController,
                label: 'City',
                hint: 'e.g. Bengaluru',
                textInputAction: TextInputAction.next,
                errorText: _cityError,
                onChanged: (_) {
                  if (_cityError != null) setState(() => _cityError = null);
                },
              ),
              const SizedBox(height: 14),

              // ── State ─────────────────────────────────────────────────
              LDTextField(
                controller: _stateController,
                label: 'State',
                hint: 'e.g. Karnataka',
                textInputAction: TextInputAction.next,
                errorText: _stateError,
                onChanged: (_) {
                  if (_stateError != null) setState(() => _stateError = null);
                },
              ),
              const SizedBox(height: 14),

              // ── Pincode ───────────────────────────────────────────────
              LDTextField(
                controller: _pincodeController,
                label: 'Pincode',
                hint: '560001',
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                textInputAction: TextInputAction.done,
                errorText: _pincodeError,
                onChanged: (_) {
                  if (_pincodeError != null) {
                    setState(() => _pincodeError = null);
                  }
                },
              ),
              const SizedBox(height: 32),

              // ── Save button ───────────────────────────────────────────
              BlocBuilder<AddressCubit, AddressState>(
                builder: (context, state) => LDButton(
                  label: 'Save Address',
                  isLoading: state is AddressSaving,
                  onPressed: () => _submit(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
