## print_image_generate_tool

flutter pos 终端应用中打印场景的工具库

提供能力将 widget 视图转换成 Uint8List 数据，内部维护队列，按加入顺序生成返回图像数据。

### 使用方法

##### 1. 初始化打印图层

在页面根节点下将打印图层 `PrintImageGenerateWidget` 初始化，例如：
```dart
MaterialApp(
    onGenerateTitle: (context) => '打印测试',
    home: Scaffold(
    body: PrintImageGenerateWidget(
       contentBuilder: (context) {
       return const HomePage();
       },
       onPictureGenerated: _onPictureGenerated,  //下面说明
     ),
   ),
)
```
要保证将 `PrintImageGenerateWidget` 节点位于所有页面图层的最上层

##### 2. 接收打印图像结果

如上 `PrintImageGenerateWidget` 中需要注入 `onPictureGenerated` 方法，接收打印图像结果
```dart
//打印图层生成成功
  Future<void> _onPictureGenerated(PicGenerateResult data) async {
    //widget生成的图像的字节结果
    final imageBytes = data.data;
    //打印任务信息
    final printTask = data.taskItem;
    //打印票据类型（标签、小票）
    final printTypeEnum = printTask.printTypeEnum;
    ... 省略打印逻辑
  }
```

##### 3. 将 widget 生成图层数据，如下：
注意： 传入的 `tempWidget` 必须实现或基础父类 `ATempWidget`

```dart
///生成打印的模板 Widget 需要继承这个类
mixin ATempWidget {
  //生成图片的缩放倍数
  double get pixelRatio => 1;

  //需要生成的票据像素宽度
  int get pixelPagerWidth;

  //需要生成的票据像素高度
  int get pixelPagerHeight => -1;
}
```

```dart
// 生成打印图层任务，指定任务类型为标签
    PictureGeneratorProvider.instance.addPicGeneratorTask(
      PicGenerateTask<PrinterInfo>(
        tempWidget: child() as ATempWidget,
        printTypeEnum: PrintTypeEnum.label,
        params: printerInfo,
      ),
    );
```
```dart
// 生成打印图层任务，指定任务类型为小票
    PictureGeneratorProvider.instance.addPicGeneratorTask(
      PicGenerateTask<PrinterInfo>(
        tempWidget: child() as ATempWidget,
        printTypeEnum: PrintTypeEnum.receipt,
        params: printerInfo,
      ),
    );
```
##### 附注：
发送 widget 转 图层 任务后，在节点 `PrintImageGenerateWidget` - `onPictureGenerated` 方法中会拿到对应 widget 生成的 Uint8List 数据。

本库内部已实现堵塞队列，小票和标签是单独的两个队列。

结合 `pd_printer_plugin` 打印功能库，可实现完整的【小票、标签】打印能力，具体查询 pd_printer_plugin 中 example。




