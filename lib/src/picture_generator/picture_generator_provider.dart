import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui show Image;
import 'dart:ui';
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
  final ui.Image? image;
  final PicGenerateTask taskItem;

  // image 转 uint8List
  Future<Uint8List?> convertUint8List({
    ImageByteFormat imageByteFormat = ImageByteFormat.png,
  }) async {
    if (image == null) {
      return Future(() => null);
    } else {
      final byteData = await image!.toByteData(format: imageByteFormat);
      return byteData?.buffer.asUint8List();
    }
  }

  // 生成的图像像素宽度
  int get imageWidth => image == null ? 0 : image!.width;

  // 生成的图像像素高度
  int get imageHeight => image == null ? 0 : image!.height;

  PicGenerateResult(
    this.image,
    this.taskItem,
  );
}
