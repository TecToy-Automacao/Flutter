//import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tectoyexemplo/Utils/constants.dart';
import 'package:tectoyexemplo/Widgets/appbar.dart';
import 'package:tectoyexemplo/Widgets/item.dart';
import 'package:tectoyexemplo/plugin/scannersdk.dart';

class Scannerp2 extends StatefulWidget {
  final String title;

  const Scannerp2({Key? key, required this.title}) : super(key: key);

  @override
  _Scannerp2State createState() => _Scannerp2State();
}

class _Scannerp2State extends State<Scannerp2> {
  String character = "";
  String prompt = "";
  String scan_mode = "";
  String scan_trigger = "";

  @override
  void initState() {
    this.character = "UTF-8";
    this.prompt = "BEEP+VIBRATE";
    this.scan_mode = "TRIGGER MODE";
    this.scan_trigger = "NONE";
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
                  text_menu: "Character Set Selection",
                  text_menu_cor: Constants.white,
                  text_menu_size: 20,
                  text_opcao: this.character,
                  text_opcao_cor: Constants.gray,
                  text_opcao_size: 15,
                  icon: Icons.arrow_forward_ios_sharp,
                  icon_cor: Constants.white,
                  icon_size: 30,
                  onTap: () {
                    print("Aqui");
                    setState(() {});
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                ItemMenu(
                    text_menu: "Prompt Mode",
                    text_menu_cor: Constants.white,
                    text_menu_size: 20,
                    text_opcao: this.prompt,
                    text_opcao_cor: Constants.gray,
                    text_opcao_size: 15,
                    icon: Icons.arrow_forward_ios_sharp,
                    icon_cor: Constants.white,
                    icon_size: 30,
                    onTap: () {
                      print("Aqui");
                    }),
                SizedBox(
                  height: 20,
                ),
                ItemMenu(
                  text_menu: "Scan Mode",
                  text_menu_cor: Constants.white,
                  text_menu_size: 20,
                  text_opcao: this.scan_mode,
                  text_opcao_cor: Constants.gray,
                  text_opcao_size: 15,
                  icon: Icons.arrow_forward_ios_sharp,
                  icon_cor: Constants.white,
                  icon_size: 30,
                  onTap: () {
                    print("Aqui");
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                ItemMenu(
                  text_menu: "Scan Trigger",
                  text_menu_cor: Constants.white,
                  text_menu_size: 20,
                  text_opcao: this.scan_trigger,
                  text_opcao_cor: Constants.gray,
                  text_opcao_size: 15,
                  icon: Icons.arrow_forward_ios_sharp,
                  icon_cor: Constants.white,
                  icon_size: 30,
                  onTap: () {
                    print("Aqui");
                  },
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Container(
              color: Constants.red,
              height: 50.0,
              width: 1000.0,
              child: TextButton(
                  child: const Text("Scanner"),
                  style: TextButton.styleFrom(primary: Constants.white),
                  onPressed: () {
                    Scannersdk.init();
                    Scannersdk.scan();
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
