import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:tectoyexemplo/Utils/constants.dart';
import 'package:tectoyexemplo/Widgets/appbar.dart';
import 'package:tectoyexemplo/Widgets/item.dart';

class LeituraBarCode extends StatefulWidget {
  final String title;

  const LeituraBarCode({Key? key, required this.title}) : super(key: key);
  @override
  _LeituraBarCodeState createState() => _LeituraBarCodeState();
}

class _LeituraBarCodeState extends State<LeituraBarCode> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(widget.title, false),
      backgroundColor: Constants.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Column(
              children: [Text("data")],
            ),
          ],
        ),
      ),
    );
  }
}
