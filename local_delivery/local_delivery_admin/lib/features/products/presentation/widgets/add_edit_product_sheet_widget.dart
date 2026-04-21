import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_delivery_ui/local_delivery_ui.dart';

import '../../../categories/domain/models/category_model.dart';
import '../../../subcategories/domain/models/subcategory_model.dart';
import '../../cubit/products_cubit.dart';
import '../../cubit/products_state.dart';
import '../../domain/models/product_model.dart';

class AddEditProductSheetWidget extends StatefulWidget {
  const AddEditProductSheetWidget({
    super.key,
    this.product,
    required this.categories,
    required this.allSubcategories,
    this.initialCategory,
    this.initialSubcategory,
  });

  final ProductModel? product;
  final List<CategoryModel> categories;
  final List<SubcategoryModel> allSubcategories;
  final String? initialCategory;
  final String? initialSubcategory;

  @override
  State<AddEditProductSheetWidget> createState() =>
      _AddEditProductSheetWidgetState();
}

class _AddEditProductSheetWidgetState
    extends State<AddEditProductSheetWidget> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _imageController = TextEditingController();
  final _priceController = TextEditingController();
  final _originalPriceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _unitsController = TextEditingController();

  String _previewUrl = '';
  String? _selectedCategory;
  String? _selectedSubcategory;
  bool _inStock = true;
  bool _isAvailable = true;

  bool get _isEdit => widget.product != null;

  List<SubcategoryModel> get _subcatsForCategory {
    if (_selectedCategory == null) return widget.allSubcategories;
    return widget.allSubcategories
        .where((s) => s.category == _selectedCategory)
        .toList();
  }

  bool get _isValid =>
      _titleController.text.trim().isNotEmpty &&
      _selectedCategory != null &&
      _selectedSubcategory != null &&
      double.tryParse(_priceController.text.trim()) != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      final p = widget.product!;
      _titleController.text = p.title;
      _descController.text = p.description;
      _imageController.text = p.image;
      _previewUrl = p.image;
      _priceController.text = p.price.toString();
      _originalPriceController.text =
          p.originalPrice > 0 ? p.originalPrice.toString() : '';
      _quantityController.text = p.quantity.toString();
      _unitsController.text = p.units;
      _selectedCategory = p.category;
      _selectedSubcategory = p.subcategory;
      _inStock = p.inStock;
      _isAvailable = p.isAvailable;
    } else {
      _selectedCategory = widget.initialCategory;
      _selectedSubcategory = widget.initialSubcategory;
    }

    for (final c in [
      _titleController, _descController, _priceController,
      _originalPriceController, _quantityController, _unitsController,
    ]) {
      c.addListener(() => setState(() {}));
    }
    _imageController.addListener(() {
      setState(() => _previewUrl = _imageController.text.trim());
    });
  }

  @override
  void dispose() {
    for (final c in [
      _titleController, _descController, _imageController, _priceController,
      _originalPriceController, _quantityController, _unitsController,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _onCategoryChanged(String? category) {
    setState(() {
      _selectedCategory = category;
      final subcats = _subcatsForCategory;
      _selectedSubcategory =
          subcats.isNotEmpty ? subcats.first.title.toLowerCase() : null;
    });
  }

  void _submit(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    final cubit = context.read<ProductsCubit>();
    final product = ProductModel(
      id: _isEdit ? widget.product!.id : '',
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      image: _imageController.text.trim(),
      category: _selectedCategory!,
      subcategory: _selectedSubcategory!,
      price: double.tryParse(_priceController.text.trim()) ?? 0,
      originalPrice:
          double.tryParse(_originalPriceController.text.trim()) ?? 0,
      quantity: int.tryParse(_quantityController.text.trim()) ?? 0,
      units: _unitsController.text.trim(),
      inStock: _inStock,
      isAvailable: _isAvailable,
    );
    if (_isEdit) {
      cubit.updateProduct(product);
    } else {
      cubit.addProduct(product);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, state) {
        final isLoading = state is ProductActionInProgress;
        return Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom),
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
                  _isEdit ? 'Edit Product' : 'Add Product',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 24),
                _ImagePreview(url: _previewUrl),
                const SizedBox(height: 20),
                LDTextField(
                  controller: _titleController,
                  label: 'Product Name',
                  hint: 'e.g. Fresh Red Apples',
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),
                LDTextField(
                  controller: _descController,
                  label: 'Description',
                  hint: 'Short product description',
                  textInputAction: TextInputAction.next,
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                LDTextField(
                  controller: _imageController,
                  label: 'Image URL',
                  hint: 'https://example.com/image.jpg',
                  keyboardType: TextInputType.url,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),
                _CascadingCategoryDropdowns(
                  categories: widget.categories,
                  subcategories: _subcatsForCategory,
                  selectedCategory: _selectedCategory,
                  selectedSubcategory: _selectedSubcategory,
                  onCategoryChanged: _onCategoryChanged,
                  onSubcategoryChanged: (v) =>
                      setState(() => _selectedSubcategory = v),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: LDTextField(
                        controller: _priceController,
                        label: 'Price (₹)',
                        hint: '0.00',
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: LDTextField(
                        controller: _originalPriceController,
                        label: 'Original Price (₹)',
                        hint: 'Optional',
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: LDTextField(
                        controller: _quantityController,
                        label: 'Quantity',
                        hint: 'e.g. 500',
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: LDTextField(
                        controller: _unitsController,
                        label: 'Units',
                        hint: 'e.g. g, kg, piece',
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _ToggleRow(
                  label: 'In Stock',
                  value: _inStock,
                  onChanged: (v) => setState(() => _inStock = v),
                ),
                _ToggleRow(
                  label: 'Available (visible to customers)',
                  value: _isAvailable,
                  onChanged: (v) => setState(() => _isAvailable = v),
                ),
                const SizedBox(height: 24),
                LDButton(
                  label: _isEdit ? 'Save Changes' : 'Add Product',
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
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.image_outlined,
                    size: 36, color: LDColors.textDisabled),
                const SizedBox(height: 6),
                Text(
                  'Image preview',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: LDColors.textDisabled),
                ),
              ],
            ),
    );
  }
}

class _CascadingCategoryDropdowns extends StatelessWidget {
  const _CascadingCategoryDropdowns({
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
    return Column(
      children: [
        DropdownButtonFormField<String>(
          initialValue: selectedCategory,
          decoration: _decoration('Category'),
          hint: const Text('Select a category'),
          items: categories
              .map((c) => DropdownMenuItem(
                    value: c.title.toLowerCase(),
                    child: Text(c.title),
                  ))
              .toList(),
          onChanged: onCategoryChanged,
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          key: ValueKey(selectedCategory),
          initialValue: selectedSubcategory,
          decoration: _decoration('Subcategory'),
          hint: const Text('Select a subcategory'),
          items: subcategories
              .map((s) => DropdownMenuItem(
                    value: s.title.toLowerCase(),
                    child: Text(s.title),
                  ))
              .toList(),
          onChanged: onSubcategoryChanged,
        ),
      ],
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: LDColors.primary,
        ),
      ],
    );
  }
}
