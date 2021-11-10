import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tectoyexemplo/Utils/constants.dart';
import 'package:tectoyexemplo/Widgets/appbar.dart';
import 'package:tectoyexemplo/plugin/lampsdk.dart';

class Klamp extends StatefulWidget {
  final String title;

  const Klamp({Key? key, required this.title}) : super(key: key);

  @override
  _KlampState createState() => _KlampState();
}

Lampsdk lamp = new Lampsdk();

class _KlampState extends State<Klamp> {
  String vermelho = "Vermelho";
  String amarelo = "Amarelo";
  String azul = "Azul";
  String azulclaro = "Azul Claro";
  String roxo = "Roxo";
  String verde = "Verde";
  String desligar = "Desligar";

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
            SizedBox(height: 10.0),
            Container(
              color: Constants.red,
              height: 50.0,
              width: 1000.0,
              child: TextButton(
                  child: const Text("Roxo"),
                  style: TextButton.styleFrom(primary: Constants.white),
                  onPressed: () {
                    Lampsdk.init();
                    Lampsdk.roxo();
                  }),
            ),
            SizedBox(height: 10.0),
            Container(
              color: Constants.red,
              height: 50.0,
              width: 1000.0,
              child: TextButton(
                  child: const Text("Azul Claro"),
                  style: TextButton.styleFrom(primary: Constants.white),
                  onPressed: () {
                    Lampsdk.init();
                    Lampsdk.azulclaro();
                  }),
            ),
            SizedBox(height: 10.0),
            Container(
              color: Constants.red,
              height: 50.0,
              width: 1000.0,
              child: TextButton(
                  child: const Text("Azul"),
                  style: TextButton.styleFrom(primary: Constants.white),
                  onPressed: () {
                    Lampsdk.init();
                    Lampsdk.azul();
                  }),
            ),
            SizedBox(height: 10.0),
            Container(
              color: Constants.red,
              height: 50.0,
              width: 1000.0,
              child: TextButton(
                  child: const Text("Verde"),
                  style: TextButton.styleFrom(primary: Constants.white),
                  onPressed: () {
                    Lampsdk.init();
                    Lampsdk.verde();
                  }),
            ),
            SizedBox(height: 10.0),
            Container(
              color: Constants.red,
              height: 50.0,
              width: 1000.0,
              child: TextButton(
                  child: const Text("Vermelho"),
                  style: TextButton.styleFrom(primary: Constants.white),
                  onPressed: () {
                    Lampsdk.init();
                    Lampsdk.vermelho();
                  }),
            ),
            SizedBox(height: 10.0),
            Container(
              color: Constants.red,
              height: 50.0,
              width: 1000.0,
              child: TextButton(
                  child: const Text("Amarelo"),
                  style: TextButton.styleFrom(primary: Constants.white),
                  onPressed: () {
                    Lampsdk.init();
                    Lampsdk.amarelo();
                  }),
            ),
            SizedBox(height: 10.0),
            Container(
              color: Constants.red,
              height: 50.0,
              width: 1000.0,
              child: TextButton(
                  child: const Text("Desligar"),
                  style: TextButton.styleFrom(primary: Constants.white),
                  onPressed: () {
                    Lampsdk.init();
                    Lampsdk.desligar();
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
