import 'package:equatable/equatable.dart';

enum ImageUploadType {
  category,
  subcategory,
  product;

  String get label {
    switch (this) {
      case ImageUploadType.category: return 'Category';
      case ImageUploadType.subcategory: return 'Subcategory';
      case ImageUploadType.product: return 'Product';
    }
  }

  /// Firebase Storage folder for this type.
  String get folder {
    switch (this) {
      case ImageUploadType.category: return 'categories';
      case ImageUploadType.subcategory: return 'subcategories';
      case ImageUploadType.product: return 'products';
    }
  }
}

abstract class ImageUploadState extends Equatable {
  const ImageUploadState();
  @override
  List<Object?> get props => [];
}

class ImageUploadInitial extends ImageUploadState {}

class ImageUploadImageSelected extends ImageUploadState {
  const ImageUploadImageSelected({required this.localPath});
  final String localPath;
  @override
  List<Object?> get props => [localPath];
}

class ImageUploading extends ImageUploadState {
  const ImageUploading({required this.localPath});
  final String localPath;
  @override
  List<Object?> get props => [localPath];
}

class ImageUploadSuccess extends ImageUploadState {
  const ImageUploadSuccess({
    required this.localPath,
    required this.downloadUrl,
    required this.storagePath,
  });
  final String localPath;
  final String downloadUrl;
  final String storagePath;
  @override
  List<Object?> get props => [localPath, downloadUrl, storagePath];
}

class ImageUploadError extends ImageUploadState {
  const ImageUploadError({required this.localPath, required this.message});
  final String localPath;
  final String message;
  @override
  List<Object?> get props => [localPath, message];
}
