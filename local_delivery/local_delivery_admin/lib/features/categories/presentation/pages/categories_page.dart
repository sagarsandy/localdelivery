import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_delivery_ui/local_delivery_ui.dart';

import '../../../../core/widgets/ld_confirm_dialog.dart';
import '../../../../di/service_locator.dart';
import '../../cubit/categories_cubit.dart';
import '../../cubit/categories_state.dart';
import '../../domain/models/category_model.dart';
import '../widgets/add_edit_category_sheet_widget.dart';
import '../widgets/categories_empty_widget.dart';
import '../widgets/category_grid_widget.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  bool _isSheetOpen = false;

  void _showSheet(BuildContext context, {CategoryModel? category}) {
    final cubit = context.read<CategoriesCubit>();
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
        child: AddEditCategorySheetWidget(category: category),
      ),
    ).whenComplete(() => setState(() => _isSheetOpen = false));
  }

  Future<void> _confirmDelete(
      BuildContext context, CategoryModel category) async {
    final confirmed = await LDConfirmDialog.show(
      context,
      title: 'Delete Category',
      message: 'Delete "${category.title}"? This cannot be undone.',
      confirmLabel: 'Delete',
      confirmColor: LDColors.error,
      icon: Icons.delete_outline,
    );
    if (confirmed == true && context.mounted) {
      context.read<CategoriesCubit>().deleteCategory(id: category.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator<CategoriesCubit>()..loadCategories(),
      child: BlocConsumer<CategoriesCubit, CategoriesState>(
        listener: (context, state) {
          if (state is CategoryActionSuccess) {
            if (_isSheetOpen) Navigator.of(context).pop();
            LDToast.show(context,
                message: state.message, type: LDToastType.success);
          } else if (state is CategoryActionError) {
            LDToast.show(context,
                message: state.message, type: LDToastType.error);
          }
        },
        builder: (context, state) {
          final categories = switch (state) {
            CategoriesLoaded(categories: final c) => c,
            CategoryActionInProgress(categories: final c) => c,
            CategoryActionSuccess(categories: final c) => c,
            CategoryActionError(categories: final c) => c,
            _ => null,
          };

          return Stack(
            children: [
              if (state is CategoriesLoading && categories == null)
                const LDLoadingWidget()
              else if (state is CategoriesError)
                LDErrorWidget(
                  message: state.message,
                  onRetry: () =>
                      context.read<CategoriesCubit>().loadCategories(),
                )
              else if (categories != null && categories.isEmpty)
                CategoriesEmptyWidget(onAdd: () => _showSheet(context))
              else if (categories != null)
                CategoryGridWidget(
                  categories: categories,
                  isMutating: state is CategoryActionInProgress,
                  onEdit: (cat) => _showSheet(context, category: cat),
                  onDelete: (cat) => _confirmDelete(context, cat),
                ),
              if (categories != null)
                Positioned(
                  right: 16,
                  bottom: 16,
                  child: FloatingActionButton.extended(
                    onPressed: state is CategoryActionInProgress
                        ? null
                        : () => _showSheet(context),
                    backgroundColor: LDColors.primary,
                    foregroundColor: Colors.white,
                    icon: const Icon(Icons.add),
                    label: const Text(
                      'Add Category',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
