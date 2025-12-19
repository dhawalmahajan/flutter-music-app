import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  } on PlatformException catch (e) {
    if (e.code == 'invalid_format_type') {
      // Fallback: try a generic picker if device has no handler for image mime types
      try {
        final fallback = await FilePicker.platform.pickFiles(
          type: FileType.any,
        );
        if (fallback != null && fallback.files.isNotEmpty) {
          return File(fallback.files.first.path ?? '');
        }
      } catch (_) {}
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
  } on PlatformException catch (e) {
    if (e.code == 'invalid_format_type') {
      // Some devices don't have an activity for audio mime types — fallback to any
      try {
        final fallback = await FilePicker.platform.pickFiles(
          type: FileType.any,
        );
        if (fallback != null && fallback.files.isNotEmpty) {
          return File(fallback.files.first.path ?? '');
        }
      } catch (e) {
        print(e);
      }
    }
    return null;
  } catch (e) {
    // Handle any other errors that occur during file picking
    return null;
  }
}

String rgbToHex(Color color) {
  return '${color.red.toRadixString(16).padLeft(2, '0')}${color.green.toRadixString(16).padLeft(2, '0')}${color.blue.toRadixString(16).padLeft(2, '0')}';
}

Color hexToColor(String hex) {
  return Color(int.parse(hex, radix: 16) + 0xFF000000);
}
