import 'package:flutter/material.dart';
import 'package:tectoyexemplo/Utils/constants.dart';
import 'package:tectoyexemplo/plugin/tectoysunmisdk.dart';

class Item extends StatelessWidget {
  final String name;
  final String img;
  final Widget page;

  Item({required this.name, required this.img, required this.page});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(border: Border.all(width: 1, color: Constants.gray)),
      child: InkWell(
        child: ListView(
          shrinkWrap: true,
          primary: false,
          children: <Widget>[
            Center(
              child: Column(
                children: [
                  Stack(
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height / 5,
                        width: MediaQuery.of(context).size.width / 2.5,
                        alignment: Alignment.center,
                        child: ClipRRect(
                          child: Image.asset(
                            "$img",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: .5, top: 1),
                    child: Text(
                      "$name",
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.normal,
                        color: Constants.text,
                      ),
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        onTap: () {
          // Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (BuildContext context) {
          //       return page;
          //     },
          //   ),
          // );
          // print(name);
          // Tectoysunmisdk.printFullFunctions;
          menu(name, page, context);
        },
      ),
    );
  }

  void menu(String op, Widget page, BuildContext context) {
    print(op);
    if (op == "Teste Completo") {
      Tectoysunmisdk.printFullFunctions;
    } else if (op == "Gaveta") {
      Tectoysunmisdk.openCashBox();
    } else if (op == "Avança Papel") {
      Tectoysunmisdk.print3Line();
    } else if (op == "Cortar Papel") {
      Tectoysunmisdk.cutpaper();
    } else if (op == "Status") {
      Tectoysunmisdk.showPrinterStatus();
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) {
            return page;
          },
        ),
      );
    }
  }
}
