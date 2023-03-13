import 'package:flutter/material.dart';

import '../../constant/print_image_generate_config.dart';
import '../widget/picture_generator_widget.dart';
import 'impl/label_generator_factory.dart';
import 'impl/receipt_generator_factory.dart';

///打印图层管理类
class PicGeneratorManager {
  static PicGeneratorManager? _instance;

  static PicGeneratorManager get instance {
    _instance ??= PicGeneratorManager._();
    return _instance!;
  }

  PicGeneratorManager._();

  List<Widget> children = <Widget>[];
  LabelGeneratorFactory? labelGeneratorFactory; //标签图层生成器
  ReceiptGeneratorFactory? receiptGeneratorFactory; //小票图层生成器

  void init({
    int labelGeneratorCount = 1,
    int receiptGeneratorCount = 1,
  }) {
    children.clear();

    List<GlobalKey<PictureGeneratorWidgetState>> labelMachines = [];
    List<GlobalKey<PictureGeneratorWidgetState>> receiptMachines = [];

    /// 标签图层器
    for (int index = 0; index < labelGeneratorCount; index++) {
      final macineKey = GlobalKey<PictureGeneratorWidgetState>();
      labelMachines.add(macineKey);
    }
    labelGeneratorFactory = LabelGeneratorFactory(labelMachines);
    for (var key in labelMachines) {
      children.add(PictureGeneratorWidget(labelGeneratorFactory!, key: key));
    }

    /// 小票图层器
    for (int index = 0; index < receiptGeneratorCount; index++) {
      final macineKey = GlobalKey<PictureGeneratorWidgetState>();
      receiptMachines.add(macineKey);
    }
    receiptGeneratorFactory = ReceiptGeneratorFactory(receiptMachines);
    for (var key in receiptMachines) {
      children.add(PictureGeneratorWidget(receiptGeneratorFactory!, key: key));
    }
  }

  void dispose() {
    children.clear();
    labelGeneratorFactory?.dispose();
    labelGeneratorFactory = null;
    receiptGeneratorFactory?.dispose();
    receiptGeneratorFactory = null;
  }
}
