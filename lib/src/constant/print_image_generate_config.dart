import 'dart:ui';

abstract class PrintImageGenerateConfig {
  static bool log = true;

  //生成的图层格式
  static ImageByteFormat imageByteFormat = ImageByteFormat.png;
}

// 图片任务类型 ， 用于匹配对应的图片生成器， (小票、标签)
enum PrintTypeEnum { receipt, label }
