import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tectoyexemplo/Utils/constants.dart';
import 'package:tectoyexemplo/Widgets/appbar.dart';
import 'package:tectoyexemplo/plugin/tectoysunmisdk.dart';

class Lcd extends StatefulWidget {
  final String title;

  const Lcd({Key? key, required this.title}) : super(key: key);

  @override
  _LcdState createState() => _LcdState();
}

class _LcdState extends State<Lcd> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(widget.title, false),
      backgroundColor: Constants.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 15.0),
            Container(
              color: Constants.red,
              height: 50.0,
              width: 10000.0,
              child: TextButton(
                  child: const Text("Exibir uma Linha"),
                  style: TextButton.styleFrom(primary: Constants.white),
                  onPressed: () async {
                    print("imprimir");
                    Tectoysunmisdk.controlLcd();
                    Tectoysunmisdk.sendTextToLcd();
                  }),
            ),
            SizedBox(height: 15.0),
            Container(
              color: Constants.red,
              height: 50.0,
              width: 10000.0,
              child: TextButton(
                  child: const Text("Linhas de Exibição"),
                  style: TextButton.styleFrom(primary: Constants.white),
                  onPressed: () async {
                    print("imprimir");
                    Tectoysunmisdk.controlLcd();
                    Tectoysunmisdk.sendTextsToLcd();
                  }),
            ),
            SizedBox(height: 15.0),
            Container(
              color: Constants.red,
              height: 50.0,
              width: 10000.0,
              child: TextButton(
                  child: const Text("Exibir Imagens"),
                  style: TextButton.styleFrom(primary: Constants.white),
                  onPressed: () async {
                    print("imprimir");
                    Tectoysunmisdk.controlLcd();
                    Tectoysunmisdk.sendPicToLcd();
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
