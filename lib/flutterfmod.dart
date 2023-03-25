import 'dart:async';

import 'package:flutter/services.dart';
// const val MODE_FUNNY = 1 //搞笑

//     const val MODE_UNCLE = 2 //大叔

//     const val MODE_LOLITA = 3 //萝莉

//     const val MODE_ROBOT = 4 //机器人

//     const val MODE_ETHEREAL = 5 //空灵

//     const val MODE_CHORUS = 6 //混合

//     const val MODE_HORROR = 7 //恐怖

enum ConversionType {
  funny._(1),
  uncle._(2),
  lolita._(3),
  robot._(4),
  ethereal._(5),
  chorus._(6),
  horror._(7);

  const ConversionType._(this.value);

  final int value;
}

/// `volume` 0 ~ 1;
typedef VolumeCallBack = Function(double volume);
typedef StopRecordCallBack = void Function(String path, int duration);
typedef StopPlayCallBack = void Function(String path);

class Flutterfmod {
  Flutterfmod._() {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'volume') {
        double volume = call.arguments.toDouble();
        if (_private._callBack != null) {
          _private._callBack?.call(volume);
        }
      }

      if (call.method == 'stopPlaying') {
        String path = call.arguments["path"] as String;
        if (_private._stopCallBack != null) {
          _private._stopCallBack?.call(path);
          _private._stopCallBack = null;
        }
      }
    });
  }

  static const MethodChannel _channel = const MethodChannel('flutterfmod');

  static Flutterfmod? _flutterFmod;

  // ignore: unused_field
  VolumeCallBack? _callBack;
  StopPlayCallBack? _stopCallBack;

  static Flutterfmod get _private => _flutterFmod = _flutterFmod ?? Flutterfmod._();

  bool recoreding = false;

  /// start record
  /// [path] record file path.
  /// [callBack] volume callback: 0 ~ 1.
  static Future<bool> startVoiceRecord([VolumeCallBack? volumeCallBack]) async {
    if (_private.recoreding) {
      return false;
    }
    if (volumeCallBack != null) {
      _private._callBack = volumeCallBack;
    }

    _private.recoreding = await _channel.invokeMethod('startVoiceRecord') as bool;

    return _private.recoreding;
  }

  /// stop record
  static Future<bool> stopVoiceRecord(StopRecordCallBack callBack) async {
    Map result = await _channel.invokeMethod('stopVoiceRecord');
    _private._callBack = null;
    _private.recoreding = false;
    String? error = result['error'];
    String path = result['path'];
    int duration = result['duration'] as int;
    callBack(path, duration);
    return error == null ? true : false;
  }

  /// cancel record
  static Future<Null> cancelVoiceRecord() async {
    await _channel.invokeMethod('cancelVoiceRecord');
    _private._callBack = null;
    _private.recoreding = false;
  }

  /// play amr file
  static Future<bool> play(String path, [StopPlayCallBack? endCallback]) async {
    _private._stopCallBack = endCallback;
    bool isPlay = await _channel.invokeMethod('play', {"path": path}) as bool;
    return isPlay;
  }

  /// stop playing amr file
  static Future<Null> stop() async {
    _private._stopCallBack = null;
    await _channel.invokeMethod('stopPlaying') as bool;
    return null;
  }

  static Future<String> conversion(ConversionType conversionType, String path, String? savePath) async {
    final String okpath = await _channel
        .invokeMethod('conversion', {"conversionType": conversionType.value, "path": path, "savePath": savePath});
    return okpath;
  }
}
