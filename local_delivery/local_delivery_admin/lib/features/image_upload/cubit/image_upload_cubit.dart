import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'image_upload_state.dart';

class ImageUploadCubit extends Cubit<ImageUploadState> {
  ImageUploadCubit() : super(ImageUploadInitial());

  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  String? _localPath;

  Future<void> pickImage() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );
    if (picked == null) return;
    _localPath = picked.path;
    emit(ImageUploadImageSelected(localPath: picked.path));
  }

  Future<void> upload({
    required String title,
    required ImageUploadType type,
  }) async {
    if (_localPath == null) return;
    final path = _localPath!;

    emit(ImageUploading(localPath: path));

    try {
      final slug = title.trim().toLowerCase().replaceAll(RegExp(r'\s+'), '_');
      final ext = path.split('.').last.toLowerCase();
      final storagePath = '${type.folder}/$slug.$ext';

      final ref = _storage.ref().child(storagePath);
      await ref.putFile(File(path));
      final downloadUrl = await ref.getDownloadURL();

      emit(ImageUploadSuccess(
        localPath: path,
        downloadUrl: downloadUrl,
        storagePath: storagePath,
      ));
    } catch (e) {
      emit(ImageUploadError(localPath: path, message: e.toString()));
    }
  }

  void reset() {
    _localPath = null;
    emit(ImageUploadInitial());
  }
}
