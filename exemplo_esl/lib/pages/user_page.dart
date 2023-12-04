import 'dart:convert';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:exemplo_esl/services/api_service.dart';
import 'package:exemplo_esl/pages/start_page.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});
  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  ApiService api = ApiService();
  Map<String, dynamic> userObject = {};
  bool finished = false;
  bool gotInfo = false;
  String company = '';
  String branch = '';

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return finished
        ? Visibility(
            visible: gotInfo,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Nome: ${userObject['name']}",
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  "Usuário: ${userObject['username']}",
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  "Email: ${userObject['email']}",
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  "Cargo: ${translateLevel(userObject['level'])}",
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                Visibility(
                  visible: userObject['level'] != 1,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Empresa: $company",
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: userObject['level'] != 1,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Filial: $branch",
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: logout,
                  child: const Text(
                    "Sair",
                  ),
                ),
              ],
            ),
          )
        : const CircularProgressIndicator();
  }

//Usuário
  void logout() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove('token');
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const StartPage(),
        ),
      );
    }
  }

  void getUserInfo() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString('token').toString();
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    http.Response userResponse =
        await api.userGetInfo(decodedToken['userEmail']);

    if (userResponse.statusCode == 200) {
      var object = jsonDecode(userResponse.body);
      if (object['level'] != 1) {
        http.Response companyResponse =
            await api.companyGetInfo(object['company_id']);
        if (companyResponse.statusCode == 200) {
          http.Response branchResponse =
              await api.branchGetInfo(object['branch_id']);
          if (branchResponse.statusCode == 200) {
            setState(() {
              company = jsonDecode(companyResponse.body)['name'];
              branch = jsonDecode(branchResponse.body)['name'];
            });
          } else {
            if (context.mounted) {
              api.requestError(context, branchResponse);
            }
          }
        } else {
          if (context.mounted) {
            api.requestError(context, companyResponse);
          }
        }
      }
      setState(() {
        finished = true;
        gotInfo = true;
        userObject = object;
      });
    } else {
      if (context.mounted) {
        api.requestError(context, userResponse);
      }
      setState(() {
        finished = true;
        gotInfo = false;
      });
    }
  }

  String translateLevel(string) {
    var level = "";
    string == 1
        ? level = "Usuário master"
        : string == 2
            ? level = "Admin da empresa"
            : string == 3
                ? level = "Gerente"
                : string == 4
                    ? level = "Supervisor"
                    : level = "Funcionário";
    return level;
  }
}
