import '../models/seq_roteiro.dart';
import '../database/database.dart';

class SeqRoteiroRepository {
  List<SeqRoteiro> getPorArtigo(String codProduto) {
    return Database.seqRoteiros[codProduto] ?? [];
  }

  void salvarPorArtigo(String codProduto, List<SeqRoteiro> operacoes) {
    Database.seqRoteiros[codProduto] = List.from(operacoes);
  }
}

final seqRoteiroRepository = SeqRoteiroRepository();
