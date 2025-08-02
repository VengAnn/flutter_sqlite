import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class FilePickerHelper {
  static Future<void> openFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      // type: FileType.custom,
      // allowedExtensions: ['db'], // Allow only .db files
      type: FileType.any
    );

    if (result != null && result.files.single.path != null) {
      String filePath = result.files.single.path!;

      debugPrint('Selected file path: $filePath');
    } else {
      debugPrint('File selection canceled');
    }
  }
}
