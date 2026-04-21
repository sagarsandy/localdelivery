import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_delivery_ui/local_delivery_ui.dart';

import '../../../categories/domain/models/category_model.dart';
import '../../cubit/subcategories_cubit.dart';
import '../../cubit/subcategories_state.dart';
import '../../domain/models/subcategory_model.dart';

class AddEditSubcategorySheetWidget extends StatefulWidget {
  const AddEditSubcategorySheetWidget({
    super.key,
    this.subcategory,
    required this.categories,
    this.initialCategory,
  });

  final SubcategoryModel? subcategory;
  final List<CategoryModel> categories;

  /// Lowercase category title to pre-select in add mode.
  final String? initialCategory;

  @override
  State<AddEditSubcategorySheetWidget> createState() =>
      _AddEditSubcategorySheetWidgetState();
}

class _AddEditSubcategorySheetWidgetState
    extends State<AddEditSubcategorySheetWidget> {
  final _titleController = TextEditingController();
  final _imageController = TextEditingController();
  String _previewUrl = '';

  /// Lowercase category title; matches what is stored in Firestore.
  String? _selectedCategory;

  bool get _isEdit => widget.subcategory != null;
  bool get _isValid =>
      _titleController.text.trim().isNotEmpty && _selectedCategory != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      _titleController.text = widget.subcategory!.title;
      _imageController.text = widget.subcategory!.image;
      _previewUrl = widget.subcategory!.image;
      _selectedCategory = widget.subcategory!.category;
    } else {
      _selectedCategory = widget.initialCategory;
    }
    _titleController.addListener(() => setState(() {}));
    _imageController.addListener(() {
      setState(() => _previewUrl = _imageController.text.trim());
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    final cubit = context.read<SubcategoriesCubit>();
    final title = _titleController.text.trim();
    final image = _imageController.text.trim();
    final category = _selectedCategory!;
    if (_isEdit) {
      cubit.updateSubcategory(
          id: widget.subcategory!.id,
          title: title,
          image: image,
          category: category);
    } else {
      cubit.addSubcategory(title: title, image: image, category: category);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubcategoriesCubit, SubcategoriesState>(
      builder: (context, state) {
        final isLoading = state is SubcategoryActionInProgress;
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
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
                  _isEdit ? 'Edit Subcategory' : 'Add Subcategory',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 24),
                _ImagePreview(url: _previewUrl),
                const SizedBox(height: 20),
                LDTextField(
                  controller: _titleController,
                  label: 'Subcategory Name',
                  hint: 'e.g. Apples',
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),
                LDTextField(
                  controller: _imageController,
                  label: 'Image URL',
                  hint: 'https://example.com/image.jpg',
                  keyboardType: TextInputType.url,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _isValid ? _submit(context) : null,
                ),
                const SizedBox(height: 16),
                _CategoryDropdown(
                  categories: widget.categories,
                  selectedCategory: _selectedCategory,
                  onChanged: (v) => setState(() => _selectedCategory = v),
                ),
                const SizedBox(height: 28),
                LDButton(
                  label: _isEdit ? 'Save Changes' : 'Add Subcategory',
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

class _ImagePreview extends StatelessWidget {
  const _ImagePreview({required this.url});
  final String url;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      width: double.infinity,
      decoration: BoxDecoration(
        color: LDColors.inputFill,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: LDColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: url.isNotEmpty
          ? LDNetworkImage(url: url, fit: BoxFit.cover, borderRadius: 12)
          : const _PreviewPlaceholder(),
    );
  }
}

class _PreviewPlaceholder extends StatelessWidget {
  const _PreviewPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.image_outlined, size: 36, color: LDColors.textDisabled),
        const SizedBox(height: 6),
        Text(
          'Image preview',
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: LDColors.textDisabled),
        ),
      ],
    );
  }
}

class _CategoryDropdown extends StatelessWidget {
  const _CategoryDropdown({
    required this.categories,
    required this.selectedCategory,
    required this.onChanged,
  });

  final List<CategoryModel> categories;

  /// Lowercase category title of the currently selected item.
  final String? selectedCategory;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: selectedCategory,
      decoration: InputDecoration(
        labelText: 'Category',
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
      hint: const Text('Select a category'),
      // Dropdown item value is the lowercase title (matches Firestore field).
      items: categories
          .map((c) => DropdownMenuItem(
                value: c.title.toLowerCase(),
                child: Text(c.title),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }
}
