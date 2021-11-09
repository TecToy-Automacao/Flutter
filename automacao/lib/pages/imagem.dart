// import 'dart:html';

//import 'dart:html';

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:qr_flutter/qr_flutter.dart';
import 'package:tectoyexemplo/Utils/constants.dart';
import 'package:tectoyexemplo/Widgets/appbar.dart';
import 'package:tectoyexemplo/Widgets/button.dart';
import 'package:tectoyexemplo/Widgets/inputdialog.dart';
import 'package:tectoyexemplo/Widgets/item.dart';
import 'package:tectoyexemplo/Widgets/showalertdialog.dart';
import 'package:tectoyexemplo/pages/qrcode.dart';
import 'package:tectoyexemplo/plugin/tectoysunmisdk.dart';
// import 'package:bitmap/bitmap.dart';

class Imagem extends StatefulWidget {
  final String title;

  const Imagem({Key? key, required this.title}) : super(key: key);

  @override
  _ImagemState createState() => _ImagemState();
}

class _ImagemState extends State<Imagem> {
  String text_aling = "";
  String text_modo = "";

  @override
  void initState() {
    this.text_aling = "Centro";
    this.text_modo = "Retrato";
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
              children: [
                ItemMenu(
                  text_menu: "Alinhamento",
                  text_menu_cor: Constants.white,
                  text_menu_size: 20,
                  text_opcao: this.text_aling,
                  text_opcao_cor: Constants.gray,
                  text_opcao_size: 15,
                  icon: Icons.arrow_forward_ios_sharp,
                  icon_cor: Constants.white,
                  icon_size: 30,
                  onTap: () {
                    print("Aqui");
                    setState(() {
                      List lista = ['Esquerda', 'Centro', 'Direita'];
                      _displayListInputDialog("Informe o QrCode", "QrCode",
                          lista, context, "variavel");
                    });
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                ItemMenu(
                    text_menu: "Modo Impressão imagem",
                    text_menu_cor: Constants.white,
                    text_menu_size: 20,
                    text_opcao: this.text_modo,
                    text_opcao_cor: Constants.gray,
                    text_opcao_size: 15,
                    icon: Icons.arrow_forward_ios_sharp,
                    icon_cor: Constants.white,
                    icon_size: 30,
                    onTap: () {
                      print("Aqui");
                      List lista = ['Paisagem', 'Retrato'];
                      _displayListInputDialog("Tipo De Impressão", "QrCode",
                          lista, context, "qrcode_quantidade");
                    }),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
            SizedBox(height: 100.0),
            Image.asset("assets/image/test.jpg"),
            SizedBox(height: 15.0),
            Container(
              color: Constants.red,
              height: 50.0,
              width: 1000.0,
              child: TextButton(
                  child: const Text("Imprimir"),
                  style: TextButton.styleFrom(primary: Constants.white),
                  onPressed: () async {
                    print("imprimir");
                    Image img = Image.asset("assets/image/test.jpg");
                    Tectoysunmisdk.printImage();
                    var bytes =
                        await new File("assets/image/test.jpg").readAsBytes();
                    print(bytes);
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _displayListInputDialog(String Title, String hintText,
      List oldValue, BuildContext context, String variavel) async {
    TextEditingController _textFieldController = new TextEditingController();
    List oldText = oldValue;
    int _id = 0;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(Title),
          content: ListView.builder(
            shrinkWrap: true,
            itemCount: oldText.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text('${oldText[index]}'),
                onTap: () {
                  setState(() {
                    _id = index;
                  });

                  Navigator.pop(context);
                },
              );
            },
          ),
          actions: <Widget>[
            FlatButton(
              color: Colors.red,
              textColor: Colors.white,
              child: Text('CANCEL'),
              onPressed: () {
                setState(() {
                  Navigator.pop(context);
                });
              },
            ),
          ],
        );
      },
    );
  }

  getTemporaryDirectory() {}
}
