package br.com.tectoysunmisdk.tectoysunmisdk;

import android.content.Context;

import androidx.annotation.NonNull;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import io.flutter.Log;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** TectoysunmisdkPlugin */
public class TectoysunmisdkPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;

  private Context contextAplication;


  private final String getPlatformVersion = "getPlatformVersion";

  private final String setInitiServiceTecToySunmiSDK = "setInitiServiceTecToySunmiSDK";
  private final String setInitPrint = "setInitPrint";

  // Funções da Impressora

  // Alinhamento
  private  final String setAlignment = "setAlignment";

  // Estilo de impressão
  private final String printStyleBold = "printStyleBold";
  private final String printStyleUnderLine = "printStyleUnderLine";
  private final String printStyleAntiWhite = "printStyleAntiWhite";
  private final String printStyleDoubleHeight = "printStyleDoubleHeight";
  private final String printStyleDoubleWidth = "printStyleDoubleWidth";
  private final String printStyleItalic = "printStyleItalic";
  private final String printStyleInvert = "printStyleInvert";
  private final String printStyleStrikethRough = "printStyleStrikethRough";
  private final String printStyleReset = "printStyleReset";

  // Impressão do TEXTO
  private final String printText = "printText";
  private final String printTextWithSize = "printTextWithSize";

  // Impressão de QrCode
  private final String printQr = "printQr";
  private final String printDoubleQRCode = "printDoubleQRCode";

  // Status Impressora
  private final String printerStatus = "printerStatus";

  // Corta Papel
  private final String cutpaper = "cutpaper";

  // Abre Gaveta
  private final String openCashBox = "openCashBox";

  // Avanço de papel
  private final String feedPaper = "feedPaper";

  // Imprime BarCode
  private final String printBarCode = "printBarCode";

  // Tamanho da fonte
  private final String setFontSize = "setFontSize";

  // Avanca 3 linhas
  private final String print3Line = "print3Line";
  private final String printAdvanceLines = "printAdvanceLines";

  // Imprime uma tabela
  private final String printTable = "printTable";

  // Imprime printBitmap
  private final String printBitmap = "printBitmap";

  // Variaveis comuns
  private String text = "";
  private int size = 0;
  private int alinhamento = 0;
  private int symbology = 0;
  private int height = 0;
  private int width = 0;
  private int textposition = 0;


  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "tectoysunmisdk");
    channel.setMethodCallHandler(this);
    contextAplication = flutterPluginBinding.getApplicationContext();
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {

    Log.d(TectoysunmisdkPlugin.class.getName(), call.method);;

    


    switch (call.method){
      case setInitiServiceTecToySunmiSDK:
        TectoySunmiPrint.getInstance().initSunmiPrinterService(contextAplication);
        break;
      case setInitPrint:
        TectoySunmiPrint.getInstance().initPrinter();
        break;
      case setAlignment:
        alinhamento = call.argument("alinhamento");
        TectoySunmiPrint.getInstance().setAlign(alinhamento);
        break;
      case printStyleBold:
        boolean bold = call.argument("status");
        TectoySunmiPrint.getInstance().printStyleBold(bold);
        break;
      case printStyleUnderLine:
        boolean underline = call.argument("status");
        TectoySunmiPrint.getInstance().printStyleUnderLine(underline);
        break;
      case printStyleAntiWhite:
        boolean antiWhite = call.argument("status");
        TectoySunmiPrint.getInstance().printStyleAntiWhite(antiWhite);
        break;
      case printStyleDoubleHeight:
        boolean DoubleHeight = call.argument("status");
        TectoySunmiPrint.getInstance().printStyleDoubleHeight(DoubleHeight);
        break;
      case printStyleDoubleWidth:
        boolean DoubleWidth = call.argument("status");
        TectoySunmiPrint.getInstance().printStyleDoubleWidth(DoubleWidth);
        break;
      case printStyleItalic:
        boolean Italic = call.argument("status");
        TectoySunmiPrint.getInstance().printStyleItalic(Italic);
        break;
      case printStyleInvert:
        boolean Invert = call.argument("status");
        TectoySunmiPrint.getInstance().printStyleInvert(Invert);
        break;
      case printStyleStrikethRough:
        boolean StrikethRough = call.argument("status");
        TectoySunmiPrint.getInstance().printStyleStrikethRough(StrikethRough);
        break;
      case printStyleReset:
        TectoySunmiPrint.getInstance().printStyleReset();
        break;
      case printText:
        text = call.argument("texto");
        TectoySunmiPrint.getInstance().printText(text);
        break;
      case printTextWithSize:
        text = call.argument("texto");
        size = call.argument("size");
        TectoySunmiPrint.getInstance().printTextWithSize(text, size);
        break;
      case printQr:
        text = call.argument("texto");
        size = call.argument("size");
        int errorLevel = call.argument("errorLevel");
        TectoySunmiPrint.getInstance().printQr(text, size, errorLevel);
        break;
      case printDoubleQRCode:
        text = call.argument("texto");
        String text2 = call.argument("texto");
        size = call.argument("size");
        int errorLevel2 = call.argument("errorLevel");
        TectoySunmiPrint.getInstance().printDoubleQRCode(text, text2, size, errorLevel2);
        break;
      case printerStatus:
        result.success(TectoySunmiPrint.getInstance().printerStatus());
        break;
      case cutpaper:
        TectoySunmiPrint.getInstance().cutpaper();
        break;
      case openCashBox:
        TectoySunmiPrint.getInstance().openCashBox();
        break;
      case feedPaper:
        TectoySunmiPrint.getInstance().feedPaper();
        break;
      case printBarCode:
        text = call.argument("texto");
        symbology = call.argument("symbology");
        height = call.argument("height");
        width = call.argument("width");
        textposition = call.argument("textposition");
        TectoySunmiPrint.getInstance().printBarCode(text, symbology, height, width, textposition);
        break;
      case setFontSize:
        size = call.argument("size");
        TectoySunmiPrint.getInstance().setSize(size);
        break;
      case print3Line:
        TectoySunmiPrint.getInstance().print3Line();
        break;
      case printAdvanceLines:
        int lines = call.argument("lines");
        TectoySunmiPrint.getInstance().printAdvanceLines(lines);
        break;
      case printTable:
        String Json = call.argument("json");
        try {
          JSONObject jsonObject = new JSONObject(Json);
          JSONArray c = jsonObject.getJSONArray("lines");
          for(int i =0; i < c.length(); i++){
            JSONObject obj = c.getJSONObject(i);
            JSONArray txts = obj.getJSONArray("txts");
            JSONArray width = obj.getJSONArray("width");
            JSONArray align = obj.getJSONArray("align");

            String[] text_vetor = new String[txts.length()];
            int[] width_vetor = new int[width.length()];
            int[] align_vetor = new int[align.length()];

            for(int text_index = 0; text_index < txts.length(); text_index++){
              text_vetor[text_index] = String.valueOf(txts.get(text_index));
            }

            for(int text_index = 0; text_index < width.length(); text_index++){
              width_vetor[text_index] = (int) width.get(text_index);
            }

            for(int text_index = 0; text_index < align.length(); text_index++){
              align_vetor[text_index] = (int) align.get(text_index);
            }

            TectoySunmiPrint.getInstance().printTable(text_vetor, width_vetor, align_vetor);

          }
        } catch (JSONException e) {
          e.printStackTrace();
        }
        TectoySunmiPrint.getInstance().printTable(null, null, null);
        break;
      case printBitmap:
        // Todo
        result.success("Tem que implementar ainda  " + android.os.Build.VERSION.RELEASE);
      case getPlatformVersion:
        result.success("Android " + android.os.Build.VERSION.RELEASE);
        break;
    }

  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
