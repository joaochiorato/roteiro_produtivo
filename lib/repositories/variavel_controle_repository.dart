import '../models/variavel_controle.dart';
import '../database/database.dart';

class VariavelControleRepository {
  List<VariavelControle> getPorOperacao(int codOperacao) {
    return Database.variaveisControle[codOperacao] ?? [];
  }

  void salvarPorOperacao(int codOperacao, List<VariavelControle> variaveis) {
    Database.variaveisControle[codOperacao] = List.from(variaveis);
  }
}

final variavelControleRepository = VariavelControleRepository();
