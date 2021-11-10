import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class Scannersdk {
  static const MethodChannel _channel = const MethodChannel('scanner');

  static const INIT = "init";
  static const SCAN = "scan";
  static const STOP = "stop";

  Scannersdk() {
    print('Classe Scanner Iniciada');
  }

  static Future<void> init() async {
    await _channel.invokeMethod('initscanner');
  }

  static Future<void> scan() async {
    await _channel.invokeMethod('scan');
  }

  static Future<void> stop() async {
    await _channel.invokeMethod('stop');
  }
}
