// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
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

class QrCode extends StatefulWidget {
  final String title;

  const QrCode({Key? key, required this.title}) : super(key: key);

  @override
  _QrCodeState createState() => _QrCodeState();
}

class _QrCodeState extends State<QrCode> {
  String text_qrcode = "";
  String qrcode_quantidade = "";
  String qrcode_tamanho = "";
  String qrcode_nivel_correcao = "";
  String qrcode_alinhamento = "";

  @override
  void initState() {
    this.text_qrcode = "www.tectoysunmi.com.br";
    this.qrcode_quantidade = "QrCode";
    this.qrcode_tamanho = "8";
    this.qrcode_nivel_correcao = "Correção H (30%)";
    this.qrcode_alinhamento = "Esquerda";
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
                  text_menu: "QrCode",
                  text_menu_cor: Constants.white,
                  text_menu_size: 20,
                  text_opcao: this.text_qrcode,
                  text_opcao_cor: Constants.gray,
                  text_opcao_size: 15,
                  icon: Icons.arrow_forward_ios_sharp,
                  icon_cor: Constants.white,
                  icon_size: 30,
                  onTap: () {
                    print("Aqui");
                    setState(() {
                      _displayTextInputDialog(
                          "Informe o QrCode", "QrCode", text_qrcode, context);
                    });
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                ItemMenu(
                    text_menu: "Qtd. Impressão",
                    text_menu_cor: Constants.white,
                    text_menu_size: 20,
                    text_opcao: this.qrcode_quantidade,
                    text_opcao_cor: Constants.gray,
                    text_opcao_size: 15,
                    icon: Icons.arrow_forward_ios_sharp,
                    icon_cor: Constants.white,
                    icon_size: 30,
                    onTap: () {
                      print("Aqui");
                      List lista = ['Qrcode', 'Dois QrCode'];
                      _displayListInputDialog("Tipo De Impressão", "QrCode",
                          lista, context, "qrcode_quantidade");
                    }),
                SizedBox(
                  height: 20,
                ),
                ItemMenu(
                  text_menu: "QrCode Tamanho",
                  text_menu_cor: Constants.white,
                  text_menu_size: 20,
                  text_opcao: this.qrcode_tamanho,
                  text_opcao_cor: Constants.gray,
                  text_opcao_size: 15,
                  icon: Icons.arrow_forward_ios_sharp,
                  icon_cor: Constants.white,
                  icon_size: 30,
                  onTap: () {
                    print("Aqui");
                    final lista = List<String>.generate(12, (i) => "$i");
                    _displayListInputDialog("Tamanho Qrcode", "QrCode", lista,
                        context, "qrcode_tamanho");
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                ItemMenu(
                  text_menu: "Nivel de correção",
                  text_menu_cor: Constants.white,
                  text_menu_size: 20,
                  text_opcao: this.qrcode_nivel_correcao,
                  text_opcao_cor: Constants.gray,
                  text_opcao_size: 15,
                  icon: Icons.arrow_forward_ios_sharp,
                  icon_cor: Constants.white,
                  icon_size: 30,
                  onTap: () {
                    print("Aqui");
                    List lista = [
                      'Correção L (7%)',
                      'Correção M (15%)',
                      'Correção Q (25%)',
                      'Correção H (30%)'
                    ];
                    _displayListInputDialog("Tipo De Impressão", "QrCode",
                        lista, context, "qrcode_nivel_correcao");
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                ItemMenu(
                  text_menu: "Alinhamento",
                  text_menu_cor: Constants.white,
                  text_menu_size: 20,
                  text_opcao: this.qrcode_alinhamento,
                  text_opcao_cor: Constants.gray,
                  text_opcao_size: 15,
                  icon: Icons.arrow_forward_ios_sharp,
                  icon_cor: Constants.white,
                  icon_size: 30,
                  onTap: () {
                    print("Aqui");
                    List lista = ['Esquerda', 'Centro', 'Direita'];
                    _displayListInputDialog("Alinhamento", "QrCode", lista,
                        context, "qrcode_alinhamento");
                  },
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Container(
              color: Colors.white,
              child: QrImage(
                data: text_qrcode,
                size: 250,
              ),
            ),
            SizedBox(height: 10.0),
            /*    ButtonWidget (
                text: "Imprimir",
                text_size: 18,
                text_color: Constants.white,
                background: Constants.gray,
                onTap: () {},

                ), */
            Container(
              color: Constants.red,
              height: 50.0,
              width: 1000.0,
              child: TextButton(
                  child: const Text("Imprimir"),
                  style: TextButton.styleFrom(primary: Constants.white),
                  onPressed: () {
                    printQrCodeQr(
                        text_qrcode, qrcode_tamanho, qrcode_alinhamento);
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> printQrCodeQr(
      String texto, String tamanho, String alinhamento) async {
    await Tectoysunmisdk.printQrCode(texto, tamanho, alinhamento);
  }

  /*  @override
  Widget build(BuildContext context) {
    // The GestureDetector wraps the button.
    return GestureDetector(
      // When the child is tapped, show a snackbar.
      onTap: () {
        Tectoysunmisdk.printQrCode;
      },
      // The custom button
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.lightBlue,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: const Text('Button'),
      ),
    );
  }
 */

  Future<void> _displayTextInputDialog(String Title, String hintText,
      String oldValue, BuildContext context) async {
    TextEditingController _textFieldController = new TextEditingController();
    String oldText = oldValue;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(Title),
          content: TextField(
            onChanged: (value) {
              setState(() {
                // valueText = value;
                text_qrcode = _textFieldController.text;
              });
            },
            controller: _textFieldController,
            decoration: InputDecoration(hintText: hintText),
          ),
          actions: <Widget>[
            FlatButton(
              color: Colors.red,
              textColor: Colors.white,
              child: Text('CANCEL'),
              onPressed: () {
                setState(() {
                  text_qrcode = oldValue;
                  Navigator.pop(context);
                });
              },
            ),
            FlatButton(
              color: Colors.green,
              textColor: Colors.white,
              child: Text('OK'),
              onPressed: () {
                setState(() {
                  // codeDialog = valueText;
                  Navigator.pop(context);
                });
              },
            ),
          ],
        );
      },
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
                  if (variavel == "qrcode_alinhamento") {
                    qrcode_alinhamento = oldText[_id];
                  } else if (variavel == "qrcode_nivel_correcao") {
                    qrcode_nivel_correcao = oldText[_id];
                  } else if (variavel == "qrcode_quantidade") {
                    qrcode_quantidade = oldText[_id];
                  } else if (variavel == "qrcode_tamanho") {
                    qrcode_tamanho = oldText[_id];
                  }
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
}
