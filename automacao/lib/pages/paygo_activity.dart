import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tectoyexemplo/Utils/constants.dart';
import 'package:tectoyexemplo/Widgets/appbar.dart';
import 'package:tectoyexemplo/Widgets/item.dart';
import 'package:tectoyexemplo/plugin/paygosdk.dart';

class Paygo_activity extends StatefulWidget {
  final String title;

  const Paygo_activity({Key? key, required this.title}) : super(key: key);

  @override
  _Paygo_activityState createState() => _Paygo_activityState();
}

Paygosdk paygo = new Paygosdk();

class _Paygo_activityState extends State<Paygo_activity> {
  String valoroperacao = "";
  String tipo_pagamento = "";
  String adquirentes = "";
  String tipo_parcelamento = "";
  String n_parcelas = "";
  bool confirmacao_manual = false;
  bool via_completa = false;
  bool via_loja = false;
  bool interface = false;
  String nsuRetornado = "";
  String codigoAutorizacaoRetornado = "";
  String dataOperacaoRetornado = "";
  String valorOperacaoRetornado = "0.00";
  @override
  void initState() {
    this.n_parcelas = "0";
    this.adquirentes = "REDE";
    this.valoroperacao = "";
    this.tipo_pagamento = "";
    this.tipo_parcelamento = "";
    this.confirmacao_manual = false;
    this.via_completa = false;
    this.via_loja = false;
    this.interface = false;

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
                    text_menu: "Adquirentes",
                    text_menu_cor: Constants.white,
                    text_menu_size: 20,
                    text_opcao: this.adquirentes,
                    text_opcao_cor: Constants.gray,
                    text_opcao_size: 15,
                    icon: Icons.arrow_forward_ios_sharp,
                    icon_cor: Constants.white,
                    icon_size: 30,
                    onTap: () {
                      print("Aqui");
                      List lista = ['DEMO', 'REDE'];
                      _displayListInputDialog("Adquirentes", "Adquirentes",
                          lista, context, "adquirentes");
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
                                value: confirmacao_manual,
                                onChanged: (value) {
                                  setState(() {
                                    // _checkbox = !_checkbox;
                                    confirmacao_manual = !confirmacao_manual;
                                  });
                                },
                              ),
                              Text(
                                'Confirmação Manual',
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
                                value: via_completa,
                                onChanged: (value) {
                                  setState(() {
                                    // _checkbox = !_checkbox;
                                    via_completa = !via_completa;
                                  });
                                },
                              ),
                              Text(
                                'Via Completa',
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
                                value: interface,
                                onChanged: (value) {
                                  setState(() {
                                    // _checkbox = !_checkbox;
                                    interface = !interface;
                                  });
                                },
                              ),
                              Text(
                                'Interface Alternativa',
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
                                value: via_loja,
                                onChanged: (value) {
                                  setState(() {
                                    // _checkbox = !_checkbox;
                                    via_loja = !via_loja;
                                  });
                                },
                              ),
                              Text(
                                'Via Loja e Cliente',
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
                        operacao(Paygosdk.VENDA);
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
                      child: const Text("Administrativo"),
                      style: TextButton.styleFrom(primary: Constants.white),
                      onPressed: () {
                        print("Imprimir");
                        operacao(Paygosdk.ADMINISTRATIVA);
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
                        operacao(Paygosdk.CANCELAMENTO);
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
                  adquirentes = _textFieldController.text;
                }
              });
            },
            controller: _textFieldController,
            decoration: InputDecoration(hintText: hintText),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                textStyle: TextStyle(color: Colors.white),
              ),
              child: Text('CANCEL'),
              onPressed: () {
                setState(() {
                  valoroperacao = oldValue;
                  Navigator.pop(context);
                });
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                textStyle: TextStyle(color: Colors.white),
              ),
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
                  } else if (variavel == "adquirentes") {
                    adquirentes = oldText[_id];
                  }
                  Navigator.pop(context);
                },
              );
            },
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                textStyle: TextStyle(color: Colors.white),
              ),
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
        modadelidaPagamento = Paygosdk.PAGAMENTO_CARTAO;
        tipoCartao = Paygosdk.CARTAO_DESCONHECIDO;
        break;
      case 'Crédito':
        modadelidaPagamento = Paygosdk.PAGAMENTO_CARTAO;
        tipoCartao = Paygosdk.CARTAO_CREDITO;
        break;

      case 'Débito':
        modadelidaPagamento = Paygosdk.PAGAMENTO_CARTAO;
        tipoCartao = Paygosdk.CARTAO_DEBITO;
        break;
      default:
        modadelidaPagamento = Paygosdk.PAGAMENTO_CARTAO;
        tipoCartao = Paygosdk.CARTAO_DEBITO;
        break;
    }
    switch (tipo_parcelamento) {
      case 'Não Definido':
        tipoFinanciamento = Paygosdk.FINANCIAMENTO_NAO_DEFINIDO;
        break;
      case 'A vista':
        tipoFinanciamento = Paygosdk.A_VISTA;
        break;
      case 'Emissor':
        tipoFinanciamento = Paygosdk.PARCELADO_EMISSOR;
        break;
      default:
        tipoFinanciamento = Paygosdk.A_VISTA;
        break;
    }

    Paygosdk.efetuaOperacao(
      numeroOperacao: new Random().nextInt(9999999).toString(),
      empresaAutomacao: 'Tectoy Automação',
      nomeAutomacao: 'Automação Demo',
      versaoAutomacao: '1.0.0',
      operacao: op,
      modalidadePagamento: modadelidaPagamento,
      tipoCartao: tipoCartao,
      tipoFinanciamento: tipoFinanciamento,
      valorOperacao: valorOperacao,
      parcelas: n_parcelas,
      adquirente:
          adquirentes == 'DESCONHECIDO' ? 'PROVEDOR DESCONHECIDO' : adquirentes,
      nsu: nsuRetornado,
      codigoAutorizacao: codigoAutorizacaoRetornado,
      dataOperacao: dataOperacaoRetornado,
      confirmacaoManual: confirmacao_manual,
      viaLojaCliente: via_loja,
      viaCompleta: via_completa,
      interfaceAlternativa: interface,
      suportaTroco: true,
      suportaDesconto: true,
      // fileIconDestino: File('assets/cash_payment.png').path,
      // fileFonteDestino: File('assets/vectra.otf').path,
      informaCorFonte: '#000000',
      informaCorFonteTeclado: '#000000',
      informaCorFundoCaixaEdicao: '#FFFFFF',
      informaCorFundoTela: '#F4F4F4',
      informaCorFundoTeclado: '#F4F4F4',
      informaCorFundoToolbar: '#2F67F4',
      informaCorTextoCaixaEdicao: '#000000',
      informaCorTeclaPressionadaTeclado: '#e1e1e1',
      informaCorTeclaLiberadaTeclado: '#dedede',
      informaCorSeparadorMenu: '#2F67F4',
    ).then((value) async {
      print('Sucesso: ' + value);
      bool result = true;
      paygo = new Paygosdk.fromJson(json.decode(value.toString()));

      if (paygo.result == 0) {
        if (paygo.informacaoConfirmacao) {
          // Apresentar Dialog para confirmar a operação
          if (confirmacao_manual) {
            result = await dialogConfirmaOperacao();
          } else {
            Paygosdk.confirmaOperacaoAutomatico();
          }
        } else if (paygo.existeTransacaoPendente) {
          valorOperacaoRetornado = valoroperacao;
          nsuRetornado = paygo.nsu;
          codigoAutorizacaoRetornado = paygo.codigoAutorizacao;
          dataOperacaoRetornado = paygo.dataOperacao;
        } else {
          // Faz a confirmação sem perguntar nada.
          print('Foi retornado um valor que não precisa validar.');
        }

        if (result) {
          valorOperacaoRetornado = valoroperacao;
          nsuRetornado = paygo.nsu;
          codigoAutorizacaoRetornado = paygo.codigoAutorizacao;
          dataOperacaoRetornado = paygo.dataOperacao;

          if (via_completa) {
            result = await dialogPrintComprovante(
                'Comprovante Full', paygo.viaCupomFull);
          }
          if (via_loja) {
            result = await dialogPrintComprovante(
                'Via do Estabelecimento', paygo.viaEstavelecimento);
            result = await dialogPrintComprovante(
                'Via do Cliente', paygo.viaCliente);
          }

          if (op == Paygosdk.VENDA || op == Paygosdk.CANCELAMENTO) {
            dialogDadosOperacao();
          }
        }

        // Existe uma operação pendente de confirmação.
      } else if (paygo.existeTransacaoPendente) {
        // Se chegar nesse ponto aconteceu um erro durante a operação
        print('Nesse ponto existe uma operação pendente.');
        await dialogExisteTransacoesPendente();
      } else {
        print('Nesse ponto que dizer que aconteceu um erro.');
        dialogErroOperacao();
        return;
      }
    }).onError((error, stackTrace) {
      print('Erro: ' + error.toString());
    });
  }

// Dialogos
  Future<bool> dialogConfirmaOperacao() {
    return showDialog(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height - 100,
          child: AlertDialog(
            title: Text("Confirmação manual"),
            actions: [
              ElevatedButton(
                child: Text("Confirme"),
                onPressed: () {
                  Paygosdk.confirmaOperacaoManual();
                  Navigator.of(context).pop(true);
                },
              ),
              ElevatedButton(
                child: Text("Cancelar"),
                onPressed: () {
                  Paygosdk.desfazOperacaoManual();
                  Navigator.of(context).pop(false);
                },
              ),
            ],
            content: Container(
              height: 150,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Deseja confirmar a operação de forma manual?'),
                ],
              ),
            ),
          ),
        );
      },
      //Your Dialog Code
    ).then((val) {
      print('Confirmado Operação $val');
      return val;
    });
  }

  void dialogDadosOperacao() {
    showDialog(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height - 20,
          child: AlertDialog(
            title: Text(paygo.mensagemRetorno),
            actions: [
              ElevatedButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
            content: ListView(
              scrollDirection: Axis.vertical,
              children: [
                Text('ID do Cartão: ${paygo.idcartao}'),
                Text('Nome Portador Cartao: ${paygo.nomePortadorCartao}'),
                Text('Nome Cartao Padrao: ${paygo.nomeCartaoPadrao}'),
                Text('Nome Estabelecimento: ${paygo.nomeEstabelecimento}'),
                Text('Pan Mascar Padrao: ${paygo.panMascarPadrao}'),
                Text('Pan Mascarado: ${paygo.panMascarado}'),
                Text(
                    'Identificador Confirmação Transação: ${paygo.identificadorConfirmacaoTransacao}'),
                Text('Nsu Local Original: ${paygo.nsuLocalOriginal}'),
                Text('Nsu Local: ${paygo.nsuLocal}'),
                Text('Nsu Host: ${paygo.nsuHost}'),
                Text('Nome Cartao: ${paygo.nomeCartao}'),
                Text('Nome Provedor: ${paygo.nomeProvedor}'),
                Text('Modo Verificação Senha: ${paygo.modoVerificacaoSenha}'),
                Text('Codigo Autorização: ${paygo.codigoAutorizacao}'),
                Text(
                    'Codigo Autorização Original: ${paygo.codigoAutorizacaoOriginal}'),
                Text('Ponto Captura: ${paygo.pontoCaptura}'),
                Text('Valor Operacao: ${paygo.valorOperacao}'),
                Text('Saldo Voucher: ${paygo.saldoVoucher}'),
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
              ElevatedButton(
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
                  Text('Erro: ' + paygo.result.toString()),
                  Text('Mensagem: ' + paygo.mensagemRetorno),
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
              ElevatedButton(
                child: Text("Sim"),
                onPressed: () async {
                  print('Clicou na impressão do comprovante');
                  await imprimeCupom(comprovante);
                  Navigator.of(context).pop(true);
                },
              ),
              ElevatedButton(
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

  Future<bool> dialogExisteTransacoesPendente() {
    return showDialog(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height - 100,
          child: AlertDialog(
            title: Text("Transação Pendente"),
            actions: [
              ElevatedButton(
                child: Text("Confirme"),
                onPressed: () {
                  Paygosdk.confirmaOperacaoPendenteManual();
                  // Navigator.pop(context);
                  Navigator.of(context).pop(true);
                },
              ),
              ElevatedButton(
                child: Text("Cancelar"),
                onPressed: () {
                  Paygosdk.desfazOperacaoPendente();
                  Navigator.of(context).pop(false);
                },
              ),
            ],
            content: Container(
              height: 150,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Deseja confirmar a transação que esta PENDENTE?'),
                ],
              ),
            ),
          ),
        );
      },
      //Your Dialog Code
    ).then((val) {
      print('Dialog Transação Pendente');
      return val;
    });
  }

  // Impressão Cupom
  Future<void> imprimeCupom(String cupom) async {}
}
