abstract class PrintImageGenerateConfig {
  static bool log = true;
}

// 图片任务类型 ， 用于匹配对应的图片生成器， (小票、标签)
enum PrintTypeEnum { receipt, label }
