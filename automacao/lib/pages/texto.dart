import 'package:flutter/material.dart';
import 'package:tectoyexemplo/Utils/constants.dart';
import 'package:tectoyexemplo/Widgets/appbar.dart';
import 'package:tectoyexemplo/Widgets/item.dart';
import 'package:tectoyexemplo/plugin/tectoysunmisdk.dart';

class Texto extends StatefulWidget {
  final String title;

  const Texto({Key? key, required this.title}) : super(key: key);

  @override
  _TextoState createState() => _TextoState();
}

class _TextoState extends State<Texto> {
  TextEditingController textController = TextEditingController();

  String text_texto = "";
  String texto_typeface = "";
  String texto_charset = "";
  String texto_tamanho = "";
  bool texto_bold = false;
  bool texto_underline = false;

  @override
  void initState() {
    // TODO: implement initState

    this.textController = TextEditingController(
      text:
          "欢迎光临(Simplified Chinese)\n歡迎光臨（traditional chinese）\nWelcome(English)\n어서 오세요.(Korean)\nいらっしゃいませ(Japanese)\nWillkommen in der(Germany)\nSouhaits de bienvenue(France)\nยินดีต้อนรับสู่(Thai)\nДобро пожаловать(Russian)\nBenvenuti a(Italian)\nvítejte v(Czech)\nBEM - vindo Ao Brasil(Portutuese)\nمرحبا بكم في(Arabic)",
    );

    this.texto_typeface = "Type monospace";
    this.texto_charset = "GB18030";
    this.texto_tamanho = "24";
    this.texto_bold = false;
    this.texto_bold = false;
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
                /*   ItemMenu(
                  text_menu: "Text typeface",
                  text_menu_cor: Constants.white,
                  text_menu_size: 20,
                  text_opcao: this.texto_typeface,
                  text_opcao_cor: Constants.gray,
                  text_opcao_size: 15,
                  icon: Icons.arrow_forward_ios_sharp,
                  icon_cor: Constants.white,
                  icon_size: 30,
                  onTap: () {
                    print("Aqui");
                  },
                ), */
                SizedBox(
                  height: 20,
                ),
                /* ItemMenu(
                  text_menu: "Char set",
                  text_menu_cor: Constants.white,
                  text_menu_size: 20,
                  text_opcao: this.texto_charset,
                  text_opcao_cor: Constants.gray,
                  text_opcao_size: 15,
                  icon: Icons.arrow_forward_ios_sharp,
                  icon_cor: Constants.white,
                  icon_size: 30,
                  onTap: () {
                    print("Aqui");
                    List texto_text = ['CP437', 'CP850', 'CP860', 'CP863'];
                    _displayListInputDialog("Char Set", texto_charset,
                        texto_text, context, "texto_charset");
                  },
                ), */
                SizedBox(
                  height: 20,
                ),
                ItemMenu(
                  text_menu: "Tamanho impressão",
                  text_menu_cor: Constants.white,
                  text_menu_size: 20,
                  text_opcao: this.texto_tamanho,
                  text_opcao_cor: Constants.gray,
                  text_opcao_size: 15,
                  icon: Icons.arrow_forward_ios_sharp,
                  icon_cor: Constants.white,
                  icon_size: 30,
                  onTap: () {
                    print("Aqui");
                    var lista = new List<String>.generate(40, (i) => "$i");
                    _displayListInputDialog("Tamanho", texto_tamanho, lista,
                        context, "texto_tamanho");
                  },
                ),
                SizedBox(
                  height: 15,
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
                                value: texto_bold,
                                onChanged: (value) {
                                  setState(() {
                                    // _checkbox = !_checkbox;
                                    texto_bold = !texto_bold;
                                  });
                                },
                              ),
                              Text(
                                'BOLD',
                                style: TextStyle(
                                  color: Constants.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 23,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(
                                value: texto_underline,
                                onChanged: (value) {
                                  setState(() {
                                    // _checkbox = !_checkbox;
                                    texto_underline = !texto_underline;
                                  });
                                },
                              ),
                              Text(
                                'UNDERLINE',
                                style: TextStyle(
                                  color: Constants.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 23,
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
                  color: Constants.white,
                  height: 200.0,
                  child: TextField(
                    controller: textController,
                    maxLines: 10,
                  ),
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
                        print(texto_tamanho);
                        print(texto_charset);
                        print(texto_typeface);
                        print(texto_underline);
                        print(texto_bold);
                        text_texto = textController.toString();
                        printTexto();
                      }),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> printTexto() async {
    Tectoysunmisdk.printTextoCompleto(text_texto, int.parse(texto_tamanho),
        texto_charset, texto_bold, texto_underline);
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
                  if (variavel == "texto_charset") {
                    texto_charset = oldText[_id];
                  } else if (variavel == "texto_tamanho") {
                    texto_tamanho = oldText[_id];
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
}
