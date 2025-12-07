class ArtigoRoteiroHeader {
  final int codClassif;
  final String codProdutoRP;
  final int codRefRP;
  final String nomeArtigo;
  final String descArtigo;
  final int opcaoPcp;
  final String status;

  ArtigoRoteiroHeader({
    required this.codClassif,
    required this.codProdutoRP,
    required this.codRefRP,
    required this.nomeArtigo,
    required this.descArtigo,
    required this.opcaoPcp,
    required this.status,
  });

  String get artigoRoteiroFormatado => '$codProdutoRP - $nomeArtigo';

  bool get isAtivo => status == 'Ativo';
}
