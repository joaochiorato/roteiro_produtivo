import '../models/operacao.dart';
import '../database/database.dart';

class OperacaoRepository {
  List<Operacao> getAll() => List.unmodifiable(Database.operacoes);

  List<Operacao> getAtivos() => Database.operacoes.where((o) => o.isAtivo).toList();

  void add(Operacao operacao) => Database.operacoes.add(operacao);

  void update(Operacao old, Operacao novo) {
    final index = Database.operacoes.indexOf(old);
    if (index != -1) Database.operacoes[index] = novo;
  }

  void remove(Operacao operacao) => Database.operacoes.remove(operacao);

  Operacao? findByCodigo(int codigo) {
    try {
      return Database.operacoes.firstWhere((o) => o.codOperacao == codigo);
    } catch (_) {
      return null;
    }
  }
}

final operacaoRepository = OperacaoRepository();
