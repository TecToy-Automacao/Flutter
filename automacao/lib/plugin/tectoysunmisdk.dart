import 'dart:async';
//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum TextoAlinhamento { LEFT, CENTER, RIGTH }

enum BarCodeModels {
  UPC_A,
  UPC_E,
  EAN13,
  EAN8,
  CODE39,
  ITF,
  CODABAR,
  CODE93,
  CODE128A,
  CODE128B,
  CODE128C
}

enum BarCodeTextPosition {
  INFORME_UM_TEXTO,
  ACIMA_DO_CODIGO_DE_BARRAS_BARCODE,
  ABAIXO_DO_CODIGO_DE_BARRAS,
  ACIMA_E_ABAIXO_DO_CODIGO_DE_BARRAS
}

class Tectoysunmisdk {
  static const MethodChannel _channel = const MethodChannel('tectoysunmisdk');

  static Future<void> initiServiceTecToySunmiSDK() async {
    await _channel.invokeMethod('setInitiServiceTecToySunmiSDK');
  }

  //******************************************************** */
  // Funções da Impressora
  //******************************************************** */

  // Inicia a impressora
  static Future<void> setInitPrint() async {
    await _channel.invokeMethod('setInitPrint');
  }

  // Inicia a impressora
  static Future<void> setAlignment(TextoAlinhamento textoAlinhamento) async {
    Map<String, dynamic> alinhamento = Map();

    if (textoAlinhamento == TextoAlinhamento.LEFT) {
      alinhamento['alinhamento'] = 0;
    } else if (textoAlinhamento == TextoAlinhamento.CENTER) {
      alinhamento['alinhamento'] = 1;
    } else if (textoAlinhamento == TextoAlinhamento.RIGTH) {
      alinhamento['alinhamento'] = 2;
    }
    await _channel.invokeMethod('setAlignment', alinhamento);
  }

  // Style Impressão
  static Future<void> printStyleBold(bool status) async {
    Map<String, dynamic> style = Map();
    style['status'] = status;
    await _channel.invokeMethod('printStyleBold', style);
  }

  // Style Impressão
  static Future<void> printStyleUnderLine(bool status) async {
    Map<String, dynamic> style = Map();
    style['status'] = status;
    await _channel.invokeMethod('printStyleUnderLine', style);
  }

// Style Impressão
  static Future<void> printStyleAntiWhite(bool status) async {
    Map<String, dynamic> style = Map();
    style['status'] = status;
    await _channel.invokeMethod('printStyleAntiWhite', style);
  }

// Style Impressão
  static Future<void> printStyleDoubleHeight(bool status) async {
    Map<String, dynamic> style = Map();
    style['status'] = status;
    await _channel.invokeMethod('printStyleDoubleHeight', style);
  }

// Style Impressão
  static Future<void> printStyleDoubleWidth(bool status) async {
    Map<String, dynamic> style = Map();
    style['status'] = status;
    await _channel.invokeMethod('printStyleDoubleWidth', style);
  }

// Style Impressão
  static Future<void> printStyleItalic(bool status) async {
    Map<String, dynamic> style = Map();
    style['status'] = status;
    await _channel.invokeMethod('printStyleItalic', style);
  }

// Style Impressão
  static Future<void> printStyleInvert(bool status) async {
    Map<String, dynamic> style = Map();
    style['status'] = status;
    await _channel.invokeMethod('printStyleInvert', style);
  }

// Style Impressão
  static Future<void> printStyleStrikethRough(bool status) async {
    Map<String, dynamic> style = Map();
    style['status'] = status;
    await _channel.invokeMethod('printStyleStrikethRough', style);
  }

// Style Impressão
  static Future<void> printStyleReset() async {
    await _channel.invokeMethod('printStyleReset');
  }

  // Efetua a impressão de texto
  static Future<void> printText(String text) async {
    Map<String, dynamic> textWithSize = Map();
    textWithSize['texto'] = text;
    await _channel.invokeMethod('printText', textWithSize);
  }

  // Efetua a impressão de texto
  static Future<void> printTextWithSize(String text, int size) async {
    Map<String, dynamic> textWithSize = Map();
    textWithSize['texto'] = text;
    textWithSize['size'] = size;
    await _channel.invokeMethod('printTextWithSize', textWithSize);
  }

  // Efetua Impressão de Imagem
  static Future<void> printImage() async {
    Map<String, dynamic> textWithSize = Map();
    // Implementar metodo
    await _channel.invokeMethod('printBitmap', textWithSize);
  }

  // Efetua impressão de etiqueta
  static Future<void> printonelabel(
      String texto, String data, String code) async {
    Map<String, dynamic> printlabel = Map();
    printlabel['texto'] = texto;
    printlabel['data'] = data;
    printlabel['code'] = code;
    await _channel.invokeMethod('printonelabel', printlabel);
  }

  static Future<void> printmultilabel(
      String texto, String data, String code) async {
    Map<String, dynamic> printmulti = Map();
    printmulti['texto'] = texto;
    printmulti['data'] = data;
    printmulti['code'] = code;
    await _channel.invokeMethod('printmultilabel', printmulti);
  }

  static Future<void> printTextoCompleto(
      String text, int size, String charset, bool bold, bool underline) async {
    setInitPrint();
    setFontSize(size);
    if (bold == true) {
      printStyleBold(true);
    } else {
      printStyleBold(false);
    }
    if (underline == true) {
      printStyleUnderLine(true);
    } else {
      printStyleUnderLine(false);
    }
    printText(text);
    print3Line();
  }

  // Efetua a impressão de QrCode
  static Future<void> printQr(String text, int size, int errorLevel) async {
    Map<String, dynamic> qrCode = Map();
    qrCode['texto'] = text;
    qrCode['size'] = size;
    qrCode['errorLevel'] = size;
    await _channel.invokeMethod('printQr', qrCode);
  }

  // Mostra status da impressora
  static Future<String> printerStatus() async {
    return await _channel.invokeMethod('printerStatus');
  }

  // Corta o papel
  static Future<void> cutpaper() async {
    await _channel.invokeMethod('cutpaper');
  }

  // Abre Gavera
  static Future<void> openCashBox() async {
    await _channel.invokeMethod('openCashBox');
  }

  // Imprime BarCode
  static Future<void> printBarCode(String text, BarCodeModels symbology,
      int height, int width, BarCodeTextPosition textposition) async {
    Map<String, dynamic> barCode = Map();
    barCode['texto'] = text;

    if (symbology.index > 7) {
      barCode['symbology'] = 8;
    } else {
      barCode['symbology'] = symbology.index;
    }

    barCode['height'] = height;
    barCode['width'] = width;

    if (textposition == BarCodeTextPosition.INFORME_UM_TEXTO) {
      barCode['textposition'] = 0;
    } else if (textposition == BarCodeTextPosition.ABAIXO_DO_CODIGO_DE_BARRAS) {
      barCode['textposition'] = 1;
    } else if (textposition ==
        BarCodeTextPosition.ACIMA_DO_CODIGO_DE_BARRAS_BARCODE) {
      barCode['textposition'] = 2;
    } else if (textposition ==
        BarCodeTextPosition.ACIMA_E_ABAIXO_DO_CODIGO_DE_BARRAS) {
      barCode['textposition'] = 3;
    }

    await _channel.invokeMethod('printBarCode', barCode);
  }

  static Future<String?> printBar(String text, BarCodeModels simbolo,
      int height, int width, BarCodeTextPosition textposition) async {
    setInitPrint();
    setFontSize(24);
    setAlignment(TextoAlinhamento.CENTER);
    printBarCode(text, simbolo, height, width, textposition);
    print3Line();
  }

  // Imprimi Tabela
  static Future<String?> prinable(String json) async {
    setInitPrint();
    setFontSize(24);
    /* printTable('{"lines": ['
        '{"txts": ["$texto","$texto","$texto"],"width": [50,50,50],"align": [0,1,2]},'
        ']}'); */
    print3Line();
  }

  // Tamanho da fonte
  static Future<void> setFontSize(int size) async {
    Map<String, dynamic> fontSize = Map();
    fontSize['size'] = size;
    await _channel.invokeMethod('setFontSize', fontSize);
  }

  // Avança 3 linhas
  static Future<void> print3Line() async {
    await _channel.invokeMethod('print3Line');
  }

  // Avança  linhas
  static Future<void> printAdvanceLines(int lines) async {
    Map<String, dynamic> lines = Map();
    lines['lines'] = lines;
    await _channel.invokeMethod('printAdvanceLines', lines);
  }

  // Avança  linhas
  static Future<void> printTable(String json) async {
    Map<String, dynamic> lines = Map();
    lines['json'] = json;
    await _channel.invokeMethod('printTable', lines);
  }

  // Avança  linhas
  static Future<void> feedPaper() async {
    await _channel.invokeMethod('feedPaper');
  }

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  // Imprimi QrCode
  static Future<String?> printQrCode(
      String texto, String tamanho, String alinhamento) async {
    setInitPrint();
    setFontSize(24);

    // Alinhamento do texto
    setAlignment(TextoAlinhamento.CENTER);
    printText("QrCode\n");
    printText("--------------------------------\n");

    // Alinhamento
    if (alinhamento == "Esquerda") {
      setAlignment(TextoAlinhamento.LEFT);
    } else if (alinhamento == "Centro") {
      setAlignment(TextoAlinhamento.CENTER);
    } else if (alinhamento == "Direita") {
      setAlignment(TextoAlinhamento.RIGTH);
    }

    int tam = int.parse(tamanho);

    printQr(texto, tam, 1);
    print3Line();
    cutpaper();
  }

  static Future<String?> get printFullFunctions async {
    setInitPrint();
    setFontSize(24);

    // Alinhamento do texto
    setAlignment(TextoAlinhamento.CENTER);

    printText("Alinhamento\n");
    printText("--------------------------------\n");
    setAlignment(TextoAlinhamento.LEFT);
    printText("TecToy Sunmi\n");
    setAlignment(TextoAlinhamento.CENTER);
    printText("TecToy Sunmi\n");
    setAlignment(TextoAlinhamento.RIGTH);
    printText("TecToy Sunmi\n");
    //feedPaper();

    // Formas de impressão
    setAlignment(TextoAlinhamento.CENTER);
    printText("Formas de Impressão\n");
    printText("--------------------------------\n");
    setFontSize(28);
    setAlignment(TextoAlinhamento.LEFT);
    printStyleBold(true);
    printText("TecToy Sunmi\n");
    printStyleReset();
    printStyleAntiWhite(true);
    printText("TecToy Sunmi\n");
    printStyleReset();
    printStyleDoubleHeight(true);
    printText("TecToy Sunmi\n");
    printStyleReset();
    printStyleDoubleWidth(true);
    printText("TecToy Sunmi\n");
    printStyleReset();
    printStyleInvert(true);
    printText("TecToy Sunmi\n");
    printStyleReset();
    printStyleItalic(true);
    printText("TecToy Sunmi\n");
    printStyleReset();
    printStyleStrikethRough(true);
    printText("TecToy Sunmi\n");
    printStyleReset();
    printStyleUnderLine(true);
    printText("TecToy Sunmi\n");
    printStyleReset();
    //feedPaper();

    setFontSize(24);
    // Impressão de BarCode
    setAlignment(TextoAlinhamento.CENTER);
    printText("Imprime BarCode\n");
    printText("--------------------------------\n");
    setAlignment(TextoAlinhamento.LEFT);
    printBarCode("7894900700046", BarCodeModels.EAN13, 162, 2,
        BarCodeTextPosition.INFORME_UM_TEXTO);
    printAdvanceLines(2);
    setAlignment(TextoAlinhamento.CENTER);
    printBarCode("7894900700046", BarCodeModels.EAN13, 162, 2,
        BarCodeTextPosition.ABAIXO_DO_CODIGO_DE_BARRAS);
    printAdvanceLines(2);
    setAlignment(TextoAlinhamento.RIGTH);
    printBarCode("7894900700046", BarCodeModels.EAN13, 162, 2,
        BarCodeTextPosition.ACIMA_DO_CODIGO_DE_BARRAS_BARCODE);
    printAdvanceLines(2);
    setAlignment(TextoAlinhamento.CENTER);
    printBarCode("7894900700046", BarCodeModels.EAN13, 162, 2,
        BarCodeTextPosition.ACIMA_E_ABAIXO_DO_CODIGO_DE_BARRAS);
    //feedPaper();

    // Impressão de BarCode
    setAlignment(TextoAlinhamento.CENTER);
    printText("Imprime QrCode\n");
    printText("--------------------------------\n");
    setAlignment(TextoAlinhamento.LEFT);
    printQr("www.tectoysunmi.com.br", 8, 1);
    feedPaper();
    setAlignment(TextoAlinhamento.CENTER);
    printQr("www.tectoysunmi.com.br", 8, 1);
    feedPaper();
    setAlignment(TextoAlinhamento.RIGTH);
    printQr("www.tectoysunmi.com.br", 8, 1);
    //feedPaper();

    setAlignment(TextoAlinhamento.CENTER);
    printText("Imprime Tabela\n");
    printText("--------------------------------\n");

    printTable('{"lines": [' +
        '{"txts": ["Produto 001","10 und","3,98"],"width": [100,50,50],"align": [0,1,2]},' +
        '{"txts": ["Produto 002"," 1 und","8,98"],"width": [100,50,50],"align": [0,1,2]},' +
        '{"txts": ["Produto 003"," 5 und","4,98"],"width": [100,50,50],"align": [0,1,2]},' +
        '{"txts": ["Produto 004"," 4 und","0,98"],"width": [100,50,50],"align": [0,1,2]},' +
        '{"txts": ["Produto 005"," 8 und","3,98"],"width": [100,50,50],"align": [0,1,2]},' +
        '{"txts": ["Produto 006"," 1 und","3,98"],"width": [100,50,50],"align": [0,1,2]},' +
        '{"txts": ["Produto 007"," 1 und","3,98"],"width": [100,50,50],"align": [0,1,2]},' +
        '{"txts": ["Produto 008"," 1 und","3,98"],"width": [100,50,50],"align": [0,1,2]},' +
        '{"txts": ["Produto 009"," 1 und","3,98"],"width": [100,50,50],"align": [0,1,2]},' +
        '{"txts": ["Produto 010"," 1 und","3,98"],"width": [100,50,50],"align": [0,1,2]},' +
        '{"txts": ["Produto 011"," 1 und","3,98"],"width": [100,50,50],"align": [0,1,2]},' +
        '{"txts": ["Produto 012"," 1 und","3,98"],"width": [100,50,50],"align": [0,1,2]},' +
        '{"txts": ["Produto 013"," 1 und","3,98"],"width": [100,50,50],"align": [0,1,2]}' +
        ']}');

    print3Line();
    openCashBox();
    cutpaper();
  }
}
