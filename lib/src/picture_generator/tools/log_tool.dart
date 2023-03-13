import 'dart:developer' as dev;

import '../../../print_image_generate_tool.dart';

abstract class LogTool {
  static void log(String message) {
    if (PrintImageGenerateConfig.log) {
      dev.log("rex: pdPrinter - $message");
    }
  }
}
