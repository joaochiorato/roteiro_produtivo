class Operacao {
  final int codOperacao;
  final String codTipoMv;
  final String descOperacao;
  final String status;

  Operacao({
    required this.codOperacao,
    required this.codTipoMv,
    required this.descOperacao,
    required this.status,
  });

  String get operacaoFormatada => '$codOperacao - $descOperacao';

  bool get isAtivo => status == 'Ativo';
}
