import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'package:exemplo_esl/classes/product_class.dart';
import 'package:exemplo_esl/services/api_service.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final int shopId;
  final VoidCallback getProducts;
  const ProductCard({
    super.key,
    required this.product,
    required this.shopId,
    required this.getProducts,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  final ApiService api = ApiService();
  var productInfo = {};
  bool finished = false;
  bool gotInfo = false;
  final NumberFormat real =
      NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

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
    getInfo();
  }

  @override
  void dispose() {
    super.dispose();
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
  Widget build(BuildContext context) {
    return SizedBox(
      width: 210,
      height: 250,
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
                            widget.product.name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        'Preço: ${real.format(widget.product.price)}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            onPressed: () {
                              showInfo();
                            },
                            icon: const Icon(
                              Icons.info,
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
                            onPressed: showDelete,
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
    http.Response response =
        await api.productGetInfo(widget.product.id, widget.shopId);

    if (response.statusCode == 200) {
      var object = jsonDecode(response.body);
      if (mounted) {
        setState(() {
          productInfo = object['data'];
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

  //Info do produto
  void showInfo() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            widget.product.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            width: 350,
            height: 300,
            child: Scrollbar(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      'ID: ${widget.product.id}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Visibility(
                      visible: productInfo['alias'] != '',
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            'Pseudônimo: ${productInfo['alias']}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Preço: ${real.format(widget.product.price)}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Visibility(
                      visible: productInfo['promote_price'] != -1,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            'Preço promoção: ${real.format(productInfo['promote_price'])}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: productInfo['member_price'] != -1,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            'Preço membros: ${real.format(productInfo['member_price'])}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: productInfo['brand'] != '',
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            'Marca: ${productInfo['brand']}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: productInfo['unit'] != '',
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            'Unidade: ${productInfo['unit']}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: productInfo['spec'] != '',
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            'Especificação: ${productInfo['spec']}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: productInfo['area'] != '',
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            'Local de origem: ${productInfo['area']}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: productInfo['bar_code'] != '',
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            'Código de barras: ${productInfo['bar_code']}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: productInfo['qr_code'] != '',
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            'Link QR-Code: ${productInfo['qr_code']}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  //Editar produto
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
                    'Editar ${widget.product.name}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: SizedBox(
                    width: 500,
                    height: 500,
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: 485,
                              child: TextFormField(
                                controller: nameController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Nome",
                                  labelStyle: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: 485,
                              child: TextFormField(
                                controller: aliasController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Pseudônimo",
                                  labelStyle: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: 485,
                              child: TextFormField(
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
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: 485,
                              child: TextFormField(
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
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: 485,
                              child: TextFormField(
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
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: 485,
                              child: TextFormField(
                                controller: brandController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Marca",
                                  labelStyle: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: 485,
                              child: TextFormField(
                                controller: unitController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Unidade",
                                  labelStyle: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: 485,
                              child: TextFormField(
                                controller: specController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Especificação",
                                  labelStyle: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: 485,
                              child: TextFormField(
                                controller: barcodeController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Código de barras",
                                  labelStyle: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: 485,
                              child: TextFormField(
                                controller: qrcodeController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Link QR-Code",
                                  labelStyle: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: 485,
                              child: TextFormField(
                                controller: areaController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Local de origem",
                                  labelStyle: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
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
                        if (nameController.text.isEmpty &&
                            aliasController.text.isEmpty &&
                            priceController.text.isEmpty &&
                            salePriceController.text.isEmpty &&
                            memberPriceController.text.isEmpty &&
                            brandController.text.isEmpty &&
                            unitController.text.isEmpty &&
                            specController.text.isEmpty &&
                            barcodeController.text.isEmpty &&
                            qrcodeController.text.isEmpty &&
                            areaController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Preencha ao menos um campo",
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
    String list = '[{"id": "${widget.product.id}"';
    if (nameController.text.isNotEmpty) {
      list = '$list, "name": "${nameController.text}"';
    }
    if (aliasController.text.isNotEmpty) {
      list = '$list, "alias": "${aliasController.text}"';
    }
    if (priceController.text.isNotEmpty) {
      list = '$list, "price": "${priceController.text}"';
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

    http.Response response = await api.productUpdate(list, widget.shopId);
    if (response.statusCode == 200) {
      if (context.mounted) {
        api.requestSuccess(context, "Produto atualizado com sucesso!");
      }
      widget.getProducts();
    } else {
      if (context.mounted) {
        api.requestError(context, response);
      }
    }
  }

  //Deletar protudo
  void showDelete() {
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
            height: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text.rich(
                  TextSpan(
                    text: "Você está prestes a deletar o produto ",
                    style: const TextStyle(fontSize: 18),
                    children: [
                      TextSpan(
                        text: '${widget.product.name}.',
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
                delete();
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

  void delete() async {
    http.Response response =
        await api.productDelete(widget.product.id, widget.shopId);

    if (response.statusCode == 200) {
      widget.getProducts();
      if (context.mounted) {
        api.requestSuccess(context, "Produto deletado com sucesso!");
      }
    } else {
      if (context.mounted) {
        api.requestError(context, response);
      }
    }
  }
}
