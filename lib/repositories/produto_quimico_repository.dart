import '../models/produto_quimico.dart';
import '../database/database.dart';

class ProdutoQuimicoRepository {
  List<ProdutoQuimico> getPorOperacao(int codOperacao) {
    return Database.produtosQuimicos[codOperacao] ?? [];
  }

  void salvarPorOperacao(int codOperacao, List<ProdutoQuimico> produtos) {
    Database.produtosQuimicos[codOperacao] = List.from(produtos);
  }
}

final produtoQuimicoRepository = ProdutoQuimicoRepository();
