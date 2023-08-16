import 'dart:async';
import 'dart:collection';
import 'dart:ui' as ui show Image;
import 'package:flutter/material.dart';

import '../../picture_generator_provider.dart';
import '../../widget/picture_generator_widget.dart';

abstract class PictureGeneratorFactory {
  /// 空闲设备
  final List<GlobalKey<PictureGeneratorWidgetState>> _idleMachines;

  /// 繁忙设备
  final List<GlobalKey<PictureGeneratorWidgetState>> _busyMachines =
      <GlobalKey<PictureGeneratorWidgetState>>[];

  /// 记录每台设备对应的任务
  final HashMap _allocations =
      HashMap<GlobalKey<PictureGeneratorWidgetState>, PicGenerateTask>();

  ///需要等待的任务队列
  final List<PicGenerateTask> _waitingTask = <PicGenerateTask>[];

  PictureGeneratorFactory(this._idleMachines) {
    _listenPicTask();
  }

  StreamSubscription? _subscription;

  ///监听图片生成任务
  void _listenPicTask() {
    _subscription = PictureGeneratorProvider.instance.picGenerateTask
        .where((task) => isTakeTask(task))
        .listen((task) {
      _addTask(task);
    });
  }

  ///上层实现是否接受任务
  bool isTakeTask(PicGenerateTask task);

  ///添加任务
  void _addTask(PicGenerateTask taskItem) {
    if (!_waitingTask.contains(taskItem)) {
      _waitingTask.add(taskItem);
    }
    _doWork();
  }

  ///删除等待队列中匹配的任务
  void removeTask(bool Function(PicGenerateTask element) condition) {
    _waitingTask.removeWhere(condition);
  }

  ///根据 globalKey 获取任务
  PicGenerateTask? getTask(GlobalKey macineKey) {
    return _allocations[macineKey];
  }

  ///完成任务
  void finishTask(
    GlobalKey<PictureGeneratorWidgetState> macineKey,
    bool success,
    ui.Image? data,
  ) {
    if (_busyMachines.contains(macineKey)) {
      _busyMachines.remove(macineKey);
    }
    if (!_idleMachines.contains(macineKey)) {
      _idleMachines.add(macineKey);
    }
    final task = _allocations[macineKey];
    if (success) {
      //图片生成成功
      PictureGeneratorProvider.instance.addPicGeneratorResult(
        PicGenerateResult(data, task),
      );
    } else {
      //图片生成失败
      PictureGeneratorProvider.instance.addPicGeneratorResult(
        PicGenerateResult(null, task),
      );
    }
    if (_allocations.containsKey(macineKey)) {
      _allocations.remove(macineKey);
    }
    _doWork();
  }

  void _doWork() {
    if (_idleMachines.isNotEmpty && _waitingTask.isNotEmpty) {
      final macine = _idleMachines.first;
      if (macine.currentState != null && macine.currentContext != null) {
        _allocations[macine] = _waitingTask.first;
        _busyMachines.add(macine);
        _idleMachines.remove(macine);
        _waitingTask.remove(_allocations[macine]);
        macine.currentState!.update();
      }
    }
  }

  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    _idleMachines.clear();
    _busyMachines.clear();
    _allocations.clear();
    _waitingTask.clear();
  }
}
