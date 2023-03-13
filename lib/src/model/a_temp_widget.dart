
///生成打印的模板 Widget 需要继承这个类
mixin ATempWidget {
  //生成图片的缩放倍数
  double get pixelRatio => 1;

  //需要生成的票据像素宽度
  int get pixelPagerWidth;

  //需要生成的票据像素高度
  int get pixelPagerHeight => -1;
}
