import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:exemplo_esl/services/api_service.dart';
import 'package:exemplo_esl/classes/ap_class.dart';

class ApCard extends StatefulWidget {
  final Ap ap;
  final int shopId;
  final VoidCallback getAps;
  const ApCard({
    super.key,
    required this.ap,
    required this.shopId,
    required this.getAps,
  });

  @override
  State<ApCard> createState() => _ApCardState();
}

class _ApCardState extends State<ApCard> {
  final ApiService api = ApiService();
  var apInfo = {};
  bool finished = false;
  bool gotInfo = false;

  final nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 210,
      height: 300,
      child: Card(
        elevation: 10,
        color: Colors.amberAccent,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: finished
              ? Visibility(
                  visible: gotInfo,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 65,
                        child: Align(
                          child: Text(
                            widget.ap.name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        'ID: ${widget.ap.id}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        'Status: ${translateStatus(apInfo['status'])}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            onPressed: showReboot,
                            icon: const Icon(
                              Icons.restart_alt,
                              color: Colors.purple,
                              size: 40,
                            ),
                          ),
                          IconButton(
                            onPressed: showEdit,
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.green,
                              size: 40,
                            ),
                          ),
                          IconButton(
                            onPressed: showUnbind,
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 40,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              : const Align(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                ),
        ),
      ),
    );
  }

  void getInfo() async {
    setState(() {
      finished = false;
      gotInfo = false;
    });

    http.Response response = await api.apGetInfo(widget.shopId, widget.ap.id);

    if (response.statusCode == 200) {
      var object = jsonDecode(response.body);
      if (mounted) {
        setState(() {
          apInfo = object['data'];
          finished = true;
          gotInfo = true;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          finished = true;
        });
      }
      if (context.mounted) {
        api.requestError(context, response);
      }
    }
  }

  String translateStatus(status) {
    String statusAp = "";
    status == 0
        ? statusAp = "Não ativado"
        : status == 1
            ? statusAp = "Online"
            : status == 2
                ? statusAp = "Offline"
                : "Desconhecido";
    return statusAp;
  }

  //Reiniciar ap
  void showReboot() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Reiniciar AP",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            width: 500,
            height: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text.rich(
                  TextSpan(
                    text: "Deseja mesmo reiniciar o AP ",
                    style: const TextStyle(fontSize: 18),
                    children: [
                      TextSpan(
                        text: '${widget.ap.name}?',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                const Text(
                  "Esta ação fará com que ele fique offline por um tempo.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
              ),
              child: const Text(
                "Cancelar",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                reboot();
              },
              child: const Text(
                "Reiniciar",
                style: TextStyle(
                  color: Colors.green,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void reboot() async {
    http.Response response = await api.apReboot(widget.shopId, widget.ap.id);

    if (response.statusCode == 200) {
      if (context.mounted) {
        api.requestSuccess(context, "AP reiniciado com sucesso!");
      }
      widget.getAps();
    } else {
      if (context.mounted) {
        api.requestError(context, response);
      }
    }
  }

  //Editar ap
  void showEdit() {
    showDialog(
      context: context,
      builder: (context) => ScaffoldMessenger(
        child: Builder(
          builder: (context) => Scaffold(
            backgroundColor: Colors.transparent,
            body: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Navigator.of(context).pop();
              },
              child: GestureDetector(
                onTap: () {},
                child: AlertDialog(
                  title: Text(
                    'Editar AP ${widget.ap.name}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: SizedBox(
                    width: 500,
                    height: 100,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Nome",
                              labelStyle: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        nameController.clear();
                      },
                      child: const Text("Cancelar"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (nameController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Insira um novo nome para o AP",
                                style: TextStyle(fontSize: 20),
                                textAlign: TextAlign.center,
                              ),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        } else {
                          FocusScopeNode currentFocus = FocusScope.of(context);
                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }
                          Navigator.of(context).pop();
                          edit();
                        }
                      },
                      child: const Text("Salvar"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void edit() async {
    http.Response response =
        await api.apUpdate(widget.shopId, nameController.text, widget.ap.id);

    if (response.statusCode == 200) {
      if (context.mounted) {
        api.requestSuccess(context, "AP atualizado com sucesso!");
      }
      widget.getAps();
    } else {
      if (context.mounted) {
        api.requestError(context, response);
      }
    }
  }

  //Desvincular ap
  void showUnbind() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'ATENÇÃO',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            width: 500,
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text.rich(
                  TextSpan(
                    text: "Você está prestes a desvincular o AP ",
                    style: const TextStyle(fontSize: 18),
                    children: [
                      TextSpan(
                        text: '${widget.ap.name}.',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                const Text(
                  'Se essa ação for realizada ela não poderá ser desfeita.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 15),
                const Text(
                  'Deseja continuar?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
              ),
              child: const Text(
                "Cancelar",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                unbind();
              },
              child: const Text(
                "Continuar",
                style: TextStyle(
                  color: Colors.green,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void unbind() async {
    http.Response response = await api.apUnbind(widget.shopId, widget.ap.id);

    if (response.statusCode == 200) {
      if (context.mounted) {
        api.requestSuccess(context, "AP desvinculado com sucesso!");
      }
      widget.getAps();
    } else {
      if (context.mounted) {
        api.requestError(context, response);
      }
    }
  }
}
