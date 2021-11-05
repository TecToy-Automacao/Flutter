import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class Paygosdk {
  static const MethodChannel _channel = const MethodChannel('paygosdk');

  // CONST TIPO PAGAMENTO = ModalidadesPagamento
  static const PAGAMENTO_CARTAO = '0';
  static const PAGAMENTO_DINHEIRO = '1';
  static const PAGAMENTO_CHEQUE = '2';
  static const PAGAMENTO_CARTEIRA_VIRTUAL = '3';

  // CONST TIPO CARTÃO
  static const CARTAO_DESCONHECIDO = '0';
  static const CARTAO_CREDITO = '1';
  static const CARTAO_DEBITO = '2';
  static const CARTAO_VOUCHER = '3';
  static const CARTAO_PRIVATELABEL = '4';
  static const CARTAO_FROTA = '5';

  // CONST TIPO PARCELAMENTO = Financiamentos
  static const String FINANCIAMENTO_NAO_DEFINIDO = '0';
  static const String A_VISTA = '1';
  static const String PARCELADO_EMISSOR = '2';
  static const String PARCELADO_ESTABELECIMENTO = '3';
  static const String PRE_DATADO = '4';
  static const String CREDITO_EMISSOR = '5';

  // CONST TIPO OPERACAO
  static const String OPERACAO_DESCONHECIDA = '0';
  static const String VENDA = '1';
  static const String ADMINISTRATIVA = '2';
  static const String FECHAMENTO = '3';
  static const String CANCELAMENTO = '4';
  static const String PREAUTORIZACAO = '5';
  static const String CONSULTA_SALDO = '6';
  static const String CONSULTA_CHEQUE = '7';
  static const String GARANTIA_CHEQUE = '8';
  static const String CANCELAMENTO_PREAUTORIZACAO = '9';
  static const String SAQUE = '10';
  static const String DOACAO = '11';
  static const String PAGAMENTO_CONTA = '12';
  static const String CANCELAMENTO_PAGAMENTOCONTA = '13';
  static const String RECARGA_CELULAR = '14';
  static const String INSTALACAO = '15';
  static const String REIMPRESSAO = '16';
  static const String RELATORIO_SINTETICO = '17';
  static const String RELATORIO_DETALHADO = '18';
  static const String TESTE_COMUNICACAO = '19';
  static const String RELATORIO_RESUMIDO = '20';
  static const String EXIBE_PDC = '21';
  static const String VERSAO = '22';
  static const String CONFIGURACAO = '23';
  static const String MANUTENCAO = '24';

  int result = 0;
  bool informacaoConfirmacao = true;
  bool existeTransacaoPendente = true;
  String mensagemRetorno = "";
  String nsu = "";
  String codigoAutorizacao = "";
  String dataOperacao = "";
  String idcartao = "";
  String nomePortadorCartao = "";
  String nomeCartaoPadrao = "";
  String nomeEstabelecimento = "";
  String panMascarPadrao = "";
  String panMascarado = "";
  String identificadorConfirmacaoTransacao = "";
  String nsuLocalOriginal = "";
  String nsuLocal = "";
  String nsuHost = "";
  String nomeCartao = "";
  String nomeProvedor = "";
  String modoVerificacaoSenha = "";
  String codigoAutorizacaoOriginal = "";
  String pontoCaptura = "";
  String valorOperacao = "";
  String saldoVoucher = "";
  String viaCliente = "";
  String viaEstavelecimento = "";
  String viaCupomFull = "";

  Paygosdk() {
    print('Classe PayGo Iniciada');
  }

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> efetuaOperacao({
    required String numeroOperacao,
    // Dados da Automação
    required String empresaAutomacao,
    required String nomeAutomacao,
    required String versaoAutomacao,
    // Dados da Operação
    required String operacao,
    required String modalidadePagamento,
    required String tipoCartao,
    required String tipoFinanciamento,
    required String valorOperacao,
    required String parcelas,
    required String adquirente,
    // Dados para cancelamento
    required String nsu,
    required String codigoAutorizacao,
    required String dataOperacao,
    // Validações
    required bool confirmacaoManual,
    required bool viaLojaCliente,
    required bool viaCompleta,
    required bool interfaceAlternativa,
    required bool suportaTroco,
    required bool suportaDesconto,
    // Altera o Layout da aplicação PayGo
    // String fileIconDestino,
    // String fileFonteDestino,
    required String informaCorFonte,
    required String informaCorFonteTeclado,
    required String informaCorFundoCaixaEdicao,
    required String informaCorFundoTela,
    required String informaCorFundoTeclado,
    required String informaCorFundoToolbar,
    required String informaCorTextoCaixaEdicao,
    required String informaCorTeclaPressionadaTeclado,
    required String informaCorTeclaLiberadaTeclado,
    required String informaCorSeparadorMenu,
  }) async {
    Map<String, String> mapOperacao = Map();

    mapOperacao['numeroOperacao'] = numeroOperacao;

    mapOperacao['empresaAutomacao'] = empresaAutomacao;
    mapOperacao['nomeAutomacao'] = nomeAutomacao;
    mapOperacao['versaoAutomacao'] = versaoAutomacao;

    mapOperacao['operacao'] = operacao; // Venda, Cancelamento, Administrativo

    mapOperacao['modalidadePagamento'] =
        modalidadePagamento; // Cartão, Dinheiro
    mapOperacao['tipoCartao'] = tipoCartao; // Crédito, Débito
    mapOperacao['tipoFinanciamento'] = tipoFinanciamento; // A Vista, Emissor
    mapOperacao['valorOperacao'] = valorOperacao; // Valor da operação

    mapOperacao['parcelas'] = parcelas; // Quantidade de Parcelas
    mapOperacao['adquirente'] = adquirente; // Rede, Cielo, Vero

    mapOperacao['nsu'] = nsu;
    mapOperacao['codigoAutorizacao'] = codigoAutorizacao;
    mapOperacao['dataOperacao'] = dataOperacao;

    mapOperacao['confirmacaoManual'] = confirmacaoManual.toString();
    mapOperacao['viaLojaCliente'] = viaLojaCliente.toString();
    mapOperacao['viaCompleta'] = viaCompleta.toString();
    mapOperacao['interfaceAlternativa'] = interfaceAlternativa.toString();

    mapOperacao['suportaTroco'] = suportaTroco.toString();
    mapOperacao['suportaDesconto'] = suportaDesconto.toString();

    // mapOperacao['fileIconDestino'] = fileIconDestino;
    // mapOperacao['fileFonteDestino'] = fileFonteDestino;
    mapOperacao['informaCorFonte'] = informaCorFonte;
    mapOperacao['informaCorFonteTeclado'] = informaCorFonteTeclado;
    mapOperacao['informaCorFundoCaixaEdicao'] = informaCorFundoCaixaEdicao;
    mapOperacao['informaCorFundoTela'] = informaCorFundoTela;
    mapOperacao['informaCorFundoTeclado'] = informaCorFundoTeclado;
    mapOperacao['informaCorFundoToolbar'] = informaCorFundoToolbar;
    mapOperacao['informaCorTextoCaixaEdicao'] = informaCorTextoCaixaEdicao;
    mapOperacao['informaCorTeclaPressionadaTeclado'] =
        informaCorTeclaPressionadaTeclado;
    mapOperacao['informaCorTeclaLiberadaTeclado'] =
        informaCorTeclaLiberadaTeclado;
    mapOperacao['informaCorSeparadorMenu'] = informaCorSeparadorMenu;

    return await _channel.invokeMethod('setOperacao', mapOperacao);
  }

  static Future<String> confirmaOperacaoAutomatico() async {
    final String version =
        await _channel.invokeMethod('setConfirmaOperacaoAutomacica');
    return version;
  }

  static Future<String> confirmaOperacaoManual() async {
    final String version =
        await _channel.invokeMethod('setConfirmaOperacaoManual');
    return version;
  }

  static Future<String> desfazOperacaoManual() async {
    final String version =
        await _channel.invokeMethod('setDesafazOperacaoManual');
    return version;
  }

  static Future<String> confirmaOperacaoPendenteManual() async {
    final String version =
        await _channel.invokeMethod('setConfirmaOperacaoPendenteManual');
    return version;
  }

  static Future<String> desfazOperacaoPendente() async {
    final String version =
        await _channel.invokeMethod('setDesafazOperacaoPendente');
    return version;
  }

  Paygosdk.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    informacaoConfirmacao = json['informacaoConfirmacao'];
    existeTransacaoPendente = json['existeTransacaoPendente'];
    mensagemRetorno = json['mensagemRetorno'];
    nsu = json['nsu'];
    codigoAutorizacao = json['codigoAutorizacao'];
    dataOperacao = json['dataOperacao'];
    idcartao = json['idcartao'];
    nomePortadorCartao = json['nomePortadorCartao'];
    nomeCartaoPadrao = json['nomeCartaoPadrao'];
    nomeEstabelecimento = json['nomeEstabelecimento'];
    panMascarPadrao = json['panMascarPadrao'];
    panMascarado = json['panMascarado'];
    identificadorConfirmacaoTransacao =
        json['identificadorConfirmacaoTransacao'];
    nsuLocalOriginal = json['nsuLocalOriginal'];
    nsuLocal = json['nsuLocal'];
    nsuHost = json['nsuHost'];
    nomeCartao = json['nomeCartao'];
    nomeProvedor = json['nomeProvedor'];
    modoVerificacaoSenha = json['modoVerificacaoSenha'];
    codigoAutorizacaoOriginal = json['codigoAutorizacaoOriginal'];
    pontoCaptura = json['pontoCaptura'];
    valorOperacao = json['valorOperacao'];
    saldoVoucher = json['saldoVoucher'];
    viaCliente = json['via_cliente'];
    viaEstavelecimento = json['via_estavelecimento'];
    viaCupomFull = json['via_cupom_full'];
  }
}
