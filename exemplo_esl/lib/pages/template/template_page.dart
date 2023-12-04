import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:number_pagination/number_pagination.dart';

import 'package:exemplo_esl/services/api_service.dart';
import 'package:exemplo_esl/classes/template_class.dart';
import 'package:exemplo_esl/pages/template/template_card_widget.dart';

class TemplatePage extends StatefulWidget {
  final int store;

  const TemplatePage({
    super.key,
    required this.store,
  });

  @override
  State<TemplatePage> createState() => _TemplatePageState();
}

class _TemplatePageState extends State<TemplatePage> {
  ApiService api = ApiService();
  int pageNum = 1;
  int pages = 0;
  var templateList = <Template>[];
  bool finished = false;
  bool gotTemplates = false;

  final nameController = TextEditingController();
  final fileNameController = TextEditingController();
  String jsonFileContent = "";
  int templateColor = 1;
  int templateScreen = 1;

  @override
  void initState() {
    super.initState();
    getTemplates();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    fileNameController.dispose();
  }

  @override
  void didUpdateWidget(covariant TemplatePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      pageNum = 1;
    });
    getTemplates();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return SizedBox(
      height: screenSize.height,
      child: Scrollbar(
        thickness: 10,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text(
                      "Templates cadastrados",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 30),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromARGB(255, 252, 224, 124)),
                      ),
                      onPressed: showCreateTemplate,
                      child: const Icon(Icons.add),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                finished
                    ? Visibility(
                        visible: gotTemplates,
                        child: Column(
                          children: [
                            templateList.isNotEmpty
                                ? Wrap(
                                    spacing: 35,
                                    runSpacing: 35,
                                    children: templateList.map((t) {
                                      return TemplateCard(
                                        template: t,
                                        shopId: widget.store,
                                        getTemplates: getTemplates,
                                      );
                                    }).toList(),
                                  )
                                : const Padding(
                                    padding: EdgeInsets.only(top: 100),
                                    child: Text(
                                      "Não existem templates vinculados nessa filial",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30,
                                      ),
                                    ),
                                  ),
                            const SizedBox(height: 20),
                            Visibility(
                              visible: templateList.isNotEmpty,
                              child: NumberPagination(
                                onPageChanged: (int pageNumber) {
                                  setState(() {
                                    pageNum = pageNumber;
                                  });
                                  getTemplates();
                                },
                                pageTotal: pages,
                                pageInit: pageNum,
                                colorPrimary: Colors.redAccent,
                                colorSub: Colors.amberAccent,
                              ),
                            ),
                          ],
                        ),
                      )
                    : SizedBox(
                        height: screenSize.height * 0.5,
                        child: const Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(),
                        ),
                      ),
              ],
            ),
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
          fileNameController.text = result.files.single.name;
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

  void getTemplates() async {
    setState(() {
      finished = false;
      gotTemplates = false;
    });

    http.Response response = await api.templateGetList(widget.store, pageNum);
    if (response.statusCode == 200) {
      var object = jsonDecode(response.body);
      var array = object['data']['template_list'];
      var templateL = <Template>[];
      array.forEach((t) {
        Template template = Template(
          id: t['template_id'],
          name: t['template_name'],
          screen: t['template_screen'],
        );
        templateL.add(template);
      });
      setState(() {
        templateList = templateL;
        pages = (object['data']['total_count'] / api.pageSize).ceil();
        gotTemplates = true;
        finished = true;
      });
    } else {
      setState(() {
        finished = true;
      });
      if (context.mounted) {
        api.requestError(context, response);
      }
    }
  }

  void showCreateTemplate() {
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
                  title: const Text(
                    'Criar template',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: SizedBox(
                    width: 500,
                    height: 420,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
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
                          const SizedBox(height: 20),
                          DropdownButtonFormField(
                            decoration: InputDecoration(
                                label: const Text("Cor"),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                )),
                            value: templateColor,
                            items: const [
                              DropdownMenuItem(
                                value: 1,
                                child: Text("Preto e Branco"),
                              ),
                              DropdownMenuItem(
                                value: 2,
                                child: Text("Preto, Branco e Vermelho"),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                templateColor = value!;
                              });
                            },
                          ),
                          const SizedBox(height: 20),
                          DropdownButtonFormField(
                            decoration: InputDecoration(
                                label: const Text("Cor"),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                )),
                            value: templateScreen,
                            items: const [
                              DropdownMenuItem(
                                value: 1,
                                child: Text("2.13 polegadas"),
                              ),
                              DropdownMenuItem(
                                value: 2,
                                child: Text("2.6 polegadas"),
                              ),
                              DropdownMenuItem(
                                value: 3,
                                child: Text("4.2 polegadas"),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                templateScreen = value!;
                              });
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            enabled: false,
                            controller: fileNameController,
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
                        fileNameController.clear();
                      },
                      child: const Text("Cancelar"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (nameController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Nome é um campo obrigatório",
                                style: TextStyle(fontSize: 20),
                                textAlign: TextAlign.center,
                              ),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        } else if (fileNameController.text.isEmpty) {
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
                          createTemplate();
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

  void createTemplate() async {
    http.Response response = await api.templateCreate(
      widget.store,
      nameController.text,
      templateColor,
      templateScreen,
      jsonFileContent,
    );

    if (response.statusCode == 200) {
      setState(() {
        nameController.clear();
        fileNameController.clear();
        templateColor = 1;
        templateScreen = 1;
        jsonFileContent = "";
      });

      if (context.mounted) {
        api.requestSuccess(context, "Template criado com sucesso!");
      }
      getTemplates();
    } else {
      if (context.mounted) {
        api.requestError(context, response);
      }
    }
  }
}
