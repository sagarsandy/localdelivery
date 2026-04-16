import 'package:flutter/material.dart';

class AddAddressPage extends StatefulWidget {
  const AddAddressPage({super.key});

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final _formKey = GlobalKey<FormState>();
  final _line1Controller = TextEditingController();
  final _line2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _pincodeController = TextEditingController();

  String _selectedLabel = 'Home';
  final _labels = ['Home', 'Work', 'Other'];

  @override
  void dispose() {
    _line1Controller.dispose();
    _line2Controller.dispose();
    _cityController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox();
    // return BlocProvider(
    //   create: (_) => locator<AddressCubit>(),
    //   child: BlocConsumer<AddressCubit, AddressState>(
    //     listener: (context, state) {
    //       if (state is AddressSaved) {
    //         LDToast.show(
    //           context,
    //           message: 'Address saved!',
    //           type: LDToastType.success,
    //         );
    //         context.pop();
    //       } else if (state is AddressError) {
    //         LDToast.show(
    //           context,
    //           message: state.message,
    //           type: LDToastType.error,
    //         );
    //       }
    //     },
    //     builder: (context, state) {
    //       return Scaffold(
    //         appBar: AppBar(title: const Text('Add Address')),
    //         body: SingleChildScrollView(
    //           padding: const EdgeInsets.all(16),
    //           child: Form(
    //             key: _formKey,
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 Text('Label', style: context.titleSmall),
    //                 const SizedBox(height: 8),
    //                 Row(
    //                   children: _labels.map((label) {
    //                     final selected = _selectedLabel == label;
    //                     return Padding(
    //                       padding: const EdgeInsets.only(right: 8),
    //                       child: ChoiceChip(
    //                         label: Text(label),
    //                         selected: selected,
    //                         onSelected: (_) =>
    //                             setState(() => _selectedLabel = label),
    //                         selectedColor: LDColors.primary,
    //                         labelStyle: TextStyle(
    //                           color: selected
    //                               ? Colors.white
    //                               : LDColors.textPrimary,
    //                         ),
    //                       ),
    //                     );
    //                   }).toList(),
    //                 ),
    //                 const SizedBox(height: 16),
    //                 LDTextField(
    //                   controller: _line1Controller,
    //                   label: 'Address Line 1',
    //                   hint: 'House No., Street Name',
    //                   textInputAction: TextInputAction.next,
    //                   validator: (value) => (value == null || value.isEmpty)
    //                       ? 'Required'
    //                       : null,
    //                 ),
    //                 const SizedBox(height: 12),
    //                 LDTextField(
    //                   controller: _line2Controller,
    //                   label: 'Address Line 2 (Optional)',
    //                   hint: 'Landmark, Area',
    //                   textInputAction: TextInputAction.next,
    //                 ),
    //                 const SizedBox(height: 12),
    //                 LDTextField(
    //                   controller: _cityController,
    //                   label: 'City',
    //                   hint: 'City',
    //                   textInputAction: TextInputAction.next,
    //                   validator: (value) => (value == null || value.isEmpty)
    //                       ? 'Required'
    //                       : null,
    //                 ),
    //                 const SizedBox(height: 12),
    //                 LDTextField(
    //                   controller: _pincodeController,
    //                   label: 'Pincode',
    //                   hint: '560001',
    //                   keyboardType: TextInputType.number,
    //                   inputFormatters: [
    //                     FilteringTextInputFormatter.digitsOnly,
    //                     LengthLimitingTextInputFormatter(6),
    //                   ],
    //                   textInputAction: TextInputAction.done,
    //                   validator: (value) {
    //                     if (value == null || value.isEmpty) return 'Required';
    //                     if (value.length != 6) return 'Enter valid pincode';
    //                     return null;
    //                   },
    //                 ),
    //                 const SizedBox(height: 32),
    //                 LDButton(
    //                   label: 'Save Address',
    //                   isLoading: state is AddressSaving,
    //                   onPressed: () {
    //                     if (_formKey.currentState!.validate()) {
    //                       final userId =
    //                           FirebaseService.instance.currentUserId ?? '';
    //                       final address = AddressModel(
    //                         id: '',
    //                         userId: userId,
    //                         label: _selectedLabel,
    //                         addressLine1: _line1Controller.text.trim(),
    //                         addressLine2: _line2Controller.text.trim().isEmpty
    //                             ? null
    //                             : _line2Controller.text.trim(),
    //                         city: _cityController.text.trim(),
    //                         pincode: _pincodeController.text.trim(),
    //                       );
    //                       context.read<AddressCubit>().saveAddress(address);
    //                     }
    //                   },
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //       );
    //     },
    //   ),
    // );
  }
}
