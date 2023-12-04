import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:page_view_indicators/page_view_indicators.dart';

import 'package:exemplo_esl/classes/tag_class.dart';
import 'package:exemplo_esl/classes/product_class.dart';
import 'package:exemplo_esl/classes/template_class.dart';
import 'package:exemplo_esl/services/api_service.dart';

class TagCard extends StatefulWidget {
  final Tag tag;
  final int shopId;
  final VoidCallback getTags;

  const TagCard({
    super.key,
    required this.tag,
    required this.shopId,
    required this.getTags,
  });

  @override
  State<TagCard> createState() => _TagCardState();
}

class _TagCardState extends State<TagCard> {
  final ApiService api = ApiService();
  var tagInfo = {};
  bool finished = false;
  bool gotInfo = false;
  int screenSize = 0;

  int selectedColor = 1;

  var productList = <Product>[];
  String selectedProduct = "";
  final productController = PageController();
  final productPageNotifier = ValueNotifier<int>(0);
  int totalProducts = 0;
  int productPage = 1;
  int productMaxPages = 0;

  var templateList = <Template>[];
  String selectedTemplate = "";
  final templateController = PageController();
  final templatePageNotifier = ValueNotifier<int>(0);
  int totalTemplates = 0;
  int templatePage = 1;
  int templateMaxPages = 0;

  @override
  void initState() {
    super.initState();
    checkScreenSize();
    getInfo();
  }

  @override
  void dispose() {
    super.dispose();
    productController.dispose();
    templateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 210,
      height: 500,
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
                            'SN: ${widget.tag.serialNumber}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        'ID: ${widget.tag.id}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        'AP: ${tagInfo['ap_name']}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        'Bateria: ${tagInfo['battery']}%',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        'Status: ${translateStatus(tagInfo['status'])}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            onPressed: getProducts,
                            icon: const Icon(
                              Icons.merge_type,
                              color: Colors.purple,
                              size: 40,
                            ),
                          ),
                          IconButton(
                            onPressed: showLocate,
                            icon: const Icon(
                              Icons.location_searching,
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

    http.Response response = await api.tagGetInfo(widget.shopId, widget.tag.id);

    if (response.statusCode == 200) {
      var object = jsonDecode(response.body);
      if (mounted) {
        setState(() {
          tagInfo = object['data'];
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
    String statusTag = "";
    status == 0
        ? statusTag = "Não ativada"
        : status == 1
            ? statusTag = "Não vinculada"
            : status == 2
                ? statusTag = "Aguardando dados"
                : status == 3
                    ? statusTag = "Envio OK"
                    : status == 4
                        ? statusTag = "Falha no envio"
                        : "Desconhecido";
    return statusTag;
  }

  void checkScreenSize() {
    if (widget.tag.modelName.substring(0, 5) == "SL175") {
      setState(() {
        screenSize = 4;
      });
    } else if (widget.tag.modelName.substring(0, 5) == "SL126") {
      setState(() {
        screenSize = 2;
      });
    } else if (widget.tag.modelName.substring(0, 5) == "SL142") {
      setState(() {
        screenSize = 3;
      });
    } else if (widget.tag.modelName.substring(0, 5) == "SL115") {
      setState(() {
        screenSize = 5;
      });
    } else if (widget.tag.modelName.substring(0, 5) == "SL121") {
      setState(() {
        screenSize = 1;
      });
    }
  }

  //Vincular produto
  void getProducts() async {
    if (productList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Coletando informações dos produtos, aguarde um momento",
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.blue,
        ),
      );
      http.Response prodResponse = await api.productGetAll(widget.shopId, 1);

      if (prodResponse.statusCode == 200) {
        var object = jsonDecode(prodResponse.body);
        var array = object['data']['product_list'];
        var prodList = <Product>[];
        array.forEach((p) {
          Product prod = Product(
            id: p['id'],
            name: p['name'],
            price: double.parse(p['price'].toString()),
          );
          prodList.add(prod);
        });
        setState(() {
          // productController.initialPage = 1;
          productList = prodList;
          productMaxPages = (object['data']['total_count'] / 10).ceil();
          totalProducts = object['data']['total_count'];
        });
        showSelectProd();
      } else {
        if (context.mounted) {
          api.requestError(context, prodResponse);
        }
      }
    } else {
      showSelectProd();
    }
  }

  void showSelectProd() {
    showDialog(
      context: context,
      builder: (context) => ScaffoldMessenger(
        child: StatefulBuilder(
          builder: (context, setState) => Scaffold(
            backgroundColor: Colors.transparent,
            body: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Navigator.of(context).pop();
                productPageNotifier.value = 0;
              },
              child: GestureDetector(
                onTap: () {},
                child: AlertDialog(
                  title: const Text(
                    'Selecione um produto',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: SizedBox(
                    width: 600,
                    height: 600,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 400,
                          child: PageView.builder(
                            controller: productController,
                            itemCount: productMaxPages,
                            onPageChanged: (index) {
                              productPageNotifier.value = index;
                            },
                            itemBuilder: (context, index) {
                              var initIndex = index * 10;
                              var finishIndex = initIndex + 9;
                              var totalProds = 10;
                              if (finishIndex > (totalProducts - 1)) {
                                finishIndex = (totalProducts - 1);
                                totalProds = totalProducts - initIndex;
                              }
                              return Scrollbar(
                                child: ListView.separated(
                                  itemBuilder: (context, product) {
                                    return ListTile(
                                      title: Text(
                                          productList[product + initIndex]
                                              .name),
                                      selected:
                                          productList[product + initIndex].id ==
                                              selectedProduct,
                                      selectedTileColor: const Color.fromARGB(
                                          255, 158, 164, 201),
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(12),
                                        ),
                                      ),
                                      onLongPress: () {
                                        setState(() {
                                          selectedProduct =
                                              productList[product + initIndex]
                                                  .id;
                                        });
                                      },
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      const Divider(),
                                  itemCount: totalProds,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 50),
                        StepPageIndicator(
                          currentPageNotifier: productPageNotifier,
                          stepColor: Colors.grey,
                          itemCount: productMaxPages,
                          size: 20,
                          onPageSelected: (int index) {
                            if (productPageNotifier.value > index) {
                              productController.jumpToPage(index);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        productPageNotifier.value = 0;
                      },
                      child: const Text("Cancelar"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (selectedProduct == "") {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Selecione um produto para vincular à etiqueta",
                                style: TextStyle(fontSize: 20),
                                textAlign: TextAlign.center,
                              ),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        } else {
                          Navigator.of(context).pop();
                          getTemplates();
                        }
                      },
                      child: const Text("Continuar"),
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

  void getTemplates() async {
    if (templateList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Coletando informações dos templates, aguarde um momento",
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.blue,
        ),
      );
      http.Response templateResponse =
          await api.templateGetAll(widget.shopId, 1);

      if (templateResponse.statusCode == 200) {
        var object = jsonDecode(templateResponse.body);
        var array = object['data']['template_list'];
        var tempList = <Template>[];
        array.forEach((t) {
          if (t['template_screen'] == screenSize) {
            Template prod = Template(
              id: t['template_id'],
              name: t['template_name'],
              screen: t['template_screen'],
            );
            tempList.add(prod);
          }
        });
        setState(() {
          templateList = tempList;
          templateMaxPages = (tempList.length / 10).ceil();
          totalTemplates = tempList.length;
        });
        showSelectTemplate();
      } else {
        if (context.mounted) {
          api.requestError(context, templateResponse);
        }
      }
    } else {
      showSelectTemplate();
    }
  }

  void showSelectTemplate() {
    showDialog(
      context: context,
      builder: (context) => ScaffoldMessenger(
        child: StatefulBuilder(
          builder: (context, setState) => Scaffold(
            backgroundColor: Colors.transparent,
            body: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Navigator.of(context).pop();
                templatePageNotifier.value = 0;
              },
              child: GestureDetector(
                onTap: () {},
                child: AlertDialog(
                  title: const Text(
                    'Selecione um template',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: SizedBox(
                    width: 600,
                    height: 600,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 400,
                          child: PageView.builder(
                            controller: templateController,
                            itemCount: templateMaxPages,
                            onPageChanged: (index) {
                              templatePageNotifier.value = index;
                            },
                            itemBuilder: (context, index) {
                              var initIndex = index * 10;
                              var finishIndex = initIndex + 9;
                              var totalTemps = 10;
                              if (finishIndex > (totalTemplates - 1)) {
                                finishIndex = (totalTemplates - 1);
                                totalTemps = totalTemplates - initIndex;
                              }
                              return Scrollbar(
                                child: ListView.separated(
                                  itemBuilder: (context, template) {
                                    return ListTile(
                                      title: Text(
                                          templateList[template + initIndex]
                                              .name),
                                      selected:
                                          templateList[template + initIndex]
                                                  .id ==
                                              selectedTemplate,
                                      selectedTileColor: const Color.fromARGB(
                                          255, 158, 164, 201),
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(12),
                                        ),
                                      ),
                                      onLongPress: () {
                                        setState(() {
                                          selectedTemplate =
                                              templateList[template + initIndex]
                                                  .id;
                                        });
                                      },
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      const Divider(),
                                  itemCount: totalTemps,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 50),
                        StepPageIndicator(
                          currentPageNotifier: templatePageNotifier,
                          stepColor: Colors.grey,
                          itemCount: templateMaxPages,
                          size: 20,
                          onPageSelected: (int index) {
                            if (templatePageNotifier.value > index) {
                              templateController.jumpToPage(index);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        templatePageNotifier.value = 0;
                      },
                      child: const Text("Cancelar"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (selectedTemplate == "") {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Selecione um template para vincular à etiqueta",
                                style: TextStyle(fontSize: 20),
                                textAlign: TextAlign.center,
                              ),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        } else {
                          Navigator.of(context).pop();
                          bindProd();
                        }
                      },
                      child: const Text("Continuar"),
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

  void bindProd() async {
    http.Response response = await api.tagBindProduct(
      widget.shopId,
      widget.tag.id,
      selectedProduct,
      selectedTemplate,
    );
    if (response.statusCode == 200) {
      setState(() {
        selectedProduct = "";
        selectedTemplate = "";
      });
      if (context.mounted) {
        api.requestSuccess(context,
            "Produto vinculado com sucesso! Aguarde enquanto a etiqueta atualiza.");
      }
    } else {
      if (context.mounted) {
        api.requestError(context, response);
      }
    }
  }

  //Localizar tag
  void showLocate() {
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
                    'Localizar etiqueta ${widget.tag.serialNumber}',
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
                          DropdownButtonFormField(
                            decoration: InputDecoration(
                                label: const Text("Cor"),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                )),
                            value: selectedColor,
                            items: const [
                              DropdownMenuItem(
                                value: 1,
                                child: Text("Branco"),
                              ),
                              DropdownMenuItem(
                                value: 2,
                                child: Text("Azul"),
                              ),
                              DropdownMenuItem(
                                value: 4,
                                child: Text("Verde"),
                              ),
                              DropdownMenuItem(
                                value: 8,
                                child: Text("Vermelho"),
                              ),
                              DropdownMenuItem(
                                value: 512,
                                child: Text("Ciano"),
                              ),
                              DropdownMenuItem(
                                value: 1024,
                                child: Text("Roxo"),
                              ),
                              DropdownMenuItem(
                                value: 2048,
                                child: Text("Amarelo"),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                selectedColor = value!;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Cancelar"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        locate();
                      },
                      child: const Text("Localizar"),
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

  void locate() async {
    http.Response response =
        await api.tagFlashLed(widget.shopId, widget.tag.id, selectedColor);

    if (response.statusCode == 200) {
      if (context.mounted) {
        api.requestSuccess(context, "Comando enviado com sucesso!");
      }
    } else {
      if (context.mounted) {
        api.requestError(context, response);
      }
    }
  }

  //Desvincular etiqueta
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
                    text: "Você está prestes a desvincular a etiqueta ",
                    style: const TextStyle(fontSize: 18),
                    children: [
                      TextSpan(
                        text: '${widget.tag.serialNumber}.',
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
    http.Response response = await api.tagUnbind(widget.shopId, widget.tag.id);

    if (response.statusCode == 200) {
      if (context.mounted) {
        api.requestSuccess(context, "Etiqueta desvinculada com sucesso!");
      }
      widget.getTags();
    } else {
      if (context.mounted) {
        api.requestError(context, response);
      }
    }
  }
}
