import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_delivery_ui/local_delivery_ui.dart';

import '../../../../core/widgets/ld_confirm_dialog.dart';
import '../../../../di/service_locator.dart';
import '../../../categories/domain/models/category_model.dart';
import '../../cubit/subcategories_cubit.dart';
import '../../cubit/subcategories_state.dart';
import '../../domain/models/subcategory_model.dart';
import '../widgets/add_edit_subcategory_sheet_widget.dart';
import '../widgets/subcategories_empty_widget.dart';
import '../widgets/subcategory_grid_widget.dart';

class SubcategoriesPage extends StatefulWidget {
  const SubcategoriesPage({super.key});

  @override
  State<SubcategoriesPage> createState() => _SubcategoriesPageState();
}

class _SubcategoriesPageState extends State<SubcategoriesPage> {
  bool _isSheetOpen = false;

  void _showSheet(
    BuildContext context, {
    SubcategoryModel? subcategory,
    required List<CategoryModel> categories,
    String? initialCategory,
  }) {
    final cubit = context.read<SubcategoriesCubit>();
    setState(() => _isSheetOpen = true);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: LDColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: AddEditSubcategorySheetWidget(
          subcategory: subcategory,
          categories: categories,
          initialCategory: initialCategory,
        ),
      ),
    ).whenComplete(() => setState(() => _isSheetOpen = false));
  }

  Future<void> _confirmDelete(
      BuildContext context, SubcategoryModel subcategory) async {
    final confirmed = await LDConfirmDialog.show(
      context,
      title: 'Delete Subcategory',
      message: 'Delete "${subcategory.title}"? This cannot be undone.',
      confirmLabel: 'Delete',
      confirmColor: LDColors.error,
      icon: Icons.delete_outline,
    );
    if (confirmed == true && context.mounted) {
      context.read<SubcategoriesCubit>().deleteSubcategory(id: subcategory.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator<SubcategoriesCubit>()..load(),
      child: BlocConsumer<SubcategoriesCubit, SubcategoriesState>(
        listener: (context, state) {
          if (state is SubcategoryActionSuccess) {
            if (_isSheetOpen) Navigator.of(context).pop();
            LDToast.show(context,
                message: state.message, type: LDToastType.success);
          } else if (state is SubcategoryActionError) {
            LDToast.show(context,
                message: state.message, type: LDToastType.error);
          }
        },
        builder: (context, state) {
          final subcategories = switch (state) {
            SubcategoriesLoaded(subcategories: final s) => s,
            SubcategoryActionInProgress(subcategories: final s) => s,
            SubcategoryActionSuccess(subcategories: final s) => s,
            SubcategoryActionError(subcategories: final s) => s,
            _ => null,
          };

          final categories = switch (state) {
            SubcategoriesLoaded(categories: final c) => c,
            SubcategoryActionInProgress(categories: final c) => c,
            SubcategoryActionSuccess(categories: final c) => c,
            SubcategoryActionError(categories: final c) => c,
            _ => <CategoryModel>[],
          };

          final selectedCategory = switch (state) {
            SubcategoriesLoaded(selectedCategory: final s) => s,
            SubcategoryActionInProgress(selectedCategory: final s) => s,
            SubcategoryActionSuccess(selectedCategory: final s) => s,
            SubcategoryActionError(selectedCategory: final s) => s,
            _ => null,
          };

          return Stack(
            children: [
              if (state is SubcategoriesLoading && subcategories == null)
                const LDLoadingWidget()
              else if (state is SubcategoriesError)
                LDErrorWidget(
                  message: state.message,
                  onRetry: () => context.read<SubcategoriesCubit>().load(),
                )
              else if (subcategories != null) ...[
                Column(
                  children: [
                    if (categories.isNotEmpty)
                      _CategoryFilterBar(
                        categories: categories,
                        selectedCategory: selectedCategory,
                        onChanged: (v) => context
                            .read<SubcategoriesCubit>()
                            .filterByCategory(v),
                      ),
                    Expanded(
                      child: subcategories.isEmpty
                          ? const SubcategoriesEmptyWidget()
                          : SubcategoryGridWidget(
                              subcategories: subcategories,
                              categories: categories,
                              isMutating: state is SubcategoryActionInProgress,
                              onEdit: (sub) => _showSheet(
                                context,
                                subcategory: sub,
                                categories: categories,
                              ),
                              onDelete: (sub) => _confirmDelete(context, sub),
                            ),
                    ),
                  ],
                ),
                Positioned(
                  right: 16,
                  bottom: 16,
                  child: FloatingActionButton.extended(
                    heroTag: null,
                    onPressed: state is SubcategoryActionInProgress
                        ? null
                        : () => _showSheet(
                              context,
                              categories: categories,
                              initialCategory: selectedCategory,
                            ),
                    backgroundColor: LDColors.primary,
                    foregroundColor: Colors.white,
                    icon: const Icon(Icons.add),
                    label: const Text(
                      'Add Subcategory',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _CategoryFilterBar extends StatelessWidget {
  const _CategoryFilterBar({
    required this.categories,
    required this.selectedCategory,
    required this.onChanged,
  });

  final List<CategoryModel> categories;

  /// Lowercase category title currently selected; null = all.
  final String? selectedCategory;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: LDColors.surface,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: DropdownButtonFormField<String>(
        initialValue: selectedCategory,
        decoration: InputDecoration(
          labelText: 'Filter by Category',
          filled: true,
          fillColor: LDColors.inputFill,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: LDColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: LDColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: LDColors.primary, width: 1.5),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        hint: const Text('All categories'),
        items: [
          const DropdownMenuItem(value: null, child: Text('All categories')),
          ...categories.map(
            (c) => DropdownMenuItem(
              value: c.title.toLowerCase(),
              child: Text(c.title),
            ),
          ),
        ],
        onChanged: onChanged,
      ),
    );
  }
}
