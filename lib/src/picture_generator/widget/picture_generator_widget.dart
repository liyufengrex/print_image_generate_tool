import 'dart:typed_data';
import 'dart:ui' as ui show Image;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

import '../../../print_image_generate_tool.dart';
import '../factory/base/picture_generator_factory.dart';
import '../picture_generator_provider.dart';
import '../tools/log_tool.dart';

///图片生成器
class PictureGeneratorWidget extends StatefulWidget {
  final PictureGeneratorFactory generatorFactory;

  const PictureGeneratorWidget(this.generatorFactory, {Key? key})
      : super(key: key);

  ///限制模板尺寸
  Widget buildContainer({required Widget child}) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: UnconstrainedBox(
        child: child,
      ),
    );
  }

  @override
  PictureGeneratorWidgetState createState() => PictureGeneratorWidgetState();
}

class PictureGeneratorWidgetState extends State<PictureGeneratorWidget> {
  ATempWidget? tempWidget;
  final _boundaryKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _doGenerateTask();
  }

  void update() {
    setState(() {
      _doGenerateTask();
    });
  }

  PicGenerateTask? _getTask() {
    return _getGeneratorFactory().getTask(_getMacineKey());
  }

  GlobalKey<PictureGeneratorWidgetState> _getMacineKey() {
    return widget.key as GlobalKey<PictureGeneratorWidgetState>;
  }

  PictureGeneratorFactory _getGeneratorFactory() {
    return widget.generatorFactory;
  }

  void _doGenerateTask() {
    tempWidget = _getTask()?.tempWidget;
    if (tempWidget != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(milliseconds: 500), () {
          _captureWidget(tempWidget!.pixelRatio);
        });
      });
    }
  }

  void _captureWidget(double pixelRatio) async {
    final boundary = _boundaryKey.currentContext?.findRenderObject();
    ui.Image? imgData;
    try {
      if (boundary != null && boundary is RenderRepaintBoundary) {
        imgData = await boundary.toImage(pixelRatio: pixelRatio);
        LogTool.log("图片宽高：宽 ：${imgData.width}, 高：${imgData.height}");
      }
    } catch (e) {
      LogTool.log(e.toString());
    } finally {
      if (imgData != null) {
        LogTool.log("图片生成成功");
        _getGeneratorFactory().finishTask(_getMacineKey(), true, imgData);
      } else {
        LogTool.log("图片生成失败");
        _getGeneratorFactory().finishTask(_getMacineKey(), false, null);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (tempWidget != null && tempWidget is Widget) {
      child = tempWidget! as Widget;
    } else {
      child = Container();
    }
    return widget.buildContainer(
      child: RepaintBoundary(
        key: _boundaryKey,
        child: child,
      ),
    );
  }
}
