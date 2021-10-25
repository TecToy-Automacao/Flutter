import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class LeituraBarCode extends StatefulWidget {
  final String title;

  const LeituraBarCode({Key? key, required this.title}) : super(key: key);
  @override
  _LeituraBarCodeState createState() => _LeituraBarCodeState();
}

class _LeituraBarCodeState extends State<LeituraBarCode> {
  String _scanBarcode = 'Unknown';

  @override
  void initState() {
    super.initState();
  }

  Future<void> startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            '#ff6666', 'Cancelar', true, ScanMode.BARCODE)!
        .listen((barcode) => print(barcode));
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancelar', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = (await FlutterBarcodeScanner.getBarcodeStreamReceiver(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE)) as String;
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;
    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(title: const Text('Scanner')),
            body: Builder(builder: (BuildContext context) {
              return Container(
                  alignment: Alignment.center,
                  child: Flex(
                      direction: Axis.vertical,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        //ElevatedButton(
                        //   onPressed: () => scanBarcodeNormal(),
                        //  child: Text('BarCode')),
                        ElevatedButton(
                            onPressed: () => scanQR(),
                            child: Text('Leitura BarCode/QrCode')),
                        ElevatedButton(
                            onPressed: () => startBarcodeScanStream(),
                            child: Text('P2')),
                        Text('Scanner Resultado : $_scanBarcode\n',
                            style: TextStyle(fontSize: 20))
                      ]));
            })));
  }
}
