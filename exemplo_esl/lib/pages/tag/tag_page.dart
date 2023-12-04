import 'dart:convert';
import 'package:number_pagination/number_pagination.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:exemplo_esl/services/api_service.dart';
import 'package:exemplo_esl/classes/tag_class.dart';
import 'package:exemplo_esl/pages/tag/tag_card_widget.dart';

class TagPage extends StatefulWidget {
  final int store;

  const TagPage({
    super.key,
    required this.store,
  });

  @override
  State<TagPage> createState() => _TagPageState();
}

class _TagPageState extends State<TagPage> {
  ApiService api = ApiService();
  int pageNum = 1;
  int pages = 0;
  var tagList = <Tag>[];
  bool finished = false;
  bool gotTags = false;

  final serialNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getTags();
  }

  @override
  void dispose() {
    super.dispose();
    serialNumberController.dispose();
  }

  @override
  void didUpdateWidget(covariant TagPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      pageNum = 1;
    });
    getTags();
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
                      "Etiquetas cadastradas",
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
                      onPressed: showBindTag,
                      child: const Icon(Icons.add),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                finished
                    ? Visibility(
                        visible: gotTags,
                        child: Column(
                          children: [
                            tagList.isNotEmpty
                                ? Wrap(
                                    spacing: 35,
                                    runSpacing: 35,
                                    children: tagList.map((a) {
                                      return TagCard(
                                        tag: a,
                                        shopId: widget.store,
                                        getTags: getTags,
                                      );
                                    }).toList(),
                                  )
                                : const Padding(
                                    padding: EdgeInsets.only(top: 100),
                                    child: Text(
                                      "Não existem etiquetas vinculadas nessa filial",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30,
                                      ),
                                    ),
                                  ),
                            const SizedBox(height: 20),
                            Visibility(
                              visible: tagList.isNotEmpty,
                              child: NumberPagination(
                                onPageChanged: (int pageNumber) {
                                  setState(() {
                                    pageNum = pageNumber;
                                  });
                                  getTags();
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

  void getTags() async {
    setState(() {
      finished = false;
      gotTags = false;
    });

    http.Response response = await api.tagGetList(widget.store, pageNum);
    if (response.statusCode == 200) {
      var object = jsonDecode(response.body);
      var array = object['data']['esl_list'];
      var tagL = <Tag>[];
      array.forEach((t) {
        Tag tag = Tag(
          id: t['esl_id'],
          code: t['esl_code'],
          serialNumber: t['esl_sn'],
          modelName: t['model_name'],
          status: t['status'],
        );
        tagL.add(tag);
      });
      setState(() {
        tagList = tagL;
        pages = (object['data']['total_count'] / api.pageSize).ceil();
        gotTags = true;
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

  void showBindTag() {
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
                    'Vincular etiqueta',
                    textAlign: TextAlign.center,
                    style: TextStyle(
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
                            controller: serialNumberController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Número de série",
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
                        serialNumberController.clear();
                      },
                      child: const Text("Cancelar"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (serialNumberController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Número de série é um campo obrigatório",
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
                          bindTag();
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

  void bindTag() async {
    http.Response response =
        await api.tagBind(widget.store, serialNumberController.text);

    if (response.statusCode == 200) {
      serialNumberController.clear();
      if (context.mounted) {
        api.requestSuccess(context, "Etiqueta vinculada com sucesso!");
      }
      getTags();
    } else {
      if (context.mounted) {
        api.requestError(context, response);
      }
    }
  }
}
