import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:exemplo_esl/pages/home_page.dart';
import 'package:exemplo_esl/services/api_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  ApiService api = ApiService();
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          "Demo API ETIQUETAS TECTOY",
          style: TextStyle(
            fontSize: 30,
          ),
        ),
      ),
      //Formulário de login
      body: Form(
        key: _formKey,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Column(
              children: [
                //Usuário
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Usuário de acesso ao portal",
                    labelStyle: TextStyle(fontSize: 20),
                  ),
                  validator: (username) {
                    if (username == null || username.isEmpty) {
                      return "Insira seu login";
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(
                  height: 40,
                ),
                //Senha
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Senha de acesso ao portal",
                    labelStyle: TextStyle(fontSize: 20),
                  ),
                  validator: (password) {
                    if (password == null || password.isEmpty) {
                      return "Insira sua senha";
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(
                  height: 40,
                ),
                //Botão
                ElevatedButton(
                  onPressed: login,
                  child: const Text(
                    "Guardar Token de acesso para chamadas api",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Função de login
  void login() async {
    if (context.mounted) {
      FocusScopeNode currentFocus = FocusScope.of(context);
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      if (_formKey.currentState!.validate()) {
        var response =
            await api.login(_usernameController.text, _passwordController.text);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
        if (response.statusCode == 200) {
          await sharedPreferences.setString('token', response.body);
          if (context.mounted) {
            api.requestSuccess(context, "Token consultado com sucesso!");
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          }
        } else {
          _passwordController.clear();
          if (context.mounted) {
            api.requestError(context, response);
          }
        }
      }
    }
  }
}
