class ProdutoQuimico {
  final String seq;
  final String codProdutoComp;
  final String codRef;
  final String descricao;
  final String padrao;
  final String previstoTolerancia;
  final String unidade;

  ProdutoQuimico({
    required this.seq,
    required this.codProdutoComp,
    required this.codRef,
    required this.descricao,
    required this.padrao,
    required this.previstoTolerancia,
    required this.unidade,
  });
}
