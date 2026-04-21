import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:local_delivery_ui/local_delivery_ui.dart';

import '../../cubit/coupons_cubit.dart';
import '../../cubit/coupons_state.dart';
import '../../domain/models/coupon_model.dart';

class AddEditCouponSheetWidget extends StatefulWidget {
  const AddEditCouponSheetWidget({super.key, this.coupon});

  final CouponModel? coupon;

  @override
  State<AddEditCouponSheetWidget> createState() =>
      _AddEditCouponSheetWidgetState();
}

class _AddEditCouponSheetWidgetState extends State<AddEditCouponSheetWidget> {
  final _codeController = TextEditingController();
  final _descController = TextEditingController();
  final _valueController = TextEditingController();

  CouponType _type = CouponType.amount;
  bool _isActive = true;
  DateTime _expiryDate = DateTime.now().add(const Duration(days: 30));

  bool get _isEdit => widget.coupon != null;
  bool get _isValid =>
      _codeController.text.trim().isNotEmpty &&
      int.tryParse(_valueController.text.trim()) != null &&
      int.parse(_valueController.text.trim()) > 0;

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      final c = widget.coupon!;
      _codeController.text = c.coupon;
      _descController.text = c.description;
      _valueController.text = c.value.toString();
      _type = c.type;
      _isActive = c.isActive;
      _expiryDate = c.expiryDate;
    }
    _codeController.addListener(() => setState(() {}));
    _valueController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _codeController.dispose();
    _descController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _expiryDate.isAfter(DateTime.now())
          ? _expiryDate
          : DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null) setState(() => _expiryDate = picked);
  }

  void _submit(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    final coupon = CouponModel(
      id: _isEdit ? widget.coupon!.id : '',
      coupon: _codeController.text.trim().toUpperCase(),
      description: _descController.text.trim(),
      type: _type,
      value: int.parse(_valueController.text.trim()),
      isActive: _isActive,
      expiryDate: _expiryDate,
    );
    if (_isEdit) {
      context.read<CouponsCubit>().updateCoupon(coupon);
    } else {
      context.read<CouponsCubit>().addCoupon(coupon);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CouponsCubit, CouponsState>(
      builder: (context, state) {
        final isLoading = state is CouponActionInProgress;
        return Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: LDColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text(
                  _isEdit ? 'Edit Coupon' : 'Add Coupon',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 24),
                LDTextField(
                  controller: _codeController,
                  label: 'Coupon Code',
                  hint: 'e.g. SAVE50',
                  textCapitalization: TextCapitalization.characters,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),
                LDTextField(
                  controller: _descController,
                  label: 'Description',
                  hint: 'e.g. Get ₹50 off on orders above ₹500',
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),
                // Type selector
                Row(
                  children: [
                    Text('Type',
                        style: Theme.of(context).textTheme.bodyMedium),
                    const Spacer(),
                    _TypeToggle(
                      selected: _type,
                      onChanged: (t) => setState(() => _type = t),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                LDTextField(
                  controller: _valueController,
                  label:
                      _type == CouponType.amount ? 'Amount (₹)' : 'Percentage (%)',
                  hint: _type == CouponType.amount ? 'e.g. 50' : 'e.g. 10',
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 16),
                // Expiry date picker
                GestureDetector(
                  onTap: () => _pickDate(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: LDColors.inputFill,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: LDColors.border),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined,
                            size: 18, color: LDColors.textSecondary),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Expiry Date',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(color: LDColors.textSecondary),
                            ),
                            Text(
                              DateFormat('dd MMM yyyy').format(_expiryDate),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        const Spacer(),
                        const Icon(Icons.chevron_right,
                            color: LDColors.textSecondary),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Active',
                        style: Theme.of(context).textTheme.bodyMedium),
                    Switch(
                      value: _isActive,
                      onChanged: (v) => setState(() => _isActive = v),
                      activeThumbColor: LDColors.primary,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                LDButton(
                  label: _isEdit ? 'Save Changes' : 'Add Coupon',
                  enabled: _isValid,
                  isLoading: isLoading,
                  onPressed: () => _submit(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TypeToggle extends StatelessWidget {
  const _TypeToggle({required this.selected, required this.onChanged});
  final CouponType selected;
  final ValueChanged<CouponType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: LDColors.inputFill,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: LDColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: CouponType.values.map((type) {
          final isSelected = selected == type;
          return GestureDetector(
            onTap: () => onChanged(type),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? LDColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Text(
                type.label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color:
                          isSelected ? Colors.white : LDColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
