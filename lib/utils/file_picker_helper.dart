// lib/utils/file_picker_helper.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';

class FilePickerHelper {
  static Future<Map<String, dynamic>?> pickVideo() async {
    if (kIsWeb) {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        withData: true,
      );
      
      if (result != null) {
        return {
          'bytes': result.files.single.bytes!,
          'name': result.files.single.name,
        };
      }
    } else {
      final result = await FilePicker.platform.pickFiles(type: FileType.video);
      if (result != null) {
        final file = File(result.files.single.path!);
        return {
          'bytes': await file.readAsBytes(),
          'name': result.files.single.name,
        };
      }
    }
    return null;
  }

  static Future<Map<String, dynamic>?> pickImage() async {
    if (kIsWeb) {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true,
      );
      
      if (result != null) {
        return {
          'bytes': result.files.single.bytes!,
          'name': result.files.single.name,
        };
      }
    } else {
      final result = await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null) {
        final file = File(result.files.single.path!);
        return {
          'bytes': await file.readAsBytes(),
          'name': result.files.single.name,
        };
      }
    }
    return null;
  }
}