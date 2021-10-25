import 'package:flutter/material.dart';

import 'package:tectoyexemplo/Utils/constants.dart';
import 'package:tectoyexemplo/Widgets/appbar.dart';
import 'package:tectoyexemplo/Widgets/button.dart';
import 'package:tectoyexemplo/Widgets/item.dart';
import 'package:tectoyexemplo/plugin/tectoysunmisdk.dart';
import 'package:flutter/src/widgets/framework.dart';

class BarCode extends StatefulWidget {
  final String title;

  const BarCode({Key? key, required this.title}) : super(key: key);

  @override
  _BarCodeState createState() => _BarCodeState();
}

class _BarCodeState extends State<BarCode> {
  String text_barcode = "";
  String barcode_modelo = "";
  String barcode_posicao = "";
  String barcode_altura = "";
  String barcode_largura = "";

  @override
  void initState() {
    // TODO: implement initState
    this.text_barcode = "201705070507";
    this.barcode_modelo = "EAN13";
    this.barcode_posicao = "Acima do código de barras";
    this.barcode_altura = "162";
    this.barcode_largura = "2";
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
                  text_menu: "BarCode",
                  text_menu_cor: Constants.white,
                  text_menu_size: 20,
                  text_opcao: this.text_barcode,
                  text_opcao_cor: Constants.gray,
                  text_opcao_size: 15,
                  icon: Icons.arrow_forward_ios_sharp,
                  icon_cor: Constants.white,
                  icon_size: 30,
                  onTap: () {
                    print("Aqui");
                    _displayTextInputDialog(
                        "Insira o Conteúdo do código de barras",
                        "201705070507",
                        text_barcode,
                        context);
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                ItemMenu(
                  text_menu: "Modelos de BarCode",
                  text_menu_cor: Constants.white,
                  text_menu_size: 20,
                  text_opcao: this.barcode_modelo,
                  text_opcao_cor: Constants.gray,
                  text_opcao_size: 15,
                  icon: Icons.arrow_forward_ios_sharp,
                  icon_cor: Constants.white,
                  icon_size: 30,
                  onTap: () {
                    print("Aqui");
                    List listaModelo = ['UPC-A', 'UPC-E', 'EAN13', 'EAN8'];
                    _displayListInputDialog("Modelos de BarCode", "hintText",
                        listaModelo, context, 'barcode_modelo');
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                ItemMenu(
                  text_menu: "HRI posição",
                  text_menu_cor: Constants.white,
                  text_menu_size: 20,
                  text_opcao: this.barcode_posicao,
                  text_opcao_cor: Constants.gray,
                  text_opcao_size: 15,
                  icon: Icons.arrow_forward_ios_sharp,
                  icon_cor: Constants.white,
                  icon_size: 30,
                  onTap: () {
                    print("Aqui");
                    List listaPosicao = [
                      'Informe um Texto',
                      'Acima do código de barras barcode',
                      'Abaixo do código de barras',
                      'Acima e Abaixo do código de barras'
                    ];
                    _displayListInputDialog("HRI Posição", "hintText",
                        listaPosicao, context, "barcode_posicao");
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                ItemMenu(
                  text_menu: "Altura",
                  text_menu_cor: Constants.white,
                  text_menu_size: 20,
                  text_opcao: this.barcode_altura,
                  text_opcao_cor: Constants.gray,
                  text_opcao_size: 15,
                  icon: Icons.arrow_forward_ios_sharp,
                  icon_cor: Constants.white,
                  icon_size: 30,
                  onTap: () {
                    print("Aqui");
                    var listaAltura =
                        new List<String>.generate(255, (i) => "$i");
                    _displayListInputDialog("Largura", barcode_altura,
                        listaAltura, context, "barcode_altura");
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                ItemMenu(
                  text_menu: "Largura",
                  text_menu_cor: Constants.white,
                  text_menu_size: 20,
                  text_opcao: this.barcode_largura,
                  text_opcao_cor: Constants.gray,
                  text_opcao_size: 15,
                  icon: Icons.arrow_forward_ios_sharp,
                  icon_cor: Constants.white,
                  icon_size: 30,
                  onTap: () {
                    print("Aqui");
                    var lista = new List<String>.generate(6, (i) => "$i");
                    _displayListInputDialog("Largura", barcode_largura, lista,
                        context, "barcode_largura");
                  },
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Image.asset("assets/image/logo_tectoy_sunmi.png"),
            SizedBox(height: 10.0),
            /*  ButtonWidget(
                text: "Imprimir",
                text_size: 18,
                text_color: Constants.white,
                background: Constants.gray,
                onTap: () {
                  print("object");
                  int num1 = int.parse(barcode_altura);
                  int num2 = int.parse(barcode_largura);
                  Tectoysunmisdk.printBar(text_barcode, barcode_modelo, num1,
                      num2, barcode_posicao);
                }), */
            Container(
              color: Constants.red,
              height: 50.0,
              width: 1000.0,
              child: TextButton(
                  child: const Text("Imprimir"),
                  style: TextButton.styleFrom(primary: Constants.white),
                  onPressed: () {
                    print(barcode_posicao);
                    printBar(
                        text_barcode,
                        barcode_modelo,
                        int.parse(barcode_altura),
                        int.parse(barcode_largura),
                        barcode_posicao.toString());
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> printBar(String text, String simbolo, int height, int width,
      String textposition) async {
    BarCodeTextPosition posicao =
        BarCodeTextPosition.ABAIXO_DO_CODIGO_DE_BARRAS;
    BarCodeModels modelo = BarCodeModels.CODABAR;

    if (textposition == 'Informe um Texto') {
      posicao = BarCodeTextPosition.INFORME_UM_TEXTO;
    } else if (textposition == 'Abaixo do código de barras') {
      posicao = BarCodeTextPosition.ABAIXO_DO_CODIGO_DE_BARRAS;
    } else if (textposition == 'Acima do código de barras') {
      posicao = BarCodeTextPosition.ABAIXO_DO_CODIGO_DE_BARRAS;
    } else if (textposition == 'Acima e Abaixo do código de  barras') {
      posicao = BarCodeTextPosition.ACIMA_E_ABAIXO_DO_CODIGO_DE_BARRAS;
    }
    if (simbolo == "UPC-A") {
      modelo = BarCodeModels.UPC_A;
    } else if (simbolo == "UPC-E") {
      modelo = BarCodeModels.UPC_E;
    } else if (simbolo == "EAN13") {
      modelo = BarCodeModels.EAN13;
    } else if (simbolo == "EAN18") {
      modelo = BarCodeModels.EAN8;
    }

    Tectoysunmisdk.printBar(text, modelo, height, width, posicao);
    print(posicao);
  }

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
                text_barcode = _textFieldController.text;
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
                text_barcode = oldValue;
                Navigator.pop(context);
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
                  if (variavel == "barcode_modelo") {
                    barcode_modelo = oldText[_id];
                  } else if (variavel == "barcode_posicao") {
                    barcode_posicao = oldText[_id];
                  } else if (variavel == "barcode_altura") {
                    barcode_altura = oldText[_id];
                  } else if (variavel == "barcode_largura") {
                    barcode_largura = oldText[_id];
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
