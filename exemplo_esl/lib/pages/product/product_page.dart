import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:number_pagination/number_pagination.dart';

import 'package:exemplo_esl/services/api_service.dart';
import 'package:exemplo_esl/classes/product_class.dart';
import 'package:exemplo_esl/pages/product/product_card_widget.dart';

class ProductPage extends StatefulWidget {
  final int store;

  const ProductPage({
    super.key,
    required this.store,
  });

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  ApiService api = ApiService();
  int pageNum = 1;
  int pages = 0;
  var productList = <Product>[];
  bool finished = false;
  bool gotProds = false;

  final idController = TextEditingController();
  final nameController = TextEditingController();
  final aliasController = TextEditingController();
  final priceController = TextEditingController();
  final salePriceController = TextEditingController();
  final memberPriceController = TextEditingController();
  final brandController = TextEditingController();
  final unitController = TextEditingController();
  final specController = TextEditingController();
  final barcodeController = TextEditingController();
  final qrcodeController = TextEditingController();
  final areaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getProducts();
  }

  @override
  void dispose() {
    super.dispose();
    idController.dispose();
    nameController.dispose();
    aliasController.dispose();
    priceController.dispose();
    salePriceController.dispose();
    memberPriceController.dispose();
    brandController.dispose();
    unitController.dispose();
    specController.dispose();
    barcodeController.dispose();
    qrcodeController.dispose();
    areaController.dispose();
  }

  @override
  void didUpdateWidget(covariant ProductPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      pageNum = 1;
    });
    getProducts();
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
                      "Produtos cadastrados",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromARGB(255, 252, 224, 124)),
                      ),
                      onPressed: showCreateProduct,
                      child: const Icon(Icons.add),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                finished
                    ? Visibility(
                        visible: gotProds,
                        child: Column(
                          children: [
                            productList.isNotEmpty
                                ? Wrap(
                                    spacing: 35,
                                    runSpacing: 35,
                                    children: productList.map((p) {
                                      return ProductCard(
                                        product: p,
                                        shopId: widget.store,
                                        getProducts: getProducts,
                                      );
                                    }).toList(),
                                  )
                                : const Padding(
                                    padding: EdgeInsets.only(top: 100),
                                    child: Text(
                                      "Não existem produtos cadastrados nessa filial",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30,
                                      ),
                                    ),
                                  ),
                            const SizedBox(height: 20),
                            Visibility(
                              visible: productList.isNotEmpty,
                              child: NumberPagination(
                                onPageChanged: (int pageNumber) {
                                  setState(() {
                                    pageNum = pageNumber;
                                  });
                                  getProducts();
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

  void getProducts() async {
    setState(() {
      finished = false;
      gotProds = false;
    });
    http.Response prodResponse =
        await api.productGetList(widget.store, pageNum);

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
        productList = prodList;
        pages = (object['data']['total_count'] / api.pageSize).ceil();
        gotProds = true;
        finished = true;
      });
    } else {
      setState(() {
        finished = true;
      });
      if (context.mounted) {
        api.requestError(context, prodResponse);
      }
    }
  }

  void showCreateProduct() {
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
                    'Criar produto',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: SizedBox(
                    width: 500,
                    height: 500,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: idController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "ID",
                              labelStyle: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
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
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: aliasController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Pseudônimo",
                              labelStyle: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: priceController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d{0,2}'))
                            ],
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Preço",
                              labelStyle: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: salePriceController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d{0,2}'))
                            ],
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Preço promoção",
                              labelStyle: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: memberPriceController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d{0,2}'))
                            ],
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Preço membros",
                              labelStyle: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: brandController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Marca",
                              labelStyle: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: unitController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Unidade",
                              labelStyle: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: specController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Especificação",
                              labelStyle: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: barcodeController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Código de barras",
                              labelStyle: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: qrcodeController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Link QR-Code",
                              labelStyle: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: areaController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Local de origem",
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
                        idController.clear();
                        nameController.clear();
                        aliasController.clear();
                        priceController.clear();
                        salePriceController.clear();
                        memberPriceController.clear();
                        brandController.clear();
                        unitController.clear();
                        specController.clear();
                        barcodeController.clear();
                        qrcodeController.clear();
                        areaController.clear();
                      },
                      child: const Text("Cancelar"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (idController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "ID é um campo obrigatório",
                                style: TextStyle(fontSize: 20),
                                textAlign: TextAlign.center,
                              ),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        } else if (nameController.text.isEmpty) {
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
                        } else if (priceController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Preço é um campo obrigatório",
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
                          createProduct();
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

  void createProduct() async {
    String list =
        '[{"id": "${idController.text}", "seq_num": "${idController.text}", "name": "${nameController.text}", "price": "${priceController.text}"';
    if (aliasController.text.isNotEmpty) {
      list = '$list, "alias": "${aliasController.text}"';
    }
    if (salePriceController.text.isNotEmpty) {
      list = '$list, "promote_price": "${salePriceController.text}"';
    }
    if (memberPriceController.text.isNotEmpty) {
      list = '$list, "member_price": "${memberPriceController.text}"';
    }
    if (brandController.text.isNotEmpty) {
      list = '$list, "brand": "${brandController.text}"';
    }
    if (unitController.text.isNotEmpty) {
      list = '$list, "unit": "${unitController.text}"';
    }
    if (specController.text.isNotEmpty) {
      list = '$list, "spec": "${specController.text}"';
    }
    if (barcodeController.text.isNotEmpty) {
      list = '$list, "bar_code": "${barcodeController.text}"';
    }
    if (qrcodeController.text.isNotEmpty) {
      list = '$list, "qr_code": "${qrcodeController.text}"';
    }
    if (areaController.text.isNotEmpty) {
      list = '$list, "area": "${areaController.text}"';
    }
    list = '$list}]';

    http.Response response = await api.productCreate(list, widget.store);
    if (response.statusCode == 200) {
      idController.clear();
      nameController.clear();
      aliasController.clear();
      priceController.clear();
      salePriceController.clear();
      memberPriceController.clear();
      brandController.clear();
      unitController.clear();
      specController.clear();
      barcodeController.clear();
      qrcodeController.clear();
      areaController.clear();
      if (context.mounted) {
        api.requestSuccess(context, "Produto criado com sucesso!");
      }
      getProducts();
    } else {
      if (context.mounted) {
        api.requestError(context, response);
      }
    }
  }
}
