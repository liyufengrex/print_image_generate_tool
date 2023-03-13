import 'package:flutter/material.dart';
import 'package:print_image_generate_tool/print_image_generate_tool.dart';
import '../../picture_generator_provider.dart';
import '../../widget/picture_generator_widget.dart';
import '../base/picture_generator_factory.dart';

/// 标签生成器
class LabelGeneratorFactory extends PictureGeneratorFactory {
  LabelGeneratorFactory(List<GlobalKey<PictureGeneratorWidgetState>> machines)
      : super(machines);

  @override
  bool isTakeTask(PicGenerateTask task) {
    return task.printTypeEnum == PrintTypeEnum.label;
  }
}
