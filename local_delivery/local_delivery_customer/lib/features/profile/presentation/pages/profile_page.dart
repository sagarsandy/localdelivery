import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:local_delivery_ui/local_delivery_ui.dart';

import '../../../../app/router/ld_app_routes.dart';
import '../../../../di/service_locator.dart';
import '../../cubit/profile_cubit.dart';
import '../../cubit/profile_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator<ProfileCubit>()..loadProfile(),
      child: const _ProfileView(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shell
// ─────────────────────────────────────────────────────────────────────────────
class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) return const LDLoadingWidget();
          if (state is ProfileError) {
            return LDErrorWidget(
              message: state.message,
              onRetry: () => context.read<ProfileCubit>().loadProfile(),
            );
          }
          if (state is ProfileLoaded) {
            return _ProfileContent(state: state);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Loaded content
// ─────────────────────────────────────────────────────────────────────────────
class _ProfileContent extends StatelessWidget {
  const _ProfileContent({required this.state});
  final ProfileLoaded state;

  @override
  Widget build(BuildContext context) {
    final user = state.user;

    return CustomScrollView(
      slivers: [
        // ── Header — avatar + name + phone
        SliverToBoxAdapter(
          child: _ProfileHeaderWidget(
            name: user.name,
            phone: user.phone,
          ),
        ),

        // ── Main menu card
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: _MenuCardWidget(
              items: [
                _MenuItemWidget(
                  icon: Icons.menu_book_rounded,
                  label: 'Address Book',
                  onTap: () => context.push(LDAppRoute.addresses.path),
                ),
                _MenuItemWidget(
                  icon: Icons.card_giftcard_rounded,
                  label: 'Refer & Earn',
                  onTap: () => context.push(LDAppRoute.referEarn.path),
                ),
                _MenuItemWidget(
                  icon: Icons.headset_mic_rounded,
                  label: 'Support',
                  onTap: () => context.push(LDAppRoute.support.path),
                ),
                _MenuItemWidget(
                  icon: Icons.info_outline_rounded,
                  label: 'About Us',
                  onTap: () => context.push(LDAppRoute.aboutUs.path),
                ),
              ],
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 12)),

        // ── Logout — separate card so it stands visually apart
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _MenuCardWidget(
              items: [
                _MenuItemWidget(
                  icon: Icons.logout_rounded,
                  label: 'Logout',
                  labelColor: const Color(0xFFD32F2F),
                  iconColor: const Color(0xFFD32F2F),
                  showChevron: false,
                  onTap: () async {
                    await context.read<ProfileCubit>().signOut();
                    if (context.mounted) context.go(LDAppRoute.login.path);
                  },
                ),
              ],
            ),
          ),
        ),

        // Bottom spacing to clear floating tab bar
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Header — avatar, name, phone
// ─────────────────────────────────────────────────────────────────────────────
class _ProfileHeaderWidget extends StatelessWidget {
  const _ProfileHeaderWidget({required this.name, required this.phone});

  final String? name;
  final String phone;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        24,
        MediaQuery.paddingOf(context).top + 32,
        24,
        32,
      ),
      color: const Color(0xFFF5F5F5),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade300,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.10),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.person_rounded,
              size: 54,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 16),

          // Name (hidden when absent)
          if (name != null && name!.isNotEmpty) ...[
            Text(
              name!,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
          ],

          // Phone
          Text(
            phone.isNotEmpty ? phone : '—',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// White card wrapping a list of menu rows
// ─────────────────────────────────────────────────────────────────────────────
class _MenuCardWidget extends StatelessWidget {
  const _MenuCardWidget({required this.items});
  final List<_MenuItemWidget> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            items[i],
            if (i < items.length - 1)
              Divider(
                height: 1,
                indent: 56,
                endIndent: 0,
                color: Colors.grey.shade100,
              ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Single tappable menu row
// ─────────────────────────────────────────────────────────────────────────────
class _MenuItemWidget extends StatelessWidget {
  const _MenuItemWidget({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
    this.labelColor,
    this.showChevron = true,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? labelColor;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    final effectiveIconColor = iconColor ?? LDColors.primary;
    final effectiveLabelColor = labelColor ?? Colors.black87;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        child: Row(
          children: [
            // Icon in a soft tinted circle
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: effectiveIconColor.withOpacity(0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 20, color: effectiveIconColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: effectiveLabelColor,
                ),
              ),
            ),
            if (showChevron)
              Icon(
                Icons.chevron_right_rounded,
                size: 22,
                color: Colors.grey.shade400,
              ),
          ],
        ),
      ),
    );
  }
}
