import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tectoyexemplo/Utils/constants.dart';
import 'package:tectoyexemplo/Widgets/appbar.dart';
import 'package:tectoyexemplo/plugin/lampsdk.dart';
import 'package:tectoyexemplo/plugin/tectoysunmisdk.dart';

class Label extends StatefulWidget {
  final String title;

  const Label({Key? key, required this.title}) : super(key: key);

  @override
  _LabelState createState() => _LabelState();
}

class _LabelState extends State<Label> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(widget.title, false),
      backgroundColor: Constants.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 10.0),
            Container(
              color: Constants.red,
              height: 50.0,
              width: 1000.0,
              child: TextButton(
                  child: const Text("Imprimir Uma Etiqueta"),
                  style: TextButton.styleFrom(primary: Constants.white),
                  onPressed: () {
                    Tectoysunmisdk.printStyleBold(true);
                    Tectoysunmisdk.printonelabel("Mercadoria:     V2 Pro",
                        "Data de Validade:    05/11/2030", "458795689542");
                  }),
            ),
            SizedBox(height: 10.0),
            Container(
              color: Constants.red,
              height: 50.0,
              width: 1000.0,
              child: TextButton(
                  child: const Text("Imprimir Multi-Etiqueta"),
                  style: TextButton.styleFrom(primary: Constants.white),
                  onPressed: () {
                    Tectoysunmisdk.printStyleBold(true);
                    Tectoysunmisdk.printmultilabel("Mercadoria:     V2 Pro",
                        "Data de Validade:    05/11/2030", "458795689542");
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
