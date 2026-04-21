import 'package:flutter/material.dart';
import 'package:local_delivery_ui/local_delivery_ui.dart';

import '../../../categories/presentation/pages/categories_page.dart';
import '../widgets/admin_drawer_widget.dart';
import '../widgets/section_placeholder_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AdminSection _selected = AdminSection.dashboard;

  Widget _buildSection(AdminSection section) {
    return switch (section) {
      AdminSection.categories => const CategoriesPage(),
      _ => SectionPlaceholderWidget(section: section),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LDColors.background,
      appBar: AppBar(
        backgroundColor: LDColors.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: LDColors.border,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu_rounded, color: LDColors.textPrimary),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text(
          _selected.label,
          style: context.titleLarge,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: const Icon(Icons.notifications_none_rounded,
                  color: LDColors.textSecondary),
              onPressed: () {},
            ),
          ),
        ],
      ),
      drawer: AdminDrawerWidget(
        selectedSection: _selected,
        onSectionSelected: (section) => setState(() => _selected = section),
      ),
      body: IndexedStack(
        index: _selected.index,
        children: AdminSection.values.map(_buildSection).toList(),
      ),
    );
  }
}
