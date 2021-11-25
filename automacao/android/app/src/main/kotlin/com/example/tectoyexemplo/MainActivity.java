package com.example.tectoyexemplo;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Matrix;
import android.os.Build;
import android.os.Bundle;
import android.os.PersistableBundle;

import androidx.annotation.NonNull;

import com.google.gson.Gson;

import org.jetbrains.annotations.Nullable;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.text.DateFormat;
import java.util.Date;
import java.util.Map;
import java.util.Random;

import br.com.tectoysunmisdk.tectoysunmisdk.TectoySunmiPrint;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

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
    private final String printonelabel = "printonelabel";
    private final String printmultilabel = "printmultilabel";


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


    private final String sendPicToLcd = "sendPicToLcd";
    private final String sendTextsToLcd = "sendTextsToLcd";
    private final String sendTextToLcd = "sendTextToLcd";
    private final String controlLcd = "controlLcd";


    private final String scanner = "scanner";

    private final String showPrinterStatus = "showPrinterStatus";

    // Variaveis comuns
    private String text = "";
    private int size = 0;
    private int alinhamento = 0;
    private int symbology = 0;
    private int height = 0;
    private int width = 0;
    private int textposition = 0;
    private String texto = "";
    private String data = "";
    private String code = "";
    private static final String TECTOYSDK = "tectoysunmisdk";

    private String valor = "";
    private String usb = "false";
    private String modalidade = "";
    private String parcelas = "";
    private Date dt = new Date();
    private Random r = new Random();
    private String op = String.valueOf(r.nextInt(99999));
    private String currentDateTimeString = DateFormat.getDateInstance().format(new Date());
    private String currentDateTimeStringT = String.valueOf(dt.getHours()) + String.valueOf(dt.getMinutes()) + String.valueOf(dt.getSeconds());
    private String acao = "";
    Gson gson = new Gson();
    private static int REQ_CODE = 4321;
    private final String efetuevenda = "efetuevenda";
    private final String efetuereimpresao = "efetuereimpresao";
    private final String efetuecancelamento = "efetuecancelamento";
    private MethodChannel.Result _result;
    Intent intentSitef = new Intent("br.com.softwareexpress.sitef.msitef.ACTIVITY_CLISITEF");
    private static final String CHANNEL = "samples.flutter.dev/gedi";


    public void onCreate(@Nullable Bundle savedInstanceState, @Nullable PersistableBundle persistentState) {
        super.onCreate(savedInstanceState, persistentState);

    }

    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), TECTOYSDK)
                .setMethodCallHandler((call, result) -> {

                    switch (call.method){
                        case showPrinterStatus:

                            TectoySunmiPrint.getInstance().showPrinterStatus(getApplicationContext());
                            break;
                        case controlLcd:
                            TectoySunmiPrint.getInstance().controlLcd(1);
                            TectoySunmiPrint.getInstance().controlLcd(2);
                            TectoySunmiPrint.getInstance().controlLcd(4);
                            break;
                        case sendTextToLcd:
                            TectoySunmiPrint.getInstance().sendTextToLcd();
                            break;
                        case sendTextsToLcd:
                            TectoySunmiPrint.getInstance().sendTextsToLcd();
                            break;
                        case sendPicToLcd:
                            BitmapFactory.Options options = new BitmapFactory.Options();
                            options.inScaled = false;
                            options.inDensity = getApplicationContext().getResources().getDisplayMetrics().densityDpi;
                            TectoySunmiPrint.getInstance().sendPicToLcd(BitmapFactory.decodeResource(getApplicationContext().getResources(),
                                    br.com.tectoysunmisdk.tectoysunmisdk.R.drawable.mini, options));
                            break;
                        case scanner:
                            break;
                        case printonelabel:
                            texto = call.argument("texto");
                            data = call.argument("data");
                            code = call.argument("code");
                            TectoySunmiPrint.getInstance().printOneLabel(texto, data, code);
                            break;
                        case printmultilabel:
                            texto = call.argument("texto");
                            data = call.argument("data");
                            code = call.argument("code");
                            TectoySunmiPrint.getInstance().printMultiLabel(5, texto, data, code);
                            break;
                        case setInitiServiceTecToySunmiSDK:
                            TectoySunmiPrint.getInstance().initSunmiPrinterService(getApplicationContext());
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
                            BitmapFactory.Options o = new BitmapFactory.Options();
                            o.inTargetDensity = 160;
                            o.inDensity = 160;
                            Bitmap bitmap = BitmapFactory.decodeResource(getApplicationContext().getResources(), br.com.tectoysunmisdk.tectoysunmisdk.R.drawable.test1, o);
                            TectoySunmiPrint.getInstance().printBitmap(scaleImage(bitmap));
                        case getPlatformVersion:
                            result.success("Android " + Build.VERSION.RELEASE);
                            break;
                    }

                });
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler((call, result) -> {
                    _result = result;
                    Map<String, String> map;
                    Bundle bundle = new Bundle();
                    Intent intent = null;
                    switch (call.method){
                        case efetuevenda:
                            acao = "venda";
                            this.valor = call.argument("valor");
                            this.usb = call.argument("usb");
                            this.modalidade = call.argument("modalidade");
                            this.parcelas = call.argument("parcelas");
                            execulteSTefVenda(valor, usb, modalidade, parcelas);
                            break;
                        case  efetuereimpresao:
                            acao = "reimpresao";
                            this.valor = call.argument("valor");
                            execulteSTefReimpressao(valor);
                            break;
                        case efetuecancelamento:
                            acao = "cancelamento";
                            this.valor = call.argument("valor");
                            execulteSTefCancelamento(valor);
                            break;
                    }
                });
    }
    private Bitmap scaleImage(Bitmap bitmap1) {
        int width = bitmap1.getWidth();
        int height = bitmap1.getHeight();
        int newWidth = (width / 8 + 1) * 8;
        float scaleWidth = ((float) newWidth) / width;
        Matrix matrix = new Matrix();
        matrix.postScale(scaleWidth, 1);
        return Bitmap.createBitmap(bitmap1, 0, 0, width, height, matrix, true);
    }

    public void execulteSTefVenda(String valor, String usb, String modalidade, String parcelas) {
       // modalidade = "Não Definido";
        parcelas = "1";
        Intent intentSitef = new Intent("br.com.softwareexpress.sitef.msitef.ACTIVITY_CLISITEF");
        intentSitef.putExtra("empresaSitef", "00000000");
        intentSitef.putExtra("enderecoSitef", "172.17.102.96");
        intentSitef.putExtra("operador", "0001");
        intentSitef.putExtra("data", "20200324");
        intentSitef.putExtra("hora", "130358");
        intentSitef.putExtra("numeroCupom", op);
        intentSitef.putExtra("valor", valor);
        intentSitef.putExtra("CNPJ_CPF", "03654119000176");
        intentSitef.putExtra("comExterna", "0");
        if (usb.equals("true")){
            intentSitef.putExtra("pinpadMac", "00:00:00:00:00:00");
        }
        if(modalidade.equals("Não Definido")){
            intentSitef.putExtra("modalidade", "0");
        } else if (modalidade.equals("Crédito")) {
            intentSitef.putExtra("modalidade", "3");
            if (parcelas.equals("0") || parcelas.equals("1")) {
                intentSitef.putExtra("transacoesHabilitadas", "26");
            } else if (true) {
                // Essa informações habilida o parcelamento Loja
                intentSitef.putExtra("transacoesHabilitadas", "27");
            }
            intentSitef.putExtra("numParcelas", parcelas);
        } else if (modalidade.equals("Debito")) {
            intentSitef.putExtra("modalidade", "2");
            //intentSitef.putExtra("transacoesHabilitadas", "16");
        } else if (modalidade.equals("Carteira Digital")) {
        }
        intentSitef.putExtra("isDoubleValidation", "0");
        intentSitef.putExtra("caminhoCertificadoCA", "ca_cert_perm");

        startActivityForResult(intentSitef, REQ_CODE);
    }
    void execulteSTefReimpressao(String valor) {
        Intent intentSitef = new Intent("br.com.softwareexpress.sitef.msitef.ACTIVITY_CLISITEF");
        intentSitef.putExtra("empresaSitef", "00000000");
        intentSitef.putExtra("enderecoSitef", "172.17.102.96");
        intentSitef.putExtra("operador", "0001");
        intentSitef.putExtra("data", "20200324");
        intentSitef.putExtra("hora", "130358");
        intentSitef.putExtra("numeroCupom", op);
        intentSitef.putExtra("valor", valor);
        intentSitef.putExtra("CNPJ_CPF", "03654119000176");
        intentSitef.putExtra("comExterna", "0");
        intentSitef.putExtra("modalidade", "114");
        intentSitef.putExtra("isDoubleValidation", "0");
        intentSitef.putExtra("caminhoCertificadoCA", "ca_cert_perm");

        startActivityForResult(intentSitef, REQ_CODE);
    }
    void execulteSTefCancelamento(String valor) {
        Intent intentSitef = new Intent("br.com.softwareexpress.sitef.msitef.ACTIVITY_CLISITEF");
        intentSitef.putExtra("empresaSitef", "00000000");
        intentSitef.putExtra("enderecoSitef", "172.17.102.96");
        intentSitef.putExtra("operador", "0001");
        intentSitef.putExtra("data", currentDateTimeString);
        intentSitef.putExtra("hora", currentDateTimeStringT);
        intentSitef.putExtra("numeroCupom", op);
        intentSitef.putExtra("valor", valor);
        intentSitef.putExtra("CNPJ_CPF", "03654119000176");
        intentSitef.putExtra("comExterna", "0");
        intentSitef.putExtra("modalidade", "200");
        intentSitef.putExtra("isDoubleValidation", "0");
        intentSitef.putExtra("caminhoCertificadoCA", "ca_cert_perm");
        startActivityForResult(intentSitef, REQ_CODE);
    }
    @Override
    protected void onActivityResult(int requestCode, int resultCode,Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        RetornoMsiTef retornoSitef = null;
        if (data == null)
            return;

        try {
            retornoSitef = gson.fromJson(respSitefToJson(data), RetornoMsiTef.class);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        if (requestCode == REQ_CODE && resultCode == RESULT_OK) {
            if (retornoSitef.getCodResp().equals("0")) {
                String impressao = "";
                // Verifica se tem algo pra imprimir
                if (!retornoSitef.textoImpressoCliente().isEmpty()) {
                    impressao += retornoSitef.textoImpressoCliente();
                }
                if (!retornoSitef.textoImpressoEstabelecimento().isEmpty()) {
                    impressao += "\n\n-----------------------------     \n";
                    impressao += retornoSitef.textoImpressoEstabelecimento();
                }
                if (!impressao.isEmpty() && acao.equals("reimpressao")) {
                    dialogImpressao(impressao, 17);
                }
            }
            // Verifica se ocorreu um erro durante venda ou cancelamento
            if (acao.equals("venda") || acao.equals("cancelamento")) {
                if (retornoSitef.getCodResp().isEmpty() || !retornoSitef.getCodResp().equals("0") || retornoSitef.getCodResp() == null) {
                    //dialodTransacaoNegadaMsitef(retornoSitef);
                } else {
                    dialodTransacaoAprovadaMsitef(retornoSitef, getApplicationContext());
                }
            }
        } else {
            // ocorreu um erro
            if (acao.equals("venda") || acao.equals("cancelamento")) {
                //dialodTransacaoNegadaMsitef(retornoSitef);
            }
        }
    }

    public String respSitefToJson(Intent data) throws JSONException {
        JSONObject json = new JSONObject();
        json.put("CODRESP", data.getStringExtra("CODRESP"));
        json.put("COMP_DADOS_CONF", data.getStringExtra("COMP_DADOS_CONF"));
        json.put("CODTRANS", data.getStringExtra("CODTRANS"));
        json.put("VLTROCO", data.getStringExtra("VLTROCO"));
        json.put("REDE_AUT", data.getStringExtra("REDE_AUT"));
        json.put("BANDEIRA", data.getStringExtra("BANDEIRA"));
        json.put("NSU_SITEF", data.getStringExtra("NSU_SITEF"));
        json.put("NSU_HOST", data.getStringExtra("NSU_HOST"));
        json.put("COD_AUTORIZACAO", data.getStringExtra("COD_AUTORIZACAO"));
        json.put("NUM_PARC", data.getStringExtra("NUM_PARC"));
        json.put("TIPO_PARC", data.getStringExtra("TIPO_PARC"));
        json.put("VIA_ESTABELECIMENTO", data.getStringExtra("VIA_ESTABELECIMENTO"));
        json.put("VIA_CLIENTE", data.getStringExtra("VIA_CLIENTE"));
        return json.toString();
    }
    private void dialogImpressao(String texto, int size) {
        AlertDialog alertDialog = new AlertDialog.Builder(this).create();
        StringBuilder cupom = new StringBuilder();
        TectoySunmiPrint.getInstance().printText(texto);
    }
    private void dialodTransacaoAprovadaMsitef(RetornoMsiTef retornoMsiTef, Context context) {
        AlertDialog alertDialog = new AlertDialog.Builder(context).create();
        StringBuilder cupom = new StringBuilder();
        StringBuilder teste = new StringBuilder();

        cupom.append("Via Cliente \n" + retornoMsiTef.getVIA_CLIENTE() + "\n");
        teste.append("Via Estabelecimento \n" + retornoMsiTef.getVIA_ESTABELECIMENTO() + "\n");

        alertDialog.setTitle("Ação executada com sucesso");
        alertDialog.setMessage(cupom.toString());
        alertDialog.setButton(AlertDialog.BUTTON_POSITIVE, "OK", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialogInterface, int i) {
                TectoySunmiPrint.getInstance().setSize(26);
                TectoySunmiPrint.getInstance().setAlign(1);
                TectoySunmiPrint.getInstance().printStyleBold(true);
                TectoySunmiPrint.getInstance().printText(cupom.toString());
                TectoySunmiPrint.getInstance().print3Line();

                TectoySunmiPrint.getInstance().feedPaper();
                TectoySunmiPrint.getInstance().printText(teste.toString());
                TectoySunmiPrint.getInstance().print3Line();

                TectoySunmiPrint.getInstance().cutpaper();
            }
        });
        TectoySunmiPrint.getInstance().setSize(26);
        TectoySunmiPrint.getInstance().setAlign(1);
        TectoySunmiPrint.getInstance().printStyleBold(true);
        TectoySunmiPrint.getInstance().printText(cupom.toString());
        TectoySunmiPrint.getInstance().print3Line();

        TectoySunmiPrint.getInstance().feedPaper();
        TectoySunmiPrint.getInstance().printText(teste.toString());
        TectoySunmiPrint.getInstance().print3Line();

        TectoySunmiPrint.getInstance().cutpaper();
        //alertDialog.show();
    }
}
