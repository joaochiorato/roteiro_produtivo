class RoteiroConfiguracao {
  final int codOperacao;
  final String descOperacao;
  final String codTipoMv;
  final String codPosto;
  final String tempoSetup;
  final String tempoEspera;
  final String tempoRepouso;
  final String tempoInicio;
  final String status;

  RoteiroConfiguracao({
    required this.codOperacao,
    required this.descOperacao,
    required this.codTipoMv,
    required this.codPosto,
    required this.tempoSetup,
    required this.tempoEspera,
    required this.tempoRepouso,
    required this.tempoInicio,
    required this.status,
  });

  bool get isAtivo => status == 'Ativo';
}
