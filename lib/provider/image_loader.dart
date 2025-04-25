import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pro_image_editor/pro_image_editor.dart';
import 'dart:typed_data';

class ImageLoader extends ChangeNotifier {
  img.Image? image;
  final List<img.Image> processedImgs = List.empty(growable: true);

  Future<Uint8List?> _pickAndCropImage(int width, int height) async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file == null) return null;

    final croppedFile = await ImageCropper().cropImage(
      sourcePath: file.path,
      aspectRatio: CropAspectRatio(
        ratioX: width.toDouble(),
        ratioY: height.toDouble(),
      ),
    );

    return croppedFile?.readAsBytes();
  }

  Future<void> pickImage({required int width, required int height}) async {
    final imageBytes = await _pickAndCropImage(width, height);
    if (imageBytes == null) return;

    // Store raw bytes for later editing
    image = img.decodeImage(imageBytes);
    notifyListeners();
  }

  Future<void> startImageEditing(BuildContext context) async {
    if (image == null) return;

    // Convert to JPEG bytes for editor
    final imageBytes = img.encodeJpg(image!);

    // Use local context from widget
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => ProImageEditor.memory(
          imageBytes,
          callbacks: ProImageEditorCallbacks(
            onImageEditingComplete: (Uint8List bytes) async {
              final editedImage = img.decodeImage(bytes);
              if (editedImage != null) {
                image = editedImage;
                notifyListeners();
              }
              Navigator.of(context).pop(true);
            },
          ),
        ),
      ),
    );

    if (result == true && context.mounted) {
      // Handle post-editing logic if needed
    }
  }

  void updateImage(img.Image newImage) {
    image = newImage;
    notifyListeners();
  }

  void updateProcessedImages(List<img.Image> newProcessedImgs) {
    processedImgs
      ..clear()
      ..addAll(newProcessedImgs);
    notifyListeners();
  }
}