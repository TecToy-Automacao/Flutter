//import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:tectoyexemplo/Utils/constants.dart';
import 'package:tectoyexemplo/Utils/funcoes.dart';
import 'package:tectoyexemplo/Widgets/appbar.dart';
import 'package:tectoyexemplo/Widgets/card_item.dart';
import 'package:tectoyexemplo/plugin/lampsdk.dart';
import 'package:tectoyexemplo/plugin/tectoysunmisdk.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Constants.appName,
      theme: ThemeData(
        primaryColor: Constants.background,
        backgroundColor: Constants.background,
      ),
      home: MyHomePage(title: 'TecToy Sunmi Flutter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    teste();
  }

  Future<void> teste() async {
    // String local = await TectoySunmiPrintBluetooth.platformVersion;
    String? text =
        await Tectoysunmisdk.initiServiceTecToySunmiSDK().then((value) => null);
    await Lampsdk.init();
    print(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(Constants.appName, true),
      backgroundColor: Constants.background,
      body: ListView(
        children: [
          GridView.builder(
            shrinkWrap: true,
            primary: false,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: MediaQuery.of(context).size.width /
                  (MediaQuery.of(context).size.height / 1.75),
            ),
            itemCount: funcoes.length,
            itemBuilder: (BuildContext context, int index) {
              Map funcao = funcoes[index];
              return Item(
                img: funcao['img'],
                name: funcao['name'],
                page: funcao['page'],
              );
            },
          ),
        ],
      ),
    );
  }
}
