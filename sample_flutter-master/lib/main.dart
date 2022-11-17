// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Itfast',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Itfast'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const platform = const MethodChannel("com.flutter.it4r/it4r");

  String fullText = "";
  void _incrementText(text) {
    setState(() {
      fullText = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 200,
                height: 100,
                child: Image.asset('assets/images/itfast.png'),
              ),
              const SizedBox(
                height: 30,
              ),
              TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal)),
                    labelText: 'Texto para impressão...',
                  ),
                  onChanged: (value) => _incrementText(value)),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: Printy,
                child: const Text(
                  'Imprimir',
                  style: TextStyle(fontSize: 24),
                ),
              ),
              const SizedBox(
                height: 200,
              ),
              SizedBox(
                width: 200,
                height: 100,
                child: Image.asset('assets/images/tecToy.png'),
              )
            ],
          ),
        ),
      ),
    );
  }

  void Printy() async {
    String value = "";
    try {
      value = await platform.invokeMethod("Printy", {"arguments": fullText});
    } catch (e) {
      print(e);
    }
    print('Retorno da impressão: ' + value);
  }
}
