import 'package:flutter/material.dart';

import '../factory/pic_generator_manager.dart';

/// 打印图层生成器 （管理）
class PictureGeneratorManagerWidget extends StatefulWidget {
  // 标签图层生成器数量
  final int labelGeneratorCount;

  // 小票图层生成器数量
  final int receiptGeneratorCount;

  const PictureGeneratorManagerWidget({
    Key? key,
    required this.labelGeneratorCount,
    required this.receiptGeneratorCount,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PictureGeneratorManagerWidgetState();
}

class _PictureGeneratorManagerWidgetState
    extends State<PictureGeneratorManagerWidget> {
  List<Widget> children = <Widget>[];

  @override
  void dispose() {
    PicGeneratorManager.instance.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initPictureGenerator();
  }

  void _initPictureGenerator() {
    PicGeneratorManager.instance.init(
      labelGeneratorCount: widget.labelGeneratorCount,
      receiptGeneratorCount: widget.receiptGeneratorCount,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: PicGeneratorManager.instance.children);
  }
}
