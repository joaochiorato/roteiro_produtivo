class Artigo {
  final int codClassif;
  final String codProdutoRP;
  final String nomeArtigo;
  final String descArtigo;
  final int opcaoPcp;
  final String status;

  Artigo({
    required this.codClassif,
    required this.codProdutoRP,
    required this.nomeArtigo,
    required this.descArtigo,
    required this.opcaoPcp,
    required this.status,
  });

  String get artigoFormatado => '$codProdutoRP - $descArtigo';

  bool get isAtivo => status == 'Ativo';
}
