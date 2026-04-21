import 'package:flutter/material.dart';
import 'package:local_delivery_ui/local_delivery_ui.dart';

enum AdminSection {
  dashboard,
  categories,
  subCategories,
  products,
  coupons,
  orders,
  transactions,
  customers,
  profile,
}

extension AdminSectionExt on AdminSection {
  String get label {
    switch (this) {
      case AdminSection.dashboard: return 'Dashboard';
      case AdminSection.categories: return 'Categories';
      case AdminSection.subCategories: return 'Sub Categories';
      case AdminSection.products: return 'Products';
      case AdminSection.coupons: return 'Coupons';
      case AdminSection.orders: return 'Orders';
      case AdminSection.transactions: return 'Transactions';
      case AdminSection.customers: return 'Customers';
      case AdminSection.profile: return 'Profile';
    }
  }

  IconData get icon {
    switch (this) {
      case AdminSection.dashboard: return Icons.dashboard_outlined;
      case AdminSection.categories: return Icons.category_outlined;
      case AdminSection.subCategories: return Icons.account_tree_outlined;
      case AdminSection.products: return Icons.inventory_2_outlined;
      case AdminSection.coupons: return Icons.local_offer_outlined;
      case AdminSection.orders: return Icons.receipt_long_outlined;
      case AdminSection.transactions: return Icons.payments_outlined;
      case AdminSection.customers: return Icons.people_outline;
      case AdminSection.profile: return Icons.person_outline;
    }
  }
}

class AdminDrawerWidget extends StatelessWidget {
  const AdminDrawerWidget({
    super.key,
    required this.selectedSection,
    required this.onSectionSelected,
  });

  final AdminSection selectedSection;
  final ValueChanged<AdminSection> onSectionSelected;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: LDColors.surface,
      child: SafeArea(
        child: Column(
          children: [
            _DrawerHeader(),
            const Divider(height: 1, color: LDColors.border),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: AdminSection.values.map((section) {
                  final isSelected = section == selectedSection;
                  return _DrawerItem(
                    section: section,
                    isSelected: isSelected,
                    onTap: () {
                      onSectionSelected(section);
                      Navigator.of(context).pop();
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: LDColors.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.eco_rounded, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Local Market',
                style: context.titleMedium.copyWith(
                  color: LDColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Admin Panel',
                style: context.bodySmall.copyWith(color: LDColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.section,
    required this.isSelected,
    required this.onTap,
  });

  final AdminSection section;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Material(
        color: isSelected
            ? LDColors.primary.withValues(alpha: 0.08)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
            child: Row(
              children: [
                Icon(
                  section.icon,
                  size: 20,
                  color: isSelected ? LDColors.primary : LDColors.textSecondary,
                ),
                const SizedBox(width: 14),
                Text(
                  section.label,
                  style: context.bodyMedium.copyWith(
                    color: isSelected ? LDColors.primary : LDColors.textPrimary,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
