import 'package:flutter/services.dart';

class Msitef {
  static const MethodChannel _channel =
      const MethodChannel('samples.flutter.dev/gedi');

  static const String VENDA = '1';
  static const String CANCELAMENTO = '0';
  static const String CREDITO = "credito";
  static const String DEBITO = "debito";
  static const String CARTEIRADIGITAL = "carteiradigital";
  String result = "";
  String nsu = "";
  String codigoAutorizacao = "";
  String viaEstavelecimento = "";
  String viaCliente = "";

  Msitef() {
    print('Classe Msitef Iniciada');
  }

  static Future<String> efetuaOperacao({
    required String valor,
    required bool usb,
    required String modalidade,
    required String parcelas,
  }) async {
    Map<String, String> mapOperacao = Map();

    mapOperacao['valor'] = valor;
    mapOperacao['usb'] = "false";
    mapOperacao['modalidade'] = modalidade;
    mapOperacao['parcelas'] = parcelas;

    return await _channel.invokeMethod('efetuevenda', mapOperacao);
  }

  static Future<String> efetuaReimpresao({
    required String valor,
  }) async {
    Map<String, String> mapOperacao = Map();

    mapOperacao['valor'] = valor;

    return await _channel.invokeMethod('efetuereimpresao', mapOperacao);
  }

  static Future<String> efetuaCancelamento({
    required String valor,
  }) async {
    Map<String, String> mapOperacao = Map();

    mapOperacao['valor'] = valor;

    return await _channel.invokeMethod('efetuecancelamento', mapOperacao);
  }

  Msitef.fromJson(Map<String, dynamic> json) {
    result = json['CODRESP'];
    nsu = json['NSU_SITEF'];
    codigoAutorizacao = json['COD_AUTORIZACAO'];
    viaEstavelecimento = json['VIA_ESTABELECIMENTO'];
    viaCliente = json['VIA_CLIENTE'];
  }
}
