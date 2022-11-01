import 'package:tectoyexemplo/pages/LeituraBarCode.dart';
import 'package:tectoyexemplo/pages/barcode.dart';
import 'package:tectoyexemplo/pages/imagem.dart';
import 'package:tectoyexemplo/pages/klamp.dart';
import 'package:tectoyexemplo/pages/label.dart';
import 'package:tectoyexemplo/pages/lcd.dart';
import 'package:tectoyexemplo/pages/msitef_activit.dart';
import 'package:tectoyexemplo/pages/paygo_activity.dart';
import 'package:tectoyexemplo/pages/qrcode.dart';
import 'package:tectoyexemplo/pages/scannerp2.dart';
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
      title: "Formulario",
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
    "img": "assets/image/function_threeline.png",
    "name": "Avança Papel",
    "page": TextCompleto(
      title: "Avanço Papel",
    )
  },
  {
    "img": "assets/image/function_cash.png",
    "name": "Gaveta",
    "page": TextCompleto(
      title: "Gaveta",
    )
  },
  {
    "img": "assets/image/function_lcd.png",
    "name": "Lcd",
    "page": Lcd(
      title: "LCD",
    )
  },
  {
    "img": "assets/image/function_status.png",
    "name": "Status",
    "page": TextCompleto(
      title: "Status",
    )
  },
  {
    "img": "assets/image/function_blackline.png",
    "name": "Tarja preta",
    "page": TextCompleto(
      title: "Tarja Preta",
    )
  },
  {
    "img": "assets/image/function_label.png",
    "name": "Teste de Etiqueta",
    "page": Label(
      title: "Teste de Etiqueta",
    )
  },
  {
    "img": "assets/image/function_cortar.png",
    "name": "Cortar Papel",
    "page": TextCompleto(
      title: "Cortar Papel",
    )
  },
  {
    "img": "assets/image/scanner_s.png",
    "name": "Scanner",
    "page": LeituraBarCode(
      title: "Scanner",
    )
  },
  {
    "img": "assets/image/function_led.png",
    "name": "LED",
    "page": Klamp(
      title: "LED",
    )
  },
  {
    "img": "assets/image/function_payment.png",
    "name": "Paygo",
    "page": Paygo_activity(
      title: "PayGo",
    )
  },
  {
    "img": "assets/image/scanner_s.png",
    "name": "Scanner Device",
    "page": Scannerp2(
      title: "Scanner Device",
    )
  },
  {
    "img": "assets/image/function_payment.png",
    "name": "Msitef",
    "page": Msitef_activit(
      title: "Msitef",
    )
  },
];
