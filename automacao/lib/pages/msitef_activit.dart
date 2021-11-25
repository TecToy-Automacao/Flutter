import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tectoyexemplo/Utils/constants.dart';
import 'package:tectoyexemplo/Widgets/appbar.dart';
import 'package:tectoyexemplo/Widgets/item.dart';
import 'package:tectoyexemplo/plugin/msitef.dart';

class Msitef_activit extends StatefulWidget {
  final String title;

  const Msitef_activit({Key? key, required this.title}) : super(key: key);

  @override
  _Msitef_activitState createState() => _Msitef_activitState();
}

Msitef msitef = new Msitef();

class _Msitef_activitState extends State<Msitef_activit> {
  String valoroperacao = "";
  String tipo_pagamento = "";
  String tipo_parcelamento = "";
  String n_parcelas = "";
  bool ubs = false;
  bool blu = false;

  String resultRetornado = "";
  String nsuRetornado = "";
  String codigoAutorizacaoRetornado = "";
  String viaEstavelecimentoRetornado = "";
  String viaClienteRetornado = "";

  @override
  void initState() {
    this.n_parcelas = "0";

    this.valoroperacao = "";
    this.tipo_pagamento = "";
    this.tipo_parcelamento = "";

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
                  text_menu: "Valor",
                  text_menu_cor: Constants.white,
                  text_menu_size: 20,
                  text_opcao: this.valoroperacao,
                  text_opcao_cor: Constants.gray,
                  text_opcao_size: 15,
                  icon: Icons.arrow_forward_ios_sharp,
                  icon_cor: Constants.white,
                  icon_size: 30,
                  onTap: () {
                    print("Aqui");
                    setState(() {
                      _displayTextInputDialog("Informe o Valor", "Valor",
                          valoroperacao, context, "valoroperacao");
                    });
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                ItemMenu(
                  text_menu: "Parcelas",
                  text_menu_cor: Constants.white,
                  text_menu_size: 20,
                  text_opcao: this.n_parcelas,
                  text_opcao_cor: Constants.gray,
                  text_opcao_size: 15,
                  icon: Icons.arrow_forward_ios_sharp,
                  icon_cor: Constants.white,
                  icon_size: 30,
                  onTap: () {
                    print("Aqui");
                    setState(() {
                      _displayTextInputDialog("Parcelas", "Parcelas",
                          n_parcelas, context, "n_parcelas");
                    });
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                ItemMenu(
                    text_menu: "Tipo de Pagamento",
                    text_menu_cor: Constants.white,
                    text_menu_size: 20,
                    text_opcao: this.tipo_pagamento,
                    text_opcao_cor: Constants.gray,
                    text_opcao_size: 15,
                    icon: Icons.arrow_forward_ios_sharp,
                    icon_cor: Constants.white,
                    icon_size: 30,
                    onTap: () {
                      print("Aqui");
                      List lista = [
                        'Não Definido',
                        'Crédito',
                        'Debito',
                        'Carteira Digital'
                      ];
                      _displayListInputDialog(
                          "Tipo de Pagamento",
                          "Tipo de Pagamento",
                          lista,
                          context,
                          "tipo_pagamento");
                    }),
                SizedBox(
                  height: 20,
                ),
                ItemMenu(
                    text_menu: "Tipo de Parcelamento",
                    text_menu_cor: Constants.white,
                    text_menu_size: 20,
                    text_opcao: this.tipo_parcelamento,
                    text_opcao_cor: Constants.gray,
                    text_opcao_size: 15,
                    icon: Icons.arrow_forward_ios_sharp,
                    icon_cor: Constants.white,
                    icon_size: 30,
                    onTap: () {
                      print("Aqui");
                      List lista = [
                        'Não Definido',
                        'À Vista',
                        'Emissor',
                        'Estabelecimento'
                      ];
                      _displayListInputDialog(
                          "Tipo de Parcelamento",
                          "Tipo de Parcelemanto",
                          lista,
                          context,
                          "tipo_parcelamento");
                    }),
                SizedBox(
                  height: 20,
                ),
                Container(
                  color: Constants.gray,
                  height: 50.0,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: ubs,
                                onChanged: (value) {
                                  setState(() {
                                    // _checkbox = !_checkbox;
                                    ubs = !ubs;
                                  });
                                },
                              ),
                              Text(
                                'USB',
                                style: TextStyle(
                                  color: Constants.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(
                                value: blu,
                                onChanged: (value) {
                                  setState(() {
                                    // _checkbox = !_checkbox;
                                    blu = !blu;
                                  });
                                },
                              ),
                              Text(
                                'Bluetooth',
                                style: TextStyle(
                                  color: Constants.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  color: Constants.black,
                  height: 50.0,
                  width: 1000.0,
                  child: TextButton(
                      child: const Text("Pagar"),
                      style: TextButton.styleFrom(primary: Constants.white),
                      onPressed: () {
                        print("Imprimir");
                        operacao(Msitef.VENDA);
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
                      child: const Text("Cancelamento"),
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
                if (variavel == "valoroperacao") {
                  valoroperacao = _textFieldController.text;
                } else if (variavel == "n_parcelas") {
                  n_parcelas = _textFieldController.text;
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
                  valoroperacao = oldValue;
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
                  if (variavel == "tipo_pagamento") {
                    tipo_pagamento = oldText[_id];
                  } else if (variavel == "tipo_parcelamento") {
                    tipo_parcelamento = oldText[_id];
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

  Future<void> operacao(String op) async {
    String valorOperacao = valoroperacao;
    String modadelidaPagamento;
    String tipoCartao;
    String tipoFinanciamento = '';
    valorOperacao = valorOperacao.replaceAll('.', "");
    valorOperacao = valorOperacao.replaceAll(',', "");

    switch (tipo_pagamento) {
      case 'Não Definido':
        modadelidaPagamento = "Não Definido";
        break;
      case 'Crédito':
        modadelidaPagamento = "Crédito";

        break;

      case 'Débito':
        modadelidaPagamento = "Débito";

        break;
      default:
        modadelidaPagamento = "Não Definido";

        break;
    }
    switch (tipo_parcelamento) {
      case 'Não Definido':
        tipoFinanciamento = "Não Definido";
        break;
      case 'A vista':
        tipoFinanciamento = "A Vista";
        break;
      case 'Emissor':
        tipoFinanciamento = "Emissor";
        break;
      default:
        tipoFinanciamento = "Não Definido";
        break;
    }

    Msitef.efetuaOperacao(
      modalidade: tipo_pagamento,
      parcelas: n_parcelas,
      usb: false,
      valor: valoroperacao,
    ).then((value) async {
      print('Sucesso: ' + value);
      bool result = true;
      msitef = new Msitef.fromJson(json.decode(value.toString()));
    }).onError((error, stackTrace) {
      print('Erro: ' + error.toString());
    });
  }

  void dialogDadosOperacao() {
    showDialog(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height - 20,
          child: AlertDialog(
            title: Text(msitef.nsu),
            actions: [
              FlatButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
            content: ListView(
              scrollDirection: Axis.vertical,
              children: [
                Text('Nsu Host: ${msitef.nsu}'),
              ],
            ),
          ),
        );
      },
      //Your Dialog Code
    ).then((val) {
      print('Dialog Dados da operação');
    });
  }

  void dialogErroOperacao() {
    showDialog(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height - 100,
          child: AlertDialog(
            title: Text("Erro na Operacao"),
            actions: [
              FlatButton(
                child: Text("OK"),
                onPressed: () {
                  print('Clicou no DialogErro');
                  Navigator.pop(context);
                },
              ),
            ],
            content: Container(
              height: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Erro: ' + msitef.result.toString()),
                ],
              ),
            ),
          ),
        );
      },
      //Your Dialog Code
    ).then((val) {
      print('Dialog Erro de Operação');
    });
  }

  Future<bool> dialogPrintComprovante(String titulo, String comprovante) {
    return showDialog(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height - 100,
          child: AlertDialog(
            title: Text(titulo),
            actions: [
              FlatButton(
                child: Text("Sim"),
                onPressed: () async {
                  print('Clicou na impressão do comprovante');
                  await imprimeCupom(comprovante);
                  Navigator.of(context).pop(true);
                },
              ),
              FlatButton(
                child: Text("Não"),
                onPressed: () {
                  print('Clicou na NÃO impressão do comprovante');
                  Navigator.of(context).pop(false);
                },
              ),
            ],
            content: Container(
              height: 150,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Deseja imprimir $titulo?'),
                ],
              ),
            ),
          ),
        );
      },
      //Your Dialog Code
    ).then((val) {
      print('Dialog Impressão do comprovante fecahdo');
      return val;
    });
  }

  // Impressão Cupom
  Future<void> imprimeCupom(String cupom) async {}
}
