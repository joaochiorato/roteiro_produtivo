import '../models/roteiro_configuracao.dart';
import '../database/database.dart';

class RoteiroRepository {
  List<RoteiroConfiguracao> getAll() => List.unmodifiable(Database.roteiros);

  List<RoteiroConfiguracao> getAtivos() =>
      Database.roteiros.where((r) => r.isAtivo).toList();

  List<RoteiroConfiguracao> getDisponiveis(List<int> excluirCodigos) {
    return Database.roteiros
        .where((r) => !excluirCodigos.contains(r.codOperacao))
        .where((r) => r.isAtivo)
        .toList();
  }

  void add(RoteiroConfiguracao roteiro) => Database.roteiros.add(roteiro);

  void update(RoteiroConfiguracao old, RoteiroConfiguracao novo) {
    final index = Database.roteiros.indexOf(old);
    if (index != -1) Database.roteiros[index] = novo;
  }

  void remove(RoteiroConfiguracao roteiro) => Database.roteiros.remove(roteiro);

  RoteiroConfiguracao? findByCodOperacao(int codOperacao) {
    try {
      return Database.roteiros.firstWhere((r) => r.codOperacao == codOperacao);
    } catch (_) {
      return null;
    }
  }

  bool exists(int codOperacao) {
    return Database.roteiros.any((r) => r.codOperacao == codOperacao);
  }
}

final roteiroRepository = RoteiroRepository();
