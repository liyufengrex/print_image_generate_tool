import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:print_image_generate_tool/src/picture_generator/picture_generator_provider.dart';
import 'package:print_image_generate_tool/src/picture_generator/widget/pic_generator_manager_widget.dart';

typedef OnPictureGenerated = Function(PicGenerateResult picGenerateResult);

class PrintImageGenerateWidget extends StatefulWidget {
  final WidgetBuilder contentBuilder;
  final OnPictureGenerated? onPictureGenerated;

  // 标签图层生成器数量
  final int labelGeneratorCount;

  // 小票图层生成器数量
  final int receiptGeneratorCount;

  const PrintImageGenerateWidget({
    Key? key,
    required this.contentBuilder,
    this.onPictureGenerated,
    this.labelGeneratorCount = 1,
    this.receiptGeneratorCount = 1,
  }) : super(key: key);

  @override
  State<PrintImageGenerateWidget> createState() =>
      _PrintImageGenerateWidgetState();
}

class _PrintImageGenerateWidgetState extends State<PrintImageGenerateWidget> {
  bool get isPersistentCallbacks =>
      SchedulerBinding.instance.schedulerPhase ==
      SchedulerPhase.persistentCallbacks;

  OverlayEntry? _printEntry;

  ///图片任务
  StreamSubscription? _picTaskSubscription;

  ///监听图片生成
  void _listenPictureGenerate() {
    _picTaskSubscription =
        PictureGeneratorProvider.instance.picGenerateResult.listen(
      (generateResult) {
        if (widget.onPictureGenerated != null) {
          widget.onPictureGenerated!(generateResult);
        }
      },
    );
  }

  bool _hasInit = false;

  void _initPrintEntryWidget() {
    _printEntry = OverlayEntry(
      builder: (BuildContext context) => Positioned(
        top: 1,
        left: 1,
        child: _PrintOverlayWidget(
          labelGeneratorCount: widget.labelGeneratorCount,
          receiptGeneratorCount: widget.receiptGeneratorCount,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (_printEntry == null) {
      _initPrintEntryWidget();
      _listenPictureGenerate();
    }
    if (!mounted) return;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _initPrintEntry();
    });
  }

  @override
  void dispose() {
    if (_hasInit) {
      _printEntry?.remove();
      _hasInit = false;
      _printEntry = null;
    }
    _picTaskSubscription?.cancel();
    _picTaskSubscription = null;
    super.dispose();
  }

  void _initPrintEntry() {
    if (!_hasInit && _printEntry != null) {
      Overlay.of(context)?.insert(_printEntry!);
      _hasInit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.contentBuilder(context);
  }
}

///打印图层Widget
class _PrintOverlayWidget extends StatelessWidget {
  // 标签图层生成器数量
  final int labelGeneratorCount;

  // 小票图层生成器数量
  final int receiptGeneratorCount;

  const _PrintOverlayWidget({
    Key? key,
    required this.labelGeneratorCount,
    required this.receiptGeneratorCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      child: SizedBox(
        width: 1,
        height: 1,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: PictureGeneratorManagerWidget(
                    labelGeneratorCount: labelGeneratorCount,
                    receiptGeneratorCount: receiptGeneratorCount,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
