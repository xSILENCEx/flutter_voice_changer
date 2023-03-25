import 'package:flutter/material.dart';
import 'package:flutterfmod/flutterfmod.dart';
import 'package:permission_handler/permission_handler.dart';

extension _ExType on ConversionType {
  String get name {
    switch (this) {
      case ConversionType.funny:
        return '搞笑';
      case ConversionType.uncle:
        return '大叔';
      case ConversionType.lolita:
        return '萝莉';
      case ConversionType.robot:
        return '机器人';
      case ConversionType.ethereal:
        return '空灵';
      case ConversionType.chorus:
        return '混合';
      case ConversionType.horror:
        return '恐怖';
    }
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double _volume = 0;
  String? _path;
  String? _playPath;

  @override
  void initState() {
    _requestPermiss();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: _volume * 100,
                height: 30,
                color: Colors.blue[300],
              ),
              GestureDetector(
                onTapDown: (TapDownDetails details) => _startRecord(),
                onTapUp: (TapUpDetails details) => _stopRecord(),
                onTapCancel: () => _cancelRecord(),
                child: Container(
                  width: 120,
                  height: 120,
                  alignment: Alignment.center,
                  color: _volume == 0 ? Colors.red : Colors.green,
                  child: Text('Record'),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.play_arrow),
                    onPressed: () => _play(),
                  ),
                  IconButton(
                    icon: Icon(Icons.stop),
                    onPressed: () => _stop(),
                  ),
                ],
              ),
              ...ConversionType.values.map((e) {
                return _item(
                  text: e.name,
                  onTap: () async {
                    _playPath = await FlutterVoiceChanger.conversion(e, _path!, null);
                  },
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _item({required String text, required Function() onTap}) {
    return ElevatedButton(
      onPressed: onTap,
      child: Container(child: Text(text)),
    );
  }

  _startRecord() async {
    bool success = await FlutterVoiceChanger.startVoiceRecord((volume) {
      print('volume ---- $volume');
      setState(() {
        _volume = volume;
      });
    });
    print('start record ---- $success');
  }

  _stopRecord() async {
    bool success = await FlutterVoiceChanger.stopVoiceRecord((path, duration) {
      _path = path;
      _playPath = path;
      print('path --- $path, duration ---- $duration');
    });
    setState(() {
      _volume = 0;
    });
    print('stop record ---- $success');
  }

  _cancelRecord() async {
    await FlutterVoiceChanger.cancelVoiceRecord();
    setState(() {
      _volume = 0;
    });
    print('取消录制');
  }

  _play() async {
    await FlutterVoiceChanger.play(_playPath!, (path) {
      print('play end');
    });
  }

  _stop() async {
    await FlutterVoiceChanger.stop();
  }

  _requestPermiss() async {
    await Permission.microphone.request();
  }
}
