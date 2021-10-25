import 'package:tectoyexemplo/pages/LeituraBarCode.dart';
import 'package:tectoyexemplo/pages/barcode.dart';
import 'package:tectoyexemplo/pages/imagem.dart';
import 'package:tectoyexemplo/pages/qrcode.dart';
import 'package:tectoyexemplo/pages/tabela.dart';
import 'package:tectoyexemplo/pages/test_complet.dart';
import 'package:tectoyexemplo/pages/texto.dart';

List<Map> funcoes = [
  {
    "img": "assets/image/function_all.png",
    "name": "Teste Completo",
    "page": TextCompleto(
      title: "Teste Completo",
    )
  },
  {
    "img": "assets/image/function_qr.png",
    "name": "QR Code",
    "page": QrCode(
      title: "QR Code",
    )
  },
  {
    "img": "assets/image/function_barcode.png",
    "name": "Bar Code",
    "page": BarCode(
      title: "Bar Code",
    )
  },
  {
    "img": "assets/image/function_text.png",
    "name": "Texto",
    "page": Texto(
      title: "Texto",
    )
  },
  {
    "img": "assets/image/function_tab.png",
    "name": "Formulário",
    "page": Tabela(
      title: "Teste Completo",
    )
  },
  {
    "img": "assets/image/function_pic.png",
    "name": "Imagem",
    "page": Imagem(
      title: "Imagem",
    )
  },
  {
    "img": "assets/image/scanner_s.png",
    "name": "Leitura BarCode",
    "page": LeituraBarCode(
      title: "Leitura BarCode",
    )
  },
  {
    "img": "assets/image/function_threeline.png",
    "name": "Avança Papel",
    "page": TextCompleto(
      title: "Teste Completo",
    )
  },
  {
    "img": "assets/image/function_cash.png",
    "name": "Gaveta",
    "page": TextCompleto(
      title: "Teste Completo",
    )
  },
  // {
  //   "img": "assets/image/function_lcd.png",
  //   "name": "Lcd",
  //   "page": TextCompleto(
  //     title: "Teste Completo",
  //   )
  // },
  // {
  //   "img": "assets/image/function_status.png",
  //   "name": "Status",
  //   "page": TextCompleto(
  //     title: "Teste Completo",
  //   )
  // },
  // {
  //   "img": "assets/image/function_blackline.png",
  //   "name": "Tarja preta",
  //   "page": TextCompleto(
  //     title: "Teste Completo",
  //   )
  // },
  // {
  //   "img": "assets/image/function_label.png",
  //   "name": "Teste de Etiqueta",
  //   "page": TextCompleto(
  //     title: "Teste Completo",
  //   )
  // },
];
