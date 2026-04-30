import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_delivery_ui/local_delivery_ui.dart';

import '../../cubit/image_upload_cubit.dart';
import '../../cubit/image_upload_state.dart';

class ImageUploadPage extends StatefulWidget {
  const ImageUploadPage({super.key});

  @override
  State<ImageUploadPage> createState() => _ImageUploadPageState();
}

class _ImageUploadPageState extends State<ImageUploadPage> {
  final _titleController = TextEditingController();
  ImageUploadType _selectedType = ImageUploadType.product;

  bool get _canUpload => _titleController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _titleController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ImageUploadCubit(),
      child: BlocConsumer<ImageUploadCubit, ImageUploadState>(
        listener: (context, state) {
          if (state is ImageUploadError) {
            LDToast.show(context,
                message: state.message, type: LDToastType.error);
          }
        },
        builder: (context, state) {
          final localPath = switch (state) {
            ImageUploadImageSelected(localPath: final p) => p,
            ImageUploading(localPath: final p) => p,
            ImageUploadSuccess(localPath: final p) => p,
            ImageUploadError(localPath: final p) => p,
            _ => null,
          };

          final isUploading = state is ImageUploading;
          final isSuccess = state is ImageUploadSuccess;

          return GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image picker area
                  _ImagePickerArea(
                    localPath: localPath,
                    isUploading: isUploading,
                    onTap: isUploading
                        ? null
                        : () => context.read<ImageUploadCubit>().pickImage(),
                  ),
                  const SizedBox(height: 24),

                  // Title field
                  LDTextField(
                    controller: _titleController,
                    label: 'Title',
                    hint: 'e.g. Banana',
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.done,
                    enabled: !isUploading,
                  ),
                  const SizedBox(height: 16),

                  // Type dropdown
                  _TypeDropdown(
                    selected: _selectedType,
                    enabled: !isUploading,
                    onChanged: (t) => setState(() => _selectedType = t),
                  ),
                  const SizedBox(height: 8),

                  // Preview storage path
                  if (_titleController.text.trim().isNotEmpty)
                    _PathPreview(
                        title: _titleController.text.trim(),
                        type: _selectedType),
                  const SizedBox(height: 28),

                  // Upload button
                  if (!isSuccess)
                    LDButton(
                      label: 'Upload Image',
                      icon: const Icon(Icons.cloud_upload_outlined,
                          color: Colors.white),
                      enabled: localPath != null && _canUpload && !isUploading,
                      isLoading: isUploading,
                      onPressed: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        context.read<ImageUploadCubit>().upload(
                              title: _titleController.text.trim(),
                              type: _selectedType,
                            );
                      },
                    ),

                  // Success result
                  if (state is ImageUploadSuccess) ...[
                    _UploadedUrlCard(
                      url: state.downloadUrl,
                      storagePath: state.storagePath,
                    ),
                    const SizedBox(height: 16),
                    LDButton(
                      label: 'Upload Another Image',
                      icon: const Icon(Icons.add_photo_alternate_outlined,
                          color: Colors.white),
                      onPressed: () {
                        _titleController.clear();
                        setState(() => _selectedType = ImageUploadType.product);
                        context.read<ImageUploadCubit>().reset();
                      },
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─── Sub-widgets ────────────────────────────────────────────────────────────

class _ImagePickerArea extends StatelessWidget {
  const _ImagePickerArea({
    required this.localPath,
    required this.isUploading,
    required this.onTap,
  });

  final String? localPath;
  final bool isUploading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: LDColors.inputFill,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: localPath != null ? LDColors.primary : LDColors.border,
            width: localPath != null ? 2 : 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: localPath != null
            ? Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(File(localPath!), fit: BoxFit.cover),
                  if (isUploading)
                    const ColoredBox(
                      color: Color(0x66000000),
                      child: Center(
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 3),
                      ),
                    )
                  else
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.edit, size: 12, color: Colors.white),
                            SizedBox(width: 4),
                            Text('Change',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 11)),
                          ],
                        ),
                      ),
                    ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 52,
                    color: LDColors.primary.withValues(alpha: 0.6),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Tap to select image',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: LDColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'JPG, PNG supported',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: LDColors.textDisabled),
                  ),
                ],
              ),
      ),
    );
  }
}

class _TypeDropdown extends StatelessWidget {
  const _TypeDropdown({
    required this.selected,
    required this.enabled,
    required this.onChanged,
  });

  final ImageUploadType selected;
  final bool enabled;
  final ValueChanged<ImageUploadType> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<ImageUploadType>(
      initialValue: selected,
      decoration: InputDecoration(
        labelText: 'Type',
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
      items: ImageUploadType.values
          .map((t) => DropdownMenuItem(value: t, child: Text(t.label)))
          .toList(),
      onChanged: enabled ? (v) => v != null ? onChanged(v) : null : null,
    );
  }
}

class _PathPreview extends StatelessWidget {
  const _PathPreview({required this.title, required this.type});

  final String title;
  final ImageUploadType type;

  String get _previewPath {
    final slug = title.trim().toLowerCase().replaceAll(RegExp(r'\s+'), '_');
    return '/${type.folder}/$slug.jpg';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: LDColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.folder_outlined, size: 14, color: LDColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _previewPath,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: LDColors.primary,
                    fontFamily: 'monospace',
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UploadedUrlCard extends StatelessWidget {
  const _UploadedUrlCard({required this.url, required this.storagePath});

  final String url;
  final String storagePath;

  Future<void> _copyUrl(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: url));
    if (context.mounted) {
      LDToast.show(context, message: 'URL copied!', type: LDToastType.success);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: LDColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: LDColors.success.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: LDColors.success.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: LDColors.success.withValues(alpha: 0.1),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle_outline,
                    color: LDColors.success, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Upload Successful',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: LDColors.success,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Storage Path',
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(color: LDColors.textSecondary),
                ),
                const SizedBox(height: 4),
                Text(
                  '/$storagePath',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontFamily: 'monospace',
                        color: LDColors.textPrimary,
                      ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Download URL',
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(color: LDColors.textSecondary),
                ),
                const SizedBox(height: 4),
                Text(
                  url,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: LDColors.textPrimary,
                      ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _copyUrl(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: LDColors.primary,
                      side: const BorderSide(color: LDColors.primary),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    icon: const Icon(Icons.copy_outlined, size: 18),
                    label: const Text(
                      'Copy URL',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
