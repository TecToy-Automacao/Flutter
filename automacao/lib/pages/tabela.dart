

import 'package:flutter/material.dart';
import 'package:tectoyexemplo/Utils/constants.dart';
import 'package:tectoyexemplo/Widgets/appbar.dart';
import 'package:tectoyexemplo/Widgets/button.dart';
import 'package:tectoyexemplo/Widgets/item.dart';
import 'package:tectoyexemplo/pages/t.dart';
import 'package:tectoyexemplo/pages/texto.dart';
import 'package:tectoyexemplo/plugin/tectoysunmisdk.dart';

class Tabela extends StatefulWidget {
  final String title;

  const Tabela({Key? key, required this.title}) : super(key: key);

  @override
  _TabelaState createState() => _TabelaState();
}

class _TabelaState extends State<Tabela> {
  String nomeCidade = "";
  var _alinhamento = ['Esquerda', 'Centro', 'Direita'];
  var _lista = new List<String>.generate(100, (i) => "$i");
  var _itemSelecionado = 'Esquerda';
  var _listaSele = '0';

// Criando Vetores
  List<TextEditingController> edt_num1 = [];
  List<TextEditingController> edt_num2 = [];
  List<TextEditingController> edt_num3 = [];
  List<TextEditingController> edt_aling1 = [];
  List<TextEditingController> edt_aling2 = [];
  List<TextEditingController> edt_aling3 = [];
  List<TextEditingController> edt_text1 = [];
  List<TextEditingController> edt_text2 = [];
  List<TextEditingController> edt_text3 = [];

  String text = "Texto";
  String num = "1";
  String alinhamneto = "Esquerda";
  // vetores para chamar json
  List text_vetor = [];
  List<int> weight_vetor = [];
  List aling_vetor = [];
  // variaveis para contar linha
  List row = ['1'];
  int conta_linha = 1;
  int linha = 0;

  @override
  void initState() {
    edt_text1.add(TextEditingController(text: "Texto"));
    edt_text2.add(TextEditingController(text: "Texto"));
    edt_text3.add(TextEditingController(text: "Texto"));

    edt_num1.add(TextEditingController(text: "50"));
    edt_num2.add(TextEditingController(text: "50"));
    edt_num3.add(TextEditingController(text: "50"));

    edt_aling1.add(TextEditingController(text: "Esquerda"));
    edt_aling2.add(TextEditingController(text: "Esquerda"));
    edt_aling3.add(TextEditingController(text: "Esquerda"));

    text_vetor.add("Texto");
    text_vetor.add("Texto");
    text_vetor.add("Texto");
    weight_vetor.add(50);
    weight_vetor.add(50);
    weight_vetor.add(50);
    //super.initState();
  }

  Future<void> teste() async {
    // String local = await TectoySunmiPrintBluetooth.platformVersion;
    String? text =
        await Tectoysunmisdk.initiServiceTecToySunmiSDK().then((value) => null);
    print(text);
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
            SizedBox(
              height: 450,
              child: ListView.builder(
                itemCount: row.length,
                itemBuilder: (BuildContext context, int index) {
                  /*   return Container(
                    child: Center(
                      child: Row(
                        children: [
                          Text("Row" + row[index].toString() + "",
                              style: TextStyle(
                                  color: Constants.gray, fontSize: 20)),
                        ],
                      ),
                    ),
                  ); */
                  return Center(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text("Row" + row[index].toString() + "",
                                style: TextStyle(
                                    color: Constants.gray, fontSize: 16)),
                          ],
                        ),
                        Row(children: [
                          Text("Text",
                              style: TextStyle(
                                  color: Constants.white, fontSize: 14)),
                          SizedBox(
                            width: 29,
                          ),
                          Container(
                            color: Constants.background,
                            height: 50.0,
                            width: 90.0,
                            child: TextField(
                              style: TextStyle(
                                  color: Constants.white, fontSize: 14),
                              controller: edt_text1[index],
                              onTap: () {
                                setState(() {});
                              },
                            ),
                          ),
                          Container(
                            color: Constants.background,
                            height: 50.0,
                            width: 90.0,
                            child: TextField(
                              style: TextStyle(
                                  color: Constants.white, fontSize: 14),
                              controller: edt_text2[index],
                              onTap: () {
                                setState(() {});
                              },
                            ),
                          ),
                          Container(
                            color: Constants.background,
                            height: 50.0,
                            width: 90.0,
                            child: TextField(
                              style: TextStyle(
                                  color: Constants.white, fontSize: 14),
                              controller: edt_text3[index],
                              onTap: () {
                                setState(() {});
                              },
                            ),
                          ),
                        ]),
                        Row(
                          children: [
                            Text("Weight",
                                style: TextStyle(
                                    color: Constants.white, fontSize: 14)),
                            SizedBox(
                              width: 7,
                            ),
                            Container(
                              color: Constants.background,
                              height: 50.0,
                              width: 90.0,
                              child: TextField(
                                style: TextStyle(
                                    color: Constants.white, fontSize: 14),
                                controller: edt_num1[index],
                                onTap: () {
                                  setState(() {});
                                  weight_vetor.add(100);
                                },
                              ),
                            ),
                            Container(
                              color: Constants.background,
                              height: 50.0,
                              width: 90.0,
                              child: TextField(
                                style: TextStyle(
                                    color: Constants.white, fontSize: 14),
                                controller: edt_num2[index],
                                onTap: () {
                                  setState(() {});
                                  weight_vetor.add(50);
                                },
                              ),
                            ),
                            Container(
                              color: Constants.background,
                              height: 50.0,
                              width: 90.0,
                              child: TextField(
                                style: TextStyle(
                                    color: Constants.white, fontSize: 14),
                                controller: edt_num3[index],
                                onTap: () {
                                  setState(() {});
                                  weight_vetor.add(50);
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text("Aling",
                                style: TextStyle(
                                    color: Constants.white, fontSize: 14)),
                            SizedBox(
                              width: 26,
                            ),
                            Container(
                              color: Constants.background,
                              height: 50.0,
                              width: 90.0,
                              child: Column(
                                children: <Widget>[
                                  DropdownButton<String>(
                                      items: _alinhamento
                                          .map((String dropDownStringItem) {
                                        return DropdownMenuItem<String>(
                                          value: dropDownStringItem,
                                          child: Text(dropDownStringItem,
                                              style: TextStyle(
                                                  color: Constants.red,
                                                  fontSize: 14)),
                                        );
                                      }).toList(),
                                      onChanged: (String? novoItemSelecionado) {
                                        _dropDownItemSelected(
                                            novoItemSelecionado.toString());
                                        setState(() {
                                          _itemSelecionado =
                                              novoItemSelecionado.toString();
                                          aling_vetor.add(_itemSelecionado);
                                        });
                                      },
                                      value: _itemSelecionado),
                                ],
                              ),
                            ),
                            Container(
                              color: Constants.background,
                              height: 50.0,
                              width: 90.0,
                              child: Column(
                                children: <Widget>[
                                  DropdownButton<String>(
                                      items: _alinhamento
                                          .map((String dropDownStringItem) {
                                        return DropdownMenuItem<String>(
                                          value: dropDownStringItem,
                                          child: Text(dropDownStringItem,
                                              style: TextStyle(
                                                  color: Constants.red,
                                                  fontSize: 14)),
                                        );
                                      }).toList(),
                                      onChanged: (String? novoItemSelecionado) {
                                        _dropDownItemSelected(
                                            novoItemSelecionado.toString());
                                        setState(() {
                                          _itemSelecionado =
                                              novoItemSelecionado.toString();
                                          aling_vetor.add(_itemSelecionado);
                                        });
                                      },
                                      value: _itemSelecionado),
                                ],
                              ),
                            ),
                            Container(
                              color: Constants.background,
                              height: 50.0,
                              width: 90.0,
                              child: Column(
                                children: <Widget>[
                                  DropdownButton<String>(
                                      items: _alinhamento
                                          .map((String dropDownStringItem) {
                                        return DropdownMenuItem<String>(
                                          value: dropDownStringItem,
                                          child: Text(dropDownStringItem,
                                              style: TextStyle(
                                                  color: Constants.red,
                                                  fontSize: 14)),
                                        );
                                      }).toList(),
                                      onChanged: (String? novoItemSelecionado) {
                                        _dropDownItemSelected(
                                            novoItemSelecionado.toString());
                                        setState(() {
                                          _itemSelecionado =
                                              novoItemSelecionado.toString();
                                          aling_vetor.add(_itemSelecionado);
                                        });
                                      },
                                      value: _itemSelecionado),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              color: Constants.white,
              height: 50.0,
              width: 1000.0,
              child: TextButton(
                  child: const Text("Adicionar"),
                  style: TextButton.styleFrom(primary: Constants.black),
                  onPressed: () {
                    print("Adicionar");
                    setState(() {
                      conta_linha += 1;
                      linha += 1;
                      row.add(conta_linha);
                      /*      edt_text1.add(TextEditingController(text: "Texto"));
                      edt_text2.add(TextEditingController(text: "Texto"));
                      edt_text3.add(TextEditingController(text: "Texto"));
                      edt_num1.add(TextEditingController(text: "50"));
                      edt_num2.add(TextEditingController(text: "50"));
                      edt_num3.add(TextEditingController(text: "50"));
                      edt_aling1.add(TextEditingController(text: "Esquerda"));
                      edt_aling2.add(TextEditingController(text: "Esquerda"));
                      edt_aling3.add(TextEditingController(text: "Esquerda")); */
                      /*  text_vetor.add("Texto");
                      text_vetor.add("Texto1");
                      text_vetor.add("Texto2");
                      weight_vetor.add(50);
                      weight_vetor.add(50);
                      weight_vetor.add(50); */
                      initState();
                    });
                  }),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              color: Constants.red,
              height: 50.0,
              width: 1000.0,
              child: TextButton(
                  child: const Text("Imprimir"),
                  style: TextButton.styleFrom(primary: Constants.white),
                  onPressed: () {
                    print("Imprimir");

                    print(text_vetor);
                    print(weight_vetor);
                    tabela();
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> tabela() async {
    String json = '{"lines": [';
    int d = 0;
    for (int i = 0; d < text_vetor.length / 3; i++) {
      int c = i;
      json += '{"txts": ["' +
          text_vetor[c] +
          '","' +
          text_vetor[c + 1] +
          '","' +
          text_vetor[c + 2] +
          '"],"width": [' +
          weight_vetor[c].toString() +
          ',' +
          weight_vetor[c + 1].toString() +
          ',' +
          weight_vetor[c + 2].toString() +
          '],"align": [0,1,2]},';
      i += 2;
      d++;
    }
    json += ']}';

    Tectoysunmisdk.printTable(json);
    Tectoysunmisdk.print3Line();
  }

  void _dropDownItemSelected(String novoItem) {
    setState(() {
      this._itemSelecionado = novoItem;
    });
  }
}
