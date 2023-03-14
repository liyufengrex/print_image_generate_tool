import 'dart:async';
import 'dart:typed_data';

import '../../print_image_generate_tool.dart';

class PictureGeneratorProvider {
  static PictureGeneratorProvider? _instance;

  static PictureGeneratorProvider get instance {
    _instance ??= PictureGeneratorProvider();
    return _instance!;
  }

  final StreamController<PicGenerateResult> _resultController =
      StreamController<PicGenerateResult>.broadcast();

  final StreamController<PicGenerateTask> _taskController =
      StreamController<PicGenerateTask>.broadcast();

  ///用于监听图片生成结果
  Stream<PicGenerateResult> get picGenerateResult => _resultController.stream;

  ///用于监听图片生成任务
  Stream<PicGenerateTask> get picGenerateTask => _taskController.stream;

  void addPicGeneratorTask(PicGenerateTask task) {
    _taskController.add(task);
  }

  void addPicGeneratorResult(PicGenerateResult result) {
    _resultController.add(result);
  }
}

/// widget 转 图像 任务
class PicGenerateTask<T> {
  final ATempWidget tempWidget; //需要打印的widget图层
  final PrintTypeEnum printTypeEnum; //图片任务类型 ， 用于匹配对应的图片生成器
  final T? params; //用于业务方需要的额外参数

  PicGenerateTask({
    required this.tempWidget,
    required this.printTypeEnum,
    this.params,
  });
}

/// widget 转 图像 结果
class PicGenerateResult {
  final Uint8List? data;
  final PicGenerateTask taskItem;

  PicGenerateResult(
    this.data,
    this.taskItem,
  );
}
