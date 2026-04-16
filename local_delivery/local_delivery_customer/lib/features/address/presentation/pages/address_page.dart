import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:local_delivery_ui/local_delivery_ui.dart';
import '../../../../di/service_locator.dart';
import '../../../../app/router/ld_app_routes.dart';
import '../../domain/models/address_model.dart';
import '../../cubit/address_cubit.dart';
import '../../cubit/address_state.dart';

class AddressPage extends StatelessWidget {
  const AddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator<AddressCubit>()..loadAddresses(),
      child: const _AddressView(),
    );
  }
}

class _AddressView extends StatelessWidget {
  const _AddressView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Addresses')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(LDAppRoute.addAddress.path),
        icon: const Icon(Icons.add),
        label: const Text('Add Address'),
      ),
      body: BlocBuilder<AddressCubit, AddressState>(
        builder: (context, state) {
          if (state is AddressLoading) return const LDLoadingWidget();
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
              padding: const EdgeInsets.all(16),
              itemCount: state.addresses.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) =>
                  _AddressCard(address: state.addresses[index]),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  const _AddressCard({required this.address});
  final AddressModel address;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              address.label == 'Home'
                  ? Icons.home_outlined
                  : address.label == 'Work'
                      ? Icons.work_outline
                      : Icons.location_on_outlined,
              color: LDColors.primary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(address.label,
                          style: context.titleSmall),
                      if (address.isDefault) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: LDColors.primary.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Default',
                            style: context.labelSmall
                                .copyWith(color: LDColors.primary),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    address.fullAddress,
                    style: context.bodySmall
                        .copyWith(color: LDColors.textSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
