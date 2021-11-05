import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tectoyexemplo/Utils/constants.dart';
import 'package:tectoyexemplo/Widgets/appbar.dart';
import 'package:tectoyexemplo/Widgets/item.dart';

class Cancelar_activity extends StatefulWidget {
  final String title;

  const Cancelar_activity({Key? key, required this.title}) : super(key: key);

  @override
  _Cancelar_activityState createState() => _Cancelar_activityState();
}

class _Cancelar_activityState extends State<Cancelar_activity> {
  String nsu = "";
  String codigo_auto = "";
  String data = "";
  String valor = "";

  @override
  void initState() {
    this.nsu = "NSU";
    this.codigo_auto = "Codigo de Autorização";
    this.data = "Data";
    this.valor = "Valor da Operação";
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
                  text_menu: "Informe o NSU da Transação",
                  text_menu_cor: Constants.white,
                  text_menu_size: 20,
                  text_opcao: this.nsu,
                  text_opcao_cor: Constants.gray,
                  text_opcao_size: 15,
                  icon: Icons.arrow_forward_ios_sharp,
                  icon_cor: Constants.white,
                  icon_size: 30,
                  onTap: () {
                    print("Aqui");
                    _displayTextInputDialog(
                        "Indorme o NSU da Transação", nsu, nsu, context, "nsu");
                    setState(() {});
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                ItemMenu(
                  text_menu: "Codigo de Autorização",
                  text_menu_cor: Constants.white,
                  text_menu_size: 20,
                  text_opcao: this.codigo_auto,
                  text_opcao_cor: Constants.gray,
                  text_opcao_size: 15,
                  icon: Icons.arrow_forward_ios_sharp,
                  icon_cor: Constants.white,
                  icon_size: 30,
                  onTap: () {
                    print("Aqui");
                    _displayTextInputDialog("Codigo de Autorização",
                        codigo_auto, codigo_auto, context, "codigo_auto");
                    setState(() {});
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                ItemMenu(
                    text_menu: "Data da Transação",
                    text_menu_cor: Constants.white,
                    text_menu_size: 20,
                    text_opcao: this.data,
                    text_opcao_cor: Constants.gray,
                    text_opcao_size: 15,
                    icon: Icons.arrow_forward_ios_sharp,
                    icon_cor: Constants.white,
                    icon_size: 30,
                    onTap: () {
                      print("Aqui");
                      _displayTextInputDialog(
                          "Data da Transação", data, data, context, "data");
                    }),
                SizedBox(
                  height: 20,
                ),
                ItemMenu(
                    text_menu: "valor da Transação",
                    text_menu_cor: Constants.white,
                    text_menu_size: 20,
                    text_opcao: this.valor,
                    text_opcao_cor: Constants.gray,
                    text_opcao_size: 15,
                    icon: Icons.arrow_forward_ios_sharp,
                    icon_cor: Constants.white,
                    icon_size: 30,
                    onTap: () {
                      print("Aqui");
                      _displayTextInputDialog(
                          "Valor da Transação", valor, valor, context, "valor");
                    }),
                SizedBox(
                  height: 20,
                ),
                Container(
                  color: Constants.black,
                  height: 50.0,
                  width: 1000.0,
                  child: TextButton(
                      child: const Text("Confirmar"),
                      style: TextButton.styleFrom(primary: Constants.white),
                      onPressed: () {
                        print("Imprimir");
                      }),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  color: Constants.red,
                  height: 50.0,
                  width: 1000.0,
                  child: TextButton(
                      child: const Text("Cancelar"),
                      style: TextButton.styleFrom(primary: Constants.white),
                      onPressed: () {
                        print("Imprimir");
                      }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _displayTextInputDialog(String Title, String hintText,
      String oldValue, BuildContext context, String variavel) async {
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
                if (variavel == "nsu") {
                  nsu = _textFieldController.text;
                } else if (variavel == "codigo_auto") {
                  codigo_auto = _textFieldController.text;
                } else if (variavel == "data") {
                  data = _textFieldController.text;
                } else if (variavel == "valor") {
                  valor = _textFieldController.text;
                }
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
                  if (variavel == "nsu") {
                    nsu = oldValue;
                  } else if (variavel == "codigo_auto") {
                    codigo_auto = oldValue;
                  } else if (variavel == "data") {
                    data = oldValue;
                  } else if (variavel == "valor") {
                    valor = oldValue;
                  }
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
}
