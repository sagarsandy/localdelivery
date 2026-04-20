import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:local_delivery_ui/local_delivery_ui.dart';

import '../../../../app/router/ld_app_routes.dart';
import '../../../../core/widgets/ld_confirm_dialog.dart';
import '../../../../di/service_locator.dart';
import '../../cubit/address_cubit.dart';
import '../../cubit/address_state.dart';
import '../../domain/models/address_model.dart';

class AddressPage extends StatelessWidget {
  const AddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      // Use the singleton cubit and reload on every visit.
      value: locator<AddressCubit>()..loadAddresses(),
      child: const _AddressView(),
    );
  }
}

class _AddressView extends StatelessWidget {
  const _AddressView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'My Addresses',
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(LDAppRoute.addAddress.path),
        backgroundColor: LDColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Add Address',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
      body: BlocConsumer<AddressCubit, AddressState>(
        listener: (context, state) {
          if (state is AddressSaved) {
            // Reload the list after a new address is saved and the user
            // pops back from AddAddressPage.
            context.read<AddressCubit>().loadAddresses();
          } else if (state is AddressError) {
            LDToast.show(context,
                message: state.message, type: LDToastType.error);
          }
        },
        builder: (context, state) {
          if (state is AddressLoading || state is AddressDeleting) {
            return const LDLoadingWidget();
          }
          if (state is AddressError) {
            return LDErrorWidget(
              message: state.message,
              onRetry: () => context.read<AddressCubit>().loadAddresses(),
            );
          }
          if (state is AddressLoaded) {
            if (state.addresses.isEmpty) {
              return const LDEmptyStateWidget(
                title: 'No addresses saved',
                subtitle: 'Add a delivery address to get started.',
                icon: Icons.location_off_outlined,
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              itemCount: state.addresses.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) => _AddressCard(
                address: state.addresses[index],
                onSetActive: () => context
                    .read<AddressCubit>()
                    .setActiveAddress(addressId: state.addresses[index].id),
                onDelete: () => _confirmDelete(context, state.addresses[index]),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Future<void> _confirmDelete(
      BuildContext context, AddressModel address) async {
    final confirmed = await LDConfirmDialog.show(
      context,
      icon: Icons.delete_outline_rounded,
      title: 'Delete address?',
      message:
          'Are you sure you want to remove "${address.shortAddress}"? This cannot be undone.',
      confirmLabel: 'Delete',
      cancelLabel: 'Cancel',
      confirmColor: Colors.red.shade600,
    );
    if (confirmed == true && context.mounted) {
      context.read<AddressCubit>().deleteAddress(addressId: address.id);
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Address card
// ─────────────────────────────────────────────────────────────────────────────
class _AddressCard extends StatelessWidget {
  const _AddressCard({
    required this.address,
    required this.onSetActive,
    required this.onDelete,
  });

  final AddressModel address;
  final VoidCallback onSetActive;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSetActive,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: address.isActive ? LDColors.primary : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Location icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: address.isActive
                    ? LDColors.primary.withOpacity(0.1)
                    : Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.location_on_outlined,
                color:
                    address.isActive ? LDColors.primary : Colors.grey.shade500,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),

            // Address details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (address.isActive)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: LDColors.primary.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Active',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: LDColors.primary,
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (address.isActive) const SizedBox(height: 4),
                  Text(
                    address.fullAddress,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                      height: 1.5,
                    ),
                  ),
                  if (!address.isActive) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Tap to set as active',
                      style: TextStyle(
                        fontSize: 12,
                        color: LDColors.primary.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Delete button
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline_rounded),
              color: Colors.red.shade400,
              iconSize: 22,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            ),
          ],
        ),
      ),
    );
  }
}
