import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:local_delivery_ui/local_delivery_ui.dart';
import '../../../../di/service_locator.dart';
import '../../../../app/router/ld_app_routes.dart';
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

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
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

class _ProfileContent extends StatelessWidget {
  const _ProfileContent({required this.state});
  final ProfileLoaded state;

  @override
  Widget build(BuildContext context) {
    final user = state.user;
    return ListView(
      children: [
        // Avatar + info header
        Container(
          color: LDColors.primary.withOpacity(0.08),
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 36,
                backgroundColor: LDColors.primary,
                backgroundImage: user.avatarUrl != null
                    ? NetworkImage(user.avatarUrl!)
                    : null,
                child: user.avatarUrl == null
                    ? Text(
                        (user.name?.isNotEmpty == true)
                            ? user.name![0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name ?? 'No Name',
                    style: context.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.phone,
                    style: context.bodyMedium
                        .copyWith(color: LDColors.textSecondary),
                  ),
                  if (user.email != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      user.email!,
                      style: context.bodySmall
                          .copyWith(color: LDColors.textSecondary),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Menu items
        _ProfileMenuItem(
          icon: Icons.receipt_long_outlined,
          label: 'My Orders',
          onTap: () => context.push(LDAppRoute.orders.path),
        ),
        _ProfileMenuItem(
          icon: Icons.location_on_outlined,
          label: 'My Addresses',
          onTap: () => context.push(LDAppRoute.addresses.path),
        ),
        const Divider(height: 1),
        _ProfileMenuItem(
          icon: Icons.logout_outlined,
          label: 'Logout',
          color: LDColors.error,
          onTap: () async {
            await context.read<ProfileCubit>().signOut();
            if (context.mounted) {
              context.go(LDAppRoute.login.path);
            }
          },
        ),
      ],
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  const _ProfileMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? LDColors.textPrimary;
    return ListTile(
      leading: Icon(icon, color: effectiveColor),
      title: Text(label,
          style: context.bodyMedium.copyWith(color: effectiveColor)),
      trailing: color == null
          ? const Icon(Icons.chevron_right, color: LDColors.textSecondary)
          : null,
      onTap: onTap,
    );
  }
}
