import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  String host = 'itfastesl.azurewebsites.net';
  final int pageSize = 20;

  void requestError(BuildContext context, http.Response response) {
    var json = jsonDecode(response.body);
    String msg = json['err'];
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: const TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  void requestSuccess(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: const TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  //User
  Future<http.Response> login(login, password) async {
    var url = Uri(scheme: 'https', host: host, path: '/login');

    final body = jsonEncode({"login": login, "password": password});

    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'}, body: body);

    return response;
  }

  Future<http.Response> userGetInfo(email) async {
    var url = Uri(scheme: 'https', host: host, path: '/db/user/getInfo');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token =
        sharedPreferences.getString('token').toString().replaceAll('"', '');

    final body = jsonEncode({"email": email});
    final header = {
      'Content-Type': 'application/json',
      'authorization': token,
    };

    final response = await http.post(url, headers: header, body: body);

    return response;
  }

  //Empresa
  Future<http.Response> companyGetInfo(id) async {
    var url = Uri(scheme: 'https', host: host, path: '/db/company/getInfo');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token =
        sharedPreferences.getString('token').toString().replaceAll('"', '');

    final body = jsonEncode({"id": id});
    final header = {
      'Content-Type': 'application/json',
      'authorization': token,
    };
    final response = await http.post(url, headers: header, body: body);

    return response;
  }

  Future<http.Response> companyGetList() async {
    var url = Uri(scheme: 'https', host: host, path: '/db/company/getList');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token =
        sharedPreferences.getString('token').toString().replaceAll('"', '');

    final header = {
      'Content-Type': 'application/json',
      'authorization': token,
    };
    final response = await http.post(url, headers: header);

    return response;
  }

  //Filial
  Future<http.Response> branchGetInfo(id) async {
    var url = Uri(scheme: 'https', host: host, path: '/db/branch/getInfo');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token =
        sharedPreferences.getString('token').toString().replaceAll('"', '');

    final body = jsonEncode({"id": id});
    final header = {
      'Content-Type': 'application/json',
      'authorization': token,
    };
    final response = await http.post(url, headers: header, body: body);

    return response;
  }

  Future<http.Response> branchGetList(id) async {
    var url = Uri(scheme: 'https', host: host, path: '/db/branch/getList');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token =
        sharedPreferences.getString('token').toString().replaceAll('"', '');

    final body = jsonEncode({"is_branch_id": id});
    final header = {
      'Content-Type': 'application/json',
      'authorization': token,
    };
    final response = await http.post(url, headers: header, body: body);

    return response;
  }

  //Produtos
  Future<http.Response> productGetList(shopId, pageNum) async {
    var url = Uri(scheme: 'https', host: host, path: '/api/product/getList');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token =
        sharedPreferences.getString('token').toString().replaceAll('"', '');

    final body = jsonEncode({
      "shop_id": shopId.toString(),
      "page_num": pageNum,
      "page_size": pageSize
    });
    final header = {
      'Content-Type': 'application/json',
      'authorization': token,
    };
    final response = await http.post(url, headers: header, body: body);

    return response;
  }

  Future<http.Response> productGetAll(shopId, pageNum) async {
    var url = Uri(scheme: 'https', host: host, path: '/api/product/getList');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token =
        sharedPreferences.getString('token').toString().replaceAll('"', '');

    final body1 = jsonEncode({
      "shop_id": shopId.toString(),
      "page_num": pageNum,
      "page_size": pageSize
    });
    final header = {
      'Content-Type': 'application/json',
      'authorization': token,
    };
    final response1 = await http.post(url, headers: header, body: body1);

    if (response1.statusCode == 200) {
      var object = jsonDecode(response1.body);
      int totalProds = object['data']['total_count'];

      final body2 = jsonEncode({
        "shop_id": shopId.toString(),
        "page_num": 1,
        "page_size": totalProds
      });

      final response2 = await http.post(url, headers: header, body: body2);

      return response2;
    } else {
      return response1;
    }
  }

  Future<http.Response> productGetInfo(productId, shopId) async {
    var url = Uri(scheme: 'https', host: host, path: '/api/product/getInfo');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token =
        sharedPreferences.getString('token').toString().replaceAll('"', '');

    final body = jsonEncode({
      "shop_id": shopId.toString(),
      "product_id": productId,
    });
    final header = {
      'Content-Type': 'application/json',
      'authorization': token,
    };
    final response = await http.post(url, headers: header, body: body);

    return response;
  }

  Future<http.Response> productCreate(productList, shopId) async {
    var url = Uri(scheme: 'https', host: host, path: '/api/product/create');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token =
        sharedPreferences.getString('token').toString().replaceAll('"', '');

    final body = jsonEncode({
      "shop_id": shopId.toString(),
      "product_list": productList,
    });
    final header = {
      'Content-Type': 'application/json',
      'authorization': token,
    };
    final response = await http.post(url, headers: header, body: body);

    return response;
  }

  Future<http.Response> productUpdate(productList, shopId) async {
    var url = Uri(scheme: 'https', host: host, path: '/api/product/update');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token =
        sharedPreferences.getString('token').toString().replaceAll('"', '');

    final body = jsonEncode({
      "shop_id": shopId.toString(),
      "product_list": productList,
    });
    final header = {
      'Content-Type': 'application/json',
      'authorization': token,
    };
    final response = await http.post(url, headers: header, body: body);

    return response;
  }

  Future<http.Response> productDelete(productId, shopId) async {
    var url = Uri(scheme: 'https', host: host, path: '/api/product/delete');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token =
        sharedPreferences.getString('token').toString().replaceAll('"', '');

    final body = jsonEncode({
      "shop_id": shopId.toString(),
      "product_key_list": '[$productId]',
    });
    final header = {
      'Content-Type': 'application/json',
      'authorization': token,
    };
    final response = await http.post(url, headers: header, body: body);

    return response;
  }

  //APs
  Future<http.Response> apGetList(shopId, pageNum) async {
    var url = Uri(scheme: 'https', host: host, path: '/api/ap/getList');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token =
        sharedPreferences.getString('token').toString().replaceAll('"', '');

    final body = jsonEncode({
      "shop_id": shopId.toString(),
      "page_num": pageNum,
      "page_size": pageSize
    });
    final header = {
      'Content-Type': 'application/json',
      'authorization': token,
    };
    final response = await http.post(url, headers: header, body: body);

    return response;
  }

  Future<http.Response> apGetInfo(shopId, apId) async {
    var url = Uri(scheme: 'https', host: host, path: '/api/ap/getInfo');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token =
        sharedPreferences.getString('token').toString().replaceAll('"', '');

    final body = jsonEncode({
      "shop_id": shopId.toString(),
      "ap_id": apId,
    });
    final header = {
      'Content-Type': 'application/json',
      'authorization': token,
    };
    final response = await http.post(url, headers: header, body: body);

    return response;
  }

  Future<http.Response> apBind(shopId, apName, apSn) async {
    var url = Uri(scheme: 'https', host: host, path: '/api/ap/bind');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token =
        sharedPreferences.getString('token').toString().replaceAll('"', '');

    final body = jsonEncode({
      "shop_id": shopId.toString(),
      "ap_name": apName,
      "ap_sn": apSn,
    });
    final header = {
      'Content-Type': 'application/json',
      'authorization': token,
    };
    final response = await http.post(url, headers: header, body: body);

    return response;
  }

  Future<http.Response> apUpdate(shopId, apName, apId) async {
    var url = Uri(scheme: 'https', host: host, path: '/api/ap/updateName');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token =
        sharedPreferences.getString('token').toString().replaceAll('"', '');

    final body = jsonEncode({
      "shop_id": shopId.toString(),
      "ap_name": apName,
      "ap_id": apId,
    });
    final header = {
      'Content-Type': 'application/json',
      'authorization': token,
    };
    final response = await http.post(url, headers: header, body: body);

    return response;
  }

  Future<http.Response> apUnbind(shopId, apId) async {
    var url = Uri(scheme: 'https', host: host, path: '/api/ap/unbind');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token =
        sharedPreferences.getString('token').toString().replaceAll('"', '');

    final body = jsonEncode({
      "shop_id": shopId.toString(),
      "ap_id": apId,
    });
    final header = {
      'Content-Type': 'application/json',
      'authorization': token,
    };
    final response = await http.post(url, headers: header, body: body);

    return response;
  }

  Future<http.Response> apReboot(shopId, apId) async {
    var url = Uri(scheme: 'https', host: host, path: '/api/ap/reboot');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token =
        sharedPreferences.getString('token').toString().replaceAll('"', '');

    final body = jsonEncode({
      "shop_id": shopId.toString(),
      "ap_id": apId,
    });
    final header = {
      'Content-Type': 'application/json',
      'authorization': token,
    };
    final response = await http.post(url, headers: header, body: body);

    return response;
  }

  //Etiquetas
  Future<http.Response> tagGetList(shopId, pageNum) async {
    var url = Uri(scheme: 'https', host: host, path: '/api/esl/getList');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token =
        sharedPreferences.getString('token').toString().replaceAll('"', '');

    final body = jsonEncode({
      "shop_id": shopId.toString(),
      "page_num": pageNum,
      "page_size": pageSize
    });
    final header = {
      'Content-Type': 'application/json',
      'authorization': token,
    };
    final response = await http.post(url, headers: header, body: body);

    return response;
  }

  Future<http.Response> tagGetInfo(shopId, eslId) async {
    var url = Uri(scheme: 'https', host: host, path: '/api/esl/getInfo');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token =
        sharedPreferences.getString('token').toString().replaceAll('"', '');

    final body = jsonEncode({
      "shop_id": shopId.toString(),
      "esl_id": eslId,
    });
    final header = {
      'Content-Type': 'application/json',
      'authorization': token,
    };
    final response = await http.post(url, headers: header, body: body);

    return response;
  }

  Future<http.Response> tagBind(shopId, eslSn) async {
    var url = Uri(scheme: 'https', host: host, path: '/api/esl/bind');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token =
        sharedPreferences.getString('token').toString().replaceAll('"', '');

    final body = jsonEncode({
      "shop_id": shopId.toString(),
      "esl_sn": eslSn,
    });
    final header = {
      'Content-Type': 'application/json',
      'authorization': token,
    };
    final response = await http.post(url, headers: header, body: body);

    return response;
  }

  Future<http.Response> tagUnbind(shopId, eslId) async {
    var url = Uri(scheme: 'https', host: host, path: '/api/esl/unbind');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token =
        sharedPreferences.getString('token').toString().replaceAll('"', '');

    final body = jsonEncode({
      "shop_id": shopId.toString(),
      "esl_id": eslId,
    });
    final header = {
      'Content-Type': 'application/json',
      'authorization': token,
    };
    final response = await http.post(url, headers: header, body: body);

    return response;
  }

  Future<http.Response> tagFlashLed(shopId, eslId, channel) async {
    var url = Uri(scheme: 'https', host: host, path: '/api/esl/flashled');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token =
        sharedPreferences.getString('token').toString().replaceAll('"', '');

    final body = jsonEncode({
      "shop_id": shopId.toString(),
      "esl_id": eslId,
      "channel": channel,
    });

    final header = {
      'Content-Type': 'application/json',
      'authorization': token,
    };
    final response = await http.post(url, headers: header, body: body);

    return response;
  }

  Future<http.Response> tagBindProduct(
      shopId, eslId, productId, templateId) async {
    var url = Uri(scheme: 'https', host: host, path: '/api/product/bind');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token =
        sharedPreferences.getString('token').toString().replaceAll('"', '');

    final body = jsonEncode({
      "shop_id": shopId.toString(),
      "esl_id": eslId,
      "product_id": productId,
      "template_id": templateId,
    });

    final header = {
      'Content-Type': 'application/json',
      'authorization': token,
    };
    final response = await http.post(url, headers: header, body: body);

    return response;
  }

  Future<http.Response> tagUnbindProduct(shopId, eslId) async {
    var url = Uri(scheme: 'https', host: host, path: '/api/product/unbind');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token =
        sharedPreferences.getString('token').toString().replaceAll('"', '');

    final body = jsonEncode({
      "shop_id": shopId.toString(),
      "esl_id": eslId,
    });

    final header = {
      'Content-Type': 'application/json',
      'authorization': token,
    };
    final response = await http.post(url, headers: header, body: body);

    return response;
  }

  //Templates
  Future<http.Response> templateGetList(shopId, pageNum) async {
    var url = Uri(scheme: 'https', host: host, path: '/api/template/getList');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token =
        sharedPreferences.getString('token').toString().replaceAll('"', '');

    final body = jsonEncode({
      "shop_id": shopId.toString(),
      "page_num": pageNum,
      "page_size": pageSize
    });
    final header = {
      'Content-Type': 'application/json',
      'authorization': token,
    };
    final response = await http.post(url, headers: header, body: body);

    return response;
  }

  Future<http.Response> templateGetAll(shopId, pageNum) async {
    var url = Uri(scheme: 'https', host: host, path: '/api/template/getList');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token =
        sharedPreferences.getString('token').toString().replaceAll('"', '');

    final body1 = jsonEncode({
      "shop_id": shopId.toString(),
      "page_num": pageNum,
      "page_size": pageSize
    });
    final header = {
      'Content-Type': 'application/json',
      'authorization': token,
    };
    final response1 = await http.post(url, headers: header, body: body1);

    if (response1.statusCode == 200) {
      var object = jsonDecode(response1.body);
      int totalTemplates = object['data']['total_count'];

      final body2 = jsonEncode({
        "shop_id": shopId.toString(),
        "page_num": 1,
        "page_size": totalTemplates
      });

      final response2 = await http.post(url, headers: header, body: body2);

      return response2;
    } else {
      return response1;
    }
  }

  Future<http.Response> templateGetInfo(shopId, templateId) async {
    var url = Uri(scheme: 'https', host: host, path: '/api/template/getInfo');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token =
        sharedPreferences.getString('token').toString().replaceAll('"', '');

    final body = jsonEncode({
      "shop_id": shopId.toString(),
      "template_id": templateId,
    });
    final header = {
      'Content-Type': 'application/json',
      'authorization': token,
    };
    final response = await http.post(url, headers: header, body: body);

    return response;
  }

  Future<http.Response> templateCreate(
    shopId,
    templateName,
    templateColor,
    templateScreen,
    templateJson,
  ) async {
    var url = Uri(scheme: 'https', host: host, path: '/api/template/create');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token =
        sharedPreferences.getString('token').toString().replaceAll('"', '');

    final body = jsonEncode({
      "shop_id": shopId.toString(),
      "template_name": templateName,
      "template_color": templateColor,
      "template_screen": templateScreen,
      "template_json": templateJson,
    });
    final header = {
      'Content-Type': 'application/json',
      'authorization': token,
    };
    final response = await http.post(url, headers: header, body: body);

    return response;
  }

  Future<http.Response> templateUpdate(
    shopId,
    templateId,
    templateJson,
  ) async {
    var url = Uri(scheme: 'https', host: host, path: '/api/template/update');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token =
        sharedPreferences.getString('token').toString().replaceAll('"', '');

    final body = jsonEncode({
      "shop_id": shopId.toString(),
      "template_id": templateId,
      "template_json": templateJson,
    });
    final header = {
      'Content-Type': 'application/json',
      'authorization': token,
    };
    final response = await http.post(url, headers: header, body: body);

    return response;
  }

  Future<http.Response> templateDelete(shopId, templateIdList) async {
    var url = Uri(scheme: 'https', host: host, path: '/api/template/delete');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token =
        sharedPreferences.getString('token').toString().replaceAll('"', '');

    final body = jsonEncode({
      "shop_id": shopId.toString(),
      "template_id_list": '["$templateIdList"]',
    });
    final header = {
      'Content-Type': 'application/json',
      'authorization': token,
    };
    final response = await http.post(url, headers: header, body: body);

    return response;
  }
}
