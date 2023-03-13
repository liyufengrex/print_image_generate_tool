import 'package:flutter/material.dart';
import '../../../../print_image_generate_tool.dart';
import '../../picture_generator_provider.dart';
import '../../widget/picture_generator_widget.dart';
import '../base/picture_generator_factory.dart';

/// 小票生成器
class ReceiptGeneratorFactory extends PictureGeneratorFactory {
  ReceiptGeneratorFactory(List<GlobalKey<PictureGeneratorWidgetState>> machines)
      : super(machines);

  @override
  bool isTakeTask(PicGenerateTask task) {
    return task.printTypeEnum == PrintTypeEnum.receipt;
  }
}
