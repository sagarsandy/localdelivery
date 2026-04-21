import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_delivery_ui/local_delivery_ui.dart';

import '../../cubit/categories_cubit.dart';
import '../../cubit/categories_state.dart';
import '../../domain/models/category_model.dart';

class AddEditCategorySheetWidget extends StatefulWidget {
  const AddEditCategorySheetWidget({super.key, this.category});

  /// null = add mode, non-null = edit mode
  final CategoryModel? category;

  @override
  State<AddEditCategorySheetWidget> createState() =>
      _AddEditCategorySheetWidgetState();
}

class _AddEditCategorySheetWidgetState
    extends State<AddEditCategorySheetWidget> {
  final _titleController = TextEditingController();
  final _imageController = TextEditingController();
  String _previewUrl = '';

  bool get _isEdit => widget.category != null;
  bool get _isValid => _titleController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      _titleController.text = widget.category!.title;
      _imageController.text = widget.category!.image;
      _previewUrl = widget.category!.image;
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
    final cubit = context.read<CategoriesCubit>();
    final title = _titleController.text.trim();
    final image = _imageController.text.trim();
    if (_isEdit) {
      cubit.updateCategory(id: widget.category!.id, title: title, image: image);
    } else {
      cubit.addCategory(title: title, image: image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesCubit, CategoriesState>(
      builder: (context, state) {
        final isLoading = state is CategoryActionInProgress;
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
                  _isEdit ? 'Edit Category' : 'Add Category',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 24),
                _ImagePreview(url: _previewUrl),
                const SizedBox(height: 20),
                LDTextField(
                  controller: _titleController,
                  label: 'Category Name',
                  hint: 'e.g. Fruits & Vegetables',
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
                const SizedBox(height: 28),
                LDButton(
                  label: _isEdit ? 'Save Changes' : 'Add Category',
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
    );
  }
}
