import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class Lampsdk {
  static const MethodChannel _channel = const MethodChannel('lampsdk');

  static const VERMELHO = "vermelho";
  static const VERDE = "verde";
  static const AZULCLARO = "azulclaro";
  static const AMARELO = "amarelo";
  static const ROXO = "roxo";
  static const AZUL = "azul";
  static const DESLIGAR = "desligar";
  static const INIT = "init";

  Lampsdk() {
    print('Classe Lamp Iniciada');
  }
  static Future<void> init() async {
    await _channel.invokeMethod('init');
  }

  static Future<void> desligar() async {
    await _channel.invokeMethod('desligar');
  }

  static Future<void> azul() async {
    await _channel.invokeMethod('azul');
  }

  static Future<void> roxo() async {
    await _channel.invokeMethod('roxo');
  }

  static Future<void> amarelo() async {
    await _channel.invokeMethod('amarelo');
  }

  static Future<void> azulclaro() async {
    await _channel.invokeMethod('azulclaro');
  }

  static Future<void> verde() async {
    await _channel.invokeMethod('verde');
  }

  static Future<void> vermelho() async {
    await _channel.invokeMethod('vermelho');
  }
}
