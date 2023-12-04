import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';

import 'package:exemplo_esl/classes/template_class.dart';
import 'package:exemplo_esl/services/api_service.dart';

class TemplateCard extends StatefulWidget {
  final Template template;
  final int shopId;
  final VoidCallback getTemplates;

  const TemplateCard({
    super.key,
    required this.template,
    required this.shopId,
    required this.getTemplates,
  });

  @override
  State<TemplateCard> createState() => _TemplateCardState();
}

class _TemplateCardState extends State<TemplateCard> {
  final ApiService api = ApiService();
  var templateInfo = {};
  bool finished = false;
  bool gotInfo = false;

  final nameController = TextEditingController();
  String jsonFileContent = "";

  @override
  void initState() {
    getInfo();
    super.initState();
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
      height: 450,
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
                            widget.template.name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        'ID: ${widget.template.id}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        'Cor: ${translateColor(templateInfo['template_color_name'])}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        'Tela: ${translateScreen(templateInfo['template_screen_type_name'])}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            onPressed: showEditTemplate,
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.green,
                              size: 40,
                            ),
                          ),
                          IconButton(
                            onPressed: showDeleteTemplate,
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

  Future<void> chooseJsonFile(BuildContext ctxt) async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null) {
      final File file = File(result.files.single.path!);
      if (result.files.single.name
              .substring(result.files.single.name.length - 5) !=
          ".json") {
        if (ctxt.mounted) {
          ScaffoldMessenger.of(ctxt).showSnackBar(
            const SnackBar(
              content: Text(
                "Escolha um arquivo JSON",
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      } else {
        final jsonString = await file.readAsString();
        setState(() {
          nameController.text = result.files.single.name;
          jsonFileContent = jsonString;
        });
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Não foi possível ler o arquivo json",
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  void getInfo() async {
    setState(() {
      finished = false;
      gotInfo = false;
    });

    http.Response response =
        await api.templateGetInfo(widget.shopId, widget.template.id);

    if (response.statusCode == 200) {
      var object = jsonDecode(response.body);
      var newObject = {
        "template_name": object['data']['template_name'],
        "template_color_name": object['data']['template_color_name'],
        "template_screen_type_name": object['data']
            ['template_screen_type_name'],
      };
      if (mounted) {
        setState(() {
          templateInfo = newObject;
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

  String translateColor(String color) {
    if (color.substring(20).length == 2) {
      return "Preto e Branco";
    } else {
      return "Preto, Branco e Vermelho";
    }
  }

  String translateScreen(String screen) {
    String size = '${screen.substring(11)} polegadas';
    return size;
  }

  //Editar template
  void showEditTemplate() {
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
                    'Editar template ${widget.template.name}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: SizedBox(
                    width: 500,
                    height: 130,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          TextFormField(
                            enabled: false,
                            controller: nameController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Arquivo JSON",
                              labelStyle: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              chooseJsonFile(context);
                            },
                            child: const Text("Escolher arquivo"),
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
                                "Escolha um arquivo JSON",
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
                          editTemplate();
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

  void editTemplate() async {
    http.Response response = await api.templateUpdate(
      widget.shopId,
      widget.template.id,
      jsonFileContent,
    );

    if (response.statusCode == 200) {
      setState(() {
        jsonFileContent = "";
        nameController.clear();
      });
      if (context.mounted) {
        api.requestSuccess(context, "Template atualizado com sucesso!");
      }
    } else {
      if (context.mounted) {
        api.requestError(context, response);
      }
    }
  }

  //Deletar template
  void showDeleteTemplate() {
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
                    text: "Você está prestes a deletar o template ",
                    style: const TextStyle(fontSize: 18),
                    children: [
                      TextSpan(
                        text: '${widget.template.name}.',
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
                deleteTemplate();
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

  void deleteTemplate() async {
    http.Response response =
        await api.templateDelete(widget.shopId, widget.template.id);

    if (response.statusCode == 200) {
      if (context.mounted) {
        api.requestSuccess(context, "Template deletado com sucesso!");
      }
      widget.getTemplates();
    } else {
      if (context.mounted) {
        api.requestError(context, response);
      }
    }
  }
}
