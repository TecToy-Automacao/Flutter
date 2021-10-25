import 'package:flutter/material.dart';
import 'package:tectoyexemplo/Utils/constants.dart';
import 'package:tectoyexemplo/Widgets/appbar.dart';
import 'package:tectoyexemplo/Widgets/button.dart';

class TextCompleto extends StatefulWidget {
  final String title;

  const TextCompleto({Key? key, required this.title}) : super(key: key);

  @override
  _TextCompletoState createState() => _TextCompletoState();
}

class _TextCompletoState extends State<TextCompleto> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(widget.title, false),
      backgroundColor: Constants.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ButtonWidget(
                text: "Todas as Funções",
                text_size: 18,
                text_color: Constants.white,
                background: Constants.text,
                onTap: () {}),
            SizedBox(height: 50.0),
            ButtonWidget(
                text: "Imprimir Ticket",
                text_size: 18,
                text_color: Constants.white,
                background: Constants.gray,
                onTap: () {}),
            SizedBox(height: 10.0),
            ButtonWidget(
                text: "Imprimir Ticket 2",
                text_size: 18,
                text_color: Constants.white,
                background: Constants.gray,
                onTap: () {}),
            SizedBox(height: 10.0),
            ButtonWidget(
                text: "Imprimir Bilhete",
                text_size: 18,
                text_color: Constants.white,
                background: Constants.gray,
                onTap: () {}),
            SizedBox(height: 10.0),
            ButtonWidget(
                text: "Imprimir Ticket 3",
                text_size: 18,
                text_color: Constants.white,
                background: Constants.gray,
                onTap: () {}),
            SizedBox(height: 10.0),
            ButtonWidget(
                text: "Imprimir intervalo em preto",
                text_size: 18,
                text_color: Constants.white,
                background: Constants.gray,
                onTap: () {}),
            SizedBox(height: 10.0),
            ButtonWidget(
                text: "Imprimir preto",
                text_size: 18,
                text_color: Constants.white,
                background: Constants.gray,
                onTap: () {}),
          ],
        ),
      ),
    );
  }
}
