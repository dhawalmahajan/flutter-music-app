import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(content: Text(content), backgroundColor: Colors.red),
    );
}

Future<File?> pickImage() async {
  try {
    final filePickerRes = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (filePickerRes != null) {
      return File(filePickerRes.files.first.xFile.path);
    }
    return null;
  } catch (e) {
    return null;
  }
}

Future<File?> pickAudio() async {
  // Function to pick audio file
  try {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );
    if (result != null && result.files.isNotEmpty) {
      final file = File(result.files.first.path ?? '');
      return file;
      // Use the selected audio file
    }
    return null;
  } catch (e) {
    // Handle any errors that occur during file picking
    return null;
  }
}
