import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_svg/svg.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exemplo TTS',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Exemplo TTS'),
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
  final FlutterTts flutterTts = FlutterTts();

  final textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(
            widget.title,
            style: const TextStyle(
              fontSize: 40,
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 35),
            Image.asset(
              'assets/images/tectoy.png',
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(40),
                    child: Column(
                      children: [
                        Text(
                          'Para que o K2 consiga utlizar a voz em português:',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text.rich(
                          TextSpan(
                            text: "- Faça o download do aplicativo",
                            style: TextStyle(fontSize: 30),
                            children: [
                              TextSpan(
                                text: " RHVoice",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: " na Play Store"),
                            ],
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            text: "- No aplicativo selecione",
                            style: TextStyle(fontSize: 30),
                            children: [
                              TextSpan(
                                text: " português (Brasil)",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: " e faça o download da voz"),
                              TextSpan(
                                text: " Letícia-F123",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text.rich(
                          TextSpan(
                            text:
                                "- Nas configurações do totem clique na opção",
                            style: TextStyle(fontSize: 30),
                            children: [
                              TextSpan(
                                text: " Idiomas e entrada",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text.rich(
                          TextSpan(
                            text: "- Selecione",
                            style: TextStyle(fontSize: 30),
                            children: [
                              TextSpan(
                                text: " Conversão de texto em voz",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            text: "- Em",
                            style: TextStyle(fontSize: 30),
                            children: [
                              TextSpan(
                                text: " Mecanismo preferencial",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: " selecione",
                              ),
                              TextSpan(
                                text: " RHVoice",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            text:
                                "- Para testar se a voz foi instalada com sucesso clique em",
                            style: TextStyle(fontSize: 30),
                            children: [
                              TextSpan(
                                text: " Ouça um exemplo",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  const Text(
                    'Digite abaixo o que deseja que o TTS leia:',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 40,
                      right: 40,
                      top: 20,
                      bottom: 20,
                    ),
                    child: TextField(
                      style: const TextStyle(fontSize: 20),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Texto para leitura",
                        labelStyle: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      controller: textController,
                    ),
                  ),
                  ElevatedButton(
                      onPressed: speakTts,
                      child: const Text(
                        "Clique aqui para ler o texto",
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      )),
                ],
              ),
            ),
            const Text(
              "Desenvolvido por:",
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SvgPicture.asset(
              'assets/images/logo_white.svg',
              width: 300,
            ),
            const SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }

  void speakTts() async {
    if (textController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Digite algo para ser lido",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 40);
    } else {
      await flutterTts.speak(textController.text);
    }
  }
}
