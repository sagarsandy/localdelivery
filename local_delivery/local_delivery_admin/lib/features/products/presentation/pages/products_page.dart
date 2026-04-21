import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_delivery_ui/local_delivery_ui.dart';

import '../../../../core/widgets/ld_confirm_dialog.dart';
import '../../../../di/service_locator.dart';
import '../../../categories/domain/models/category_model.dart';
import '../../../subcategories/domain/models/subcategory_model.dart';
import '../../cubit/products_cubit.dart';
import '../../cubit/products_state.dart';
import '../../domain/models/product_model.dart';
import '../widgets/add_edit_product_sheet_widget.dart';
import '../widgets/products_empty_widget.dart';
import '../widgets/products_list_widget.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  bool _isSheetOpen = false;

  void _showSheet(
    BuildContext context, {
    ProductModel? product,
    required List<CategoryModel> categories,
    required List<SubcategoryModel> allSubcategories,
    String? initialCategory,
    String? initialSubcategory,
  }) {
    final cubit = context.read<ProductsCubit>();
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
        child: AddEditProductSheetWidget(
          product: product,
          categories: categories,
          allSubcategories: allSubcategories,
          initialCategory: initialCategory,
          initialSubcategory: initialSubcategory,
        ),
      ),
    ).whenComplete(() => setState(() => _isSheetOpen = false));
  }

  Future<void> _confirmDelete(
      BuildContext context, ProductModel product) async {
    final confirmed = await LDConfirmDialog.show(
      context,
      title: 'Delete Product',
      message: 'Delete "${product.title}"? This cannot be undone.',
      confirmLabel: 'Delete',
      confirmColor: LDColors.error,
      icon: Icons.delete_outline,
    );
    if (confirmed == true && context.mounted) {
      context.read<ProductsCubit>().deleteProduct(id: product.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator<ProductsCubit>()..load(),
      child: BlocConsumer<ProductsCubit, ProductsState>(
        listener: (context, state) {
          if (state is ProductActionSuccess) {
            if (_isSheetOpen) Navigator.of(context).pop();
            LDToast.show(context,
                message: state.message, type: LDToastType.success);
          } else if (state is ProductActionError) {
            LDToast.show(context,
                message: state.message, type: LDToastType.error);
          }
        },
        builder: (context, state) {
          final products = switch (state) {
            ProductsLoaded(products: final p) => p,
            ProductActionInProgress(products: final p) => p,
            ProductActionSuccess(products: final p) => p,
            ProductActionError(products: final p) => p,
            _ => null,
          };

          final categories = switch (state) {
            ProductsLoaded(categories: final c) => c,
            ProductActionInProgress(categories: final c) => c,
            ProductActionSuccess(categories: final c) => c,
            ProductActionError(categories: final c) => c,
            _ => <CategoryModel>[],
          };

          final subcategories = switch (state) {
            ProductsLoaded(subcategories: final s) => s,
            ProductActionInProgress(subcategories: final s) => s,
            ProductActionSuccess(subcategories: final s) => s,
            ProductActionError(subcategories: final s) => s,
            _ => <SubcategoryModel>[],
          };

          final selectedCategory = switch (state) {
            ProductsLoaded(selectedCategory: final s) => s,
            ProductActionInProgress(selectedCategory: final s) => s,
            ProductActionSuccess(selectedCategory: final s) => s,
            ProductActionError(selectedCategory: final s) => s,
            _ => null,
          };

          final selectedSubcategory = switch (state) {
            ProductsLoaded(selectedSubcategory: final s) => s,
            ProductActionInProgress(selectedSubcategory: final s) => s,
            ProductActionSuccess(selectedSubcategory: final s) => s,
            ProductActionError(selectedSubcategory: final s) => s,
            _ => null,
          };

          // Full (unfiltered) subcategory list for cascading dropdowns in sheet.
          final allSubcategories =
              context.read<ProductsCubit>().allSubcategories;

          return Stack(
            children: [
              if (state is ProductsLoading && products == null)
                const LDLoadingWidget()
              else if (state is ProductsError)
                LDErrorWidget(
                  message: state.message,
                  onRetry: () => context.read<ProductsCubit>().load(),
                )
              else if (products != null) ...[
                Column(
                  children: [
                    if (categories.isNotEmpty)
                      _ProductFilterBar(
                        categories: categories,
                        subcategories: subcategories,
                        selectedCategory: selectedCategory,
                        selectedSubcategory: selectedSubcategory,
                        onCategoryChanged: (v) =>
                            context.read<ProductsCubit>().filterByCategory(v),
                        onSubcategoryChanged: (v) =>
                            context.read<ProductsCubit>().filterBySubcategory(v),
                      ),
                    Expanded(
                      child: products.isEmpty
                          ? const ProductsEmptyWidget()
                          : ProductsListWidget(
                              products: products,
                              isMutating: state is ProductActionInProgress,
                              onEdit: (p) => _showSheet(
                                context,
                                product: p,
                                categories: categories,
                                allSubcategories: allSubcategories,
                              ),
                              onDelete: (p) => _confirmDelete(context, p),
                            ),
                    ),
                  ],
                ),
                Positioned(
                  right: 16,
                  bottom: 16,
                  child: FloatingActionButton.extended(
                    heroTag: null,
                    onPressed: state is ProductActionInProgress
                        ? null
                        : () => _showSheet(
                              context,
                              categories: categories,
                              allSubcategories: allSubcategories,
                              initialCategory: selectedCategory,
                              initialSubcategory: selectedSubcategory,
                            ),
                    backgroundColor: LDColors.primary,
                    foregroundColor: Colors.white,
                    icon: const Icon(Icons.add),
                    label: const Text(
                      'Add Product',
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

class _ProductFilterBar extends StatelessWidget {
  const _ProductFilterBar({
    required this.categories,
    required this.subcategories,
    required this.selectedCategory,
    required this.selectedSubcategory,
    required this.onCategoryChanged,
    required this.onSubcategoryChanged,
  });

  final List<CategoryModel> categories;
  final List<SubcategoryModel> subcategories;
  final String? selectedCategory;
  final String? selectedSubcategory;
  final ValueChanged<String?> onCategoryChanged;
  final ValueChanged<String?> onSubcategoryChanged;

  InputDecoration _decoration(String label) => InputDecoration(
        labelText: label,
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
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      color: LDColors.surface,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(
        children: [
          DropdownButtonFormField<String>(
            initialValue: selectedCategory,
            decoration: _decoration('Filter by Category'),
            hint: const Text('All categories'),
            items: [
              const DropdownMenuItem(
                  value: null, child: Text('All categories')),
              ...categories.map(
                (c) => DropdownMenuItem(
                  value: c.title.toLowerCase(),
                  child: Text(c.title),
                ),
              ),
            ],
            onChanged: onCategoryChanged,
          ),
          if (selectedCategory != null) ...[
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              key: ValueKey(selectedCategory),
              initialValue: selectedSubcategory,
              decoration: _decoration('Filter by Subcategory'),
              hint: const Text('All subcategories'),
              items: [
                const DropdownMenuItem(
                    value: null, child: Text('All subcategories')),
                ...subcategories.map(
                  (s) => DropdownMenuItem(
                    value: s.title.toLowerCase(),
                    child: Text(s.title),
                  ),
                ),
              ],
              onChanged: onSubcategoryChanged,
            ),
          ],
        ],
      ),
    );
  }
}
