package com.exemple.paygosdk.paygosdk;

import android.content.Context;

import android.os.Build;
import android.os.Environment;
import android.os.Handler;
import android.widget.Toast;

import androidx.annotation.NonNull;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.File;
import java.text.ParseException;
import java.text.SimpleDateFormat;

import br.com.setis.interfaceautomacao.AplicacaoNaoInstaladaExcecao;
import br.com.setis.interfaceautomacao.Cartoes;
import br.com.setis.interfaceautomacao.Confirmacoes;
import br.com.setis.interfaceautomacao.DadosAutomacao;
import br.com.setis.interfaceautomacao.EntradaTransacao;
import br.com.setis.interfaceautomacao.Financiamentos;
import br.com.setis.interfaceautomacao.Operacoes;
import br.com.setis.interfaceautomacao.Personalizacao;
import br.com.setis.interfaceautomacao.QuedaConexaoTerminalExcecao;
import br.com.setis.interfaceautomacao.SaidaTransacao;
import br.com.setis.interfaceautomacao.StatusTransacao;
import br.com.setis.interfaceautomacao.TerminalNaoConfiguradoExcecao;
import br.com.setis.interfaceautomacao.Transacoes;
import io.flutter.Log;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import static br.com.setis.interfaceautomacao.ModalidadesPagamento.*;

/**
 * PaygosdkPlugin
 */
public class PaygosdkPlugin implements FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private static final String DEBUG_TAG = PaygosdkPlugin.class.getName();

    private MethodChannel channel;
    private Result resultGlobal;
    private Context ctx;

    private final String getPlatformVersion = "getPlatformVersion";
    private final String setOperacao = "setOperacao";
    private final String setConfirmaOperacaoAutomacica = "setConfirmaOperacaoAutomacica";
    private final String setConfirmaOperacaoPendenteManual = "setConfirmaOperacaoPendenteManual";
    private final String setConfirmaOperacaoManual = "setConfirmaOperacaoManual";

    private final String setDesafazOperacaoManual = "setDesafazOperacaoManual";
    private final String setDesafazOperacaoPendente = "setDesafazOperacaoPendente";

    private Confirmacoes mConfirmacao = new Confirmacoes();
    private DadosAutomacao mDadosAutomacao = null;
    private Personalizacao mPersonalizacao;
    private Transacoes mTransacoes = null;
    private SaidaTransacao mSaidaTransacao;
    private EntradaTransacao mEntradaTransacao;

    private static Handler mHandler = new Handler();

    private SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

    private String identificacaoAutomacao;

    // Dados da Automação
    private String empresaAutomacao = "";
    private String nomeAutomacao = "";
    private String versaoAutomacao = "";

    // Operação
    private int parcelas = 0;
    private String valorOperacao;
    private String adquirente;
    private int modalidadePagamento;
    private int tipoCartao;
    private int tipoFinanciamento;
    // Operação Cancelamento
    private String nsu;
    private String dataOperacao;
    private String codigoAutorizacao;

    // Configurações
    private boolean confirmacaoManual = false;
    private boolean viaLojaCliente = false;
    private boolean viaCompleta = false;
    private boolean interfaceAlternativa = false;

    private boolean suportaTroco = false;
    private boolean suportaDesconto = false;

    // Interface
    private String fileIconDestino = "";
    private String fileFonteDestino = "";
    private String informaCorFonte = "";
    private String informaCorFonteTeclado = "";
    private String informaCorFundoCaixaEdicao = "";
    private String informaCorFundoTela = "";
    private String informaCorFundoTeclado = "";
    private String informaCorFundoToolbar = "";
    private String informaCorTextoCaixaEdicao = "";
    private String informaCorTeclaPressionadaTeclado = "";
    private String informaCorTeclaLiberadaTeclado = "";
    private String informaCorSeparadorMenu = "";

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "paygosdk");
        channel.setMethodCallHandler(this);
        ctx = flutterPluginBinding.getApplicationContext();
    }

    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "paygosdk");
        channel.setMethodCallHandler(new PaygosdkPlugin());
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {

        resultGlobal = result;

        switch (call.method) {
            case getPlatformVersion:
                result.success("Android " + Build.VERSION.RELEASE);
                break;

            case setOperacao:
                Log.d(DEBUG_TAG, call.arguments.toString());


                // ID Operacao
                this.identificacaoAutomacao = call.argument("numeroOperacao");

                // Dados da Automação
                this.empresaAutomacao = call.argument("empresaAutomacao");
                this.nomeAutomacao = call.argument("nomeAutomacao");
                this.versaoAutomacao = call.argument("versaoAutomacao");

                this.parcelas = Integer.parseInt(call.argument("parcelas"));
                this.valorOperacao = call.argument("valorOperacao");
                this.adquirente = call.argument("adquirente");
                this.modalidadePagamento = Integer.parseInt(call.argument("modalidadePagamento"));
                this.tipoCartao = Integer.parseInt(call.argument("tipoCartao"));
                this.tipoFinanciamento = Integer.parseInt(call.argument("tipoFinanciamento"));

                // Operação Cancelamento
                this.nsu = call.argument("nsu");
                this.dataOperacao = call.argument("dataOperacao");
                this.codigoAutorizacao = call.argument("codigoAutorizacao");

                this.confirmacaoManual = Boolean.parseBoolean(call.argument("confirmacaoManual"));
                this.viaLojaCliente = Boolean.parseBoolean(call.argument("viaLojaCliente"));
                this.viaCompleta = Boolean.parseBoolean(call.argument("viaCompleta"));
                this.interfaceAlternativa = Boolean.parseBoolean(call.argument("interfaceAlternativa"));

                this.suportaTroco = Boolean.parseBoolean(call.argument("codigoAutorizacao"));
                this.suportaDesconto = Boolean.parseBoolean(call.argument("codigoAutorizacao"));

                // this.fileIconDestino = call.argument("fileIconDestino");
                // this.fileFonteDestino = call.argument("fileFonteDestino");
                this.informaCorFonte = call.argument("informaCorFonte");
                this.informaCorFonteTeclado = call.argument("informaCorFonteTeclado");
                this.informaCorFundoCaixaEdicao = call.argument("informaCorFundoCaixaEdicao");
                this.informaCorFundoTela = call.argument("informaCorFundoTela");
                this.informaCorFundoTeclado = call.argument("informaCorFundoTeclado");
                this.informaCorFundoToolbar = call.argument("informaCorFundoToolbar");
                this.informaCorTextoCaixaEdicao = call.argument("informaCorTextoCaixaEdicao");
                this.informaCorTeclaPressionadaTeclado = call.argument("informaCorTeclaPressionadaTeclado");
                this.informaCorTeclaLiberadaTeclado = call.argument("informaCorTeclaLiberadaTeclado");
                this.informaCorSeparadorMenu = call.argument("informaCorSeparadorMenu");

                efetuaOperacao(Operacoes.obtemOperacao(Integer.parseInt(call.argument("operacao"))));
                break;

            case setConfirmaOperacaoAutomacica:
                confirmaOperacaoAutomatico();
                break;

            case setConfirmaOperacaoManual:
                confirmaOperacaoManual();
                break;

            case setDesafazOperacaoManual:
                desfazOperacaoManual();
                break;
            case setConfirmaOperacaoPendenteManual:
                confirmaOperacaoPendenteManual();
                break;

            case setDesafazOperacaoPendente:
                desfazOperacaoPendente();
                break;

            default:
                throw new IllegalStateException("Unexpected value: " + call.method);
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    private void iniPayGoInterface() {

        mPersonalizacao = setPersonalizacao(this.interfaceAlternativa);

        mDadosAutomacao = new DadosAutomacao(this.empresaAutomacao, this.nomeAutomacao, this.versaoAutomacao,
                this.suportaTroco, this.suportaDesconto, this.viaLojaCliente, this.viaCompleta, mPersonalizacao);

        mTransacoes = Transacoes.obtemInstancia(mDadosAutomacao, ctx);

    }

    private Personalizacao setPersonalizacao(boolean isInverse) {

        Personalizacao.Builder pb = new Personalizacao.Builder();

        try {
            if (isInverse) {
                // File iconeToolBar = file; // new File(this.fileIconDestino);
                // pb.informaFonte(new File(this.fileFonteDestino));
                // pb.informaIconeToolbar(iconeToolBar);
                pb.informaCorFonte(this.informaCorFonte);
                pb.informaCorFonteTeclado(this.informaCorFonteTeclado);
                pb.informaCorFundoCaixaEdicao(this.informaCorFundoCaixaEdicao);
                pb.informaCorFundoTela(this.informaCorFundoTela);
                pb.informaCorFundoTeclado(this.informaCorFundoTeclado);
                pb.informaCorFundoToolbar(this.informaCorFundoToolbar);
                pb.informaCorTextoCaixaEdicao(this.informaCorTextoCaixaEdicao);
                pb.informaCorTeclaPressionadaTeclado(this.informaCorTeclaPressionadaTeclado);
                pb.informaCorTeclaLiberadaTeclado(this.informaCorTeclaLiberadaTeclado);
                pb.informaCorSeparadorMenu(this.informaCorSeparadorMenu);
            }
        } catch (IllegalArgumentException e) {
            Toast.makeText(ctx, "Verifique valores de\nconfiguração", Toast.LENGTH_SHORT).show();
        }

        return pb.build();
    }

    private void efetuaOperacao(Operacoes operacoes) {

        iniPayGoInterface();

        mEntradaTransacao = new EntradaTransacao(operacoes, this.identificacaoAutomacao);

        if (operacoes == Operacoes.VENDA) {
            mEntradaTransacao.informaDocumentoFiscal(String.valueOf(this.identificacaoAutomacao));
            mEntradaTransacao.informaValorTotal(this.valorOperacao);
        }

        if (operacoes == Operacoes.CANCELAMENTO) {
            mEntradaTransacao.informaNsuTransacaoOriginal(this.nsu);
            mEntradaTransacao.informaCodigoAutorizacaoOriginal(this.codigoAutorizacao);
            try {
                mEntradaTransacao.informaDataHoraTransacaoOriginal(this.dateFormat.parse(this.dataOperacao));
            } catch (ParseException e) {
                e.printStackTrace();
                resultGlobal.error(String.valueOf(e.getErrorOffset()), e.getMessage(), e.fillInStackTrace());
            }
            //Informa novamente o valor para realizar a operação de cancelamento
            mEntradaTransacao.informaValorTotal(this.valorOperacao);
        }

        // Define a modalidade de Pagamento
        switch (this.modalidadePagamento) {
            case 0: // ModalidadesPagamento.PAGAMENTO_CARTAO:
                mEntradaTransacao.informaModalidadePagamento(PAGAMENTO_CARTAO);
                break;
            case 1: // ModalidadesPagamento.PAGAMENTO_DINHEIRO:
                mEntradaTransacao.informaModalidadePagamento(PAGAMENTO_DINHEIRO);
                break;
            case 2: // ModalidadesPagamento.PAGAMENTO_CHEQUE:
                mEntradaTransacao.informaModalidadePagamento(PAGAMENTO_CHEQUE);
                break;
            case 3: // ModalidadesPagamento.PAGAMENTO_CARTAO:
                mEntradaTransacao.informaModalidadePagamento(PAGAMENTO_CARTEIRA_VIRTUAL);
                break;
        }

        // Define a Cartão
        mEntradaTransacao.informaTipoCartao(Cartoes.obtemCartao(this.tipoCartao));

        // Defini o tipo de Financiamento
        mEntradaTransacao.informaTipoFinanciamento(Financiamentos.obtemFinanciamento(this.tipoFinanciamento));

        // Informa a quantidade de Parcelas
        if (Financiamentos.obtemFinanciamento(this.tipoFinanciamento).equals(Financiamentos.PARCELADO_EMISSOR)) {
            mEntradaTransacao.informaNumeroParcelas(this.parcelas);
        } else if (Financiamentos.obtemFinanciamento(this.tipoFinanciamento).equals(Financiamentos.PARCELADO_ESTABELECIMENTO)) {
            mEntradaTransacao.informaNumeroParcelas(this.parcelas);
        }

        // Informa o adquirente que vai transacionar
        if (!this.adquirente.equals("PROVEDOR DESCONHECIDO")) {
            mEntradaTransacao.informaNomeProvedor(this.adquirente);
        }

        mEntradaTransacao.informaCodigoMoeda("986"); // Real

        mConfirmacao = new Confirmacoes();

        new Thread(() -> {
            try {
                mDadosAutomacao.obtemPersonalizacaoCliente();
                mSaidaTransacao = mTransacoes.realizaTransacao(mEntradaTransacao);

                if (mSaidaTransacao == null)
                    return;

                mConfirmacao
                        .informaIdentificadorConfirmacaoTransacao(
                                mSaidaTransacao.obtemIdentificadorConfirmacaoTransacao()
                        );

            } catch (QuedaConexaoTerminalExcecao e) {
                e.printStackTrace();
                resultGlobal.error(String.valueOf(mSaidaTransacao.obtemResultadoTransacao()), e.getMessage(), e.fillInStackTrace());

            } catch (TerminalNaoConfiguradoExcecao terminalNaoConfiguradoExcecao) {
                terminalNaoConfiguradoExcecao.printStackTrace();
                resultGlobal.error(String.valueOf(mSaidaTransacao.obtemResultadoTransacao()), terminalNaoConfiguradoExcecao.getMessage(), terminalNaoConfiguradoExcecao.fillInStackTrace());

            } catch (AplicacaoNaoInstaladaExcecao aplicacaoNaoInstaladaExcecao) {
                aplicacaoNaoInstaladaExcecao.printStackTrace();
                resultGlobal.error(String.valueOf(mSaidaTransacao.obtemResultadoTransacao()), aplicacaoNaoInstaladaExcecao.getMessage(), aplicacaoNaoInstaladaExcecao.fillInStackTrace());

            } finally {
                mEntradaTransacao = null;
                mHandler.post(resultadoOperacacao);
            }
        }).start();

    }

    private final Runnable resultadoOperacacao = new Runnable() {
        @Override
        public void run() {
            int resultado = (mSaidaTransacao != null ?
                    mSaidaTransacao.obtemResultadoTransacao() : -999999);
            traduzResultadoOperacao(resultado);
        }
    };

    private void traduzResultadoOperacao(int resultado) {

        JSONObject json = new JSONObject();

        try {

            json.put("result", resultado);
            json.put("informacaoConfirmacao", mSaidaTransacao.obtemInformacaoConfirmacao());
            json.put("existeTransacaoPendente", mSaidaTransacao.existeTransacaoPendente());
            json.put("mensagemRetorno", (mSaidaTransacao != null ? mSaidaTransacao.obtemMensagemResultado() : ""));

            json.put("nsu", mSaidaTransacao.obtemNsuHost());
            json.put("codigoAutorizacao", mSaidaTransacao.obtemCodigoAutorizacao());
            json.put("dataOperacao", (mSaidaTransacao.obtemDataHoraTransacao() != null ? dateFormat.format(mSaidaTransacao.obtemDataHoraTransacao()) : ""));

            json.put("idcartao", (mSaidaTransacao.obtemAidCartao() != null ? mSaidaTransacao.obtemAidCartao() : ""));

            json.put("nomePortadorCartao", (mSaidaTransacao.obtemNomePortadorCartao() != null ? mSaidaTransacao.obtemNomePortadorCartao() : ""));
            json.put("nomeCartaoPadrao", (mSaidaTransacao.obtemNomeCartaoPadrao() != null ? mSaidaTransacao.obtemNomeCartaoPadrao() : ""));
            json.put("nomeEstabelecimento", (mSaidaTransacao.obtemNomeEstabelecimento() != null ? mSaidaTransacao.obtemNomeEstabelecimento() : ""));

            json.put("panMascarPadrao", (mSaidaTransacao.obtemPanMascaradoPadrao() != null ? mSaidaTransacao.obtemPanMascaradoPadrao() : ""));
            json.put("panMascarado", (mSaidaTransacao.obtemPanMascarado() != null ? mSaidaTransacao.obtemPanMascarado() : ""));

            json.put("identificadorConfirmacaoTransacao", (mSaidaTransacao.obtemIdentificadorConfirmacaoTransacao() != null ? mSaidaTransacao.obtemIdentificadorConfirmacaoTransacao() : ""));

            json.put("nsuLocalOriginal", (mSaidaTransacao.obtemNsuLocalOriginal() != null ? mSaidaTransacao.obtemNsuLocalOriginal() : ""));
            json.put("nsuLocal", (mSaidaTransacao.obtemNsuLocal() != null ? mSaidaTransacao.obtemNsuLocal() : ""));
            json.put("nsuHost", (mSaidaTransacao.obtemNsuHost() != null ? mSaidaTransacao.obtemNsuHost() : ""));

            json.put("nomeCartao", (mSaidaTransacao.obtemNomeCartao() != null ? mSaidaTransacao.obtemNomeCartao() : ""));
            json.put("nomeProvedor", (mSaidaTransacao.obtemNomeProvedor() != null ? mSaidaTransacao.obtemNomeProvedor() : ""));

            json.put("modoVerificacaoSenha", (mSaidaTransacao.obtemModoVerificacaoSenha() != null ? mSaidaTransacao.obtemModoVerificacaoSenha() : "")); // Falta

            json.put("codigoAutorizacao", (mSaidaTransacao.obtemCodigoAutorizacao() != null ? mSaidaTransacao.obtemCodigoAutorizacao() : ""));
            json.put("codigoAutorizacaoOriginal", (mSaidaTransacao.obtemCodigoAutorizacaoOriginal() != null ? mSaidaTransacao.obtemCodigoAutorizacaoOriginal() : ""));
            json.put("pontoCaptura", (mSaidaTransacao.obtemIdentificadorPontoCaptura() != null ? mSaidaTransacao.obtemIdentificadorPontoCaptura() : ""));

            json.put("valorOperacao", (mSaidaTransacao.obtemValorTotal() != null ? mSaidaTransacao.obtemValorTotal() : ""));
            json.put("saldoVoucher", (mSaidaTransacao.obtemSaldoVoucher() != null ? mSaidaTransacao.obtemSaldoVoucher() : ""));

            json = trataComprovante(json);

        } catch (JSONException e) {
            e.printStackTrace();
        }

        Log.d(DEBUG_TAG, json.toString());
        resultGlobal.success(json.toString());
    }

    private JSONObject trataComprovante(JSONObject json) throws JSONException {

        String cupom = "";

        if (mSaidaTransacao.obtemComprovanteDiferenciadoPortador() != null) {
            for (String linha : mSaidaTransacao.obtemComprovanteDiferenciadoPortador()) {
                cupom += linha;
            }
        }
        json.put("via_cliente", cupom);

        cupom = "";
        if (mSaidaTransacao.obtemComprovanteDiferenciadoLoja() != null) {
            for (String linha : mSaidaTransacao.obtemComprovanteDiferenciadoLoja()) {
                cupom += linha;
            }
        }
        json.put("via_estavelecimento", cupom);

        cupom = "";
        if (mSaidaTransacao.obtemComprovanteCompleto() != null) {
            for (String linha : mSaidaTransacao.obtemComprovanteCompleto()) {
                cupom += linha;
            }
        }
        json.put("via_cupom_full", cupom);

        return json;

    }

    private void confirmaOperacaoAutomatico() {
        JSONObject json = new JSONObject();
        try {
            Log.d(DEBUG_TAG, "Transação confirmação Automatica.");
            json.put("result", 0);
            mConfirmacao.informaStatusTransacao(StatusTransacao.CONFIRMADO_AUTOMATICO);
            mTransacoes.confirmaTransacao(mConfirmacao);
            resultGlobal.success(json.toString());
        } catch (JSONException e) {
            e.printStackTrace();
            resultGlobal.error(String.valueOf(e.hashCode()), e.getMessage(), e.fillInStackTrace());
        }
    }

    private void desfazOperacaoManual() {
        JSONObject json = new JSONObject();
        try {
            json.put("result", 0);
            Log.d(DEBUG_TAG, "Transação desfeita de forma MANUAL.");
            mConfirmacao.informaStatusTransacao(StatusTransacao.DESFEITO_MANUAL);
            mTransacoes.confirmaTransacao(mConfirmacao);
            resultGlobal.success(json.toString());
        } catch (JSONException e) {
            e.printStackTrace();
            resultGlobal.error(String.valueOf(e.hashCode()), e.getMessage(), e.fillInStackTrace());
        }

    }

    private void confirmaOperacaoManual() {
        JSONObject json = new JSONObject();
        try {
            json.put("result", 0);
            Log.d(DEBUG_TAG, "Transação confirmada de forma MANUAL.");
            mConfirmacao.informaStatusTransacao(StatusTransacao.CONFIRMADO_MANUAL);
            mTransacoes.confirmaTransacao(mConfirmacao);
            resultGlobal.success(json.toString());
        } catch (JSONException e) {
            e.printStackTrace();
            resultGlobal.error(String.valueOf(e.hashCode()), e.getMessage(), e.fillInStackTrace());
        }

    }

    private void confirmaOperacaoPendenteManual() {
        JSONObject json = new JSONObject();
        try {
            json.put("result", 0);
            Log.d(DEBUG_TAG, "Transação confirmada de forma MANUAL.");
            mConfirmacao = new Confirmacoes();
            mConfirmacao.informaStatusTransacao(StatusTransacao.CONFIRMADO_AUTOMATICO);
            mTransacoes.confirmaTransacao(mConfirmacao);
            resultGlobal.success(json.toString());
        } catch (JSONException e) {
            e.printStackTrace();
            resultGlobal.error(String.valueOf(e.hashCode()), e.getMessage(), e.fillInStackTrace());
        }
    }

    private void desfazOperacaoPendente() {
        JSONObject json = new JSONObject();
        try {
            json.put("result", 0);
            Log.d(DEBUG_TAG, "Transação Pendente foi DESFEITO_ERRO_IMPRESSAO_AUTOMATICO.");
            mConfirmacao.informaStatusTransacao(StatusTransacao.DESFEITO_ERRO_IMPRESSAO_AUTOMATICO);
            mTransacoes.confirmaTransacao(mConfirmacao);
            resultGlobal.success(json.toString());
        } catch (JSONException e) {
            e.printStackTrace();
            resultGlobal.error(String.valueOf(e.hashCode()), e.getMessage(), e.fillInStackTrace());
        }

    }
}
