import '../models/quimico.dart';
import '../database/database.dart';

class QuimicoRepository {
  List<Quimico> getAll() => List.unmodifiable(Database.quimicos);

  List<Quimico> getAtivos() => Database.quimicos.where((q) => q.isAtivo).toList();

  void add(Quimico quimico) => Database.quimicos.add(quimico);

  void update(Quimico old, Quimico novo) {
    final index = Database.quimicos.indexOf(old);
    if (index != -1) Database.quimicos[index] = novo;
  }

  void remove(Quimico quimico) => Database.quimicos.remove(quimico);

  Quimico? findByCodigo(String codigo) {
    try {
      return Database.quimicos.firstWhere((q) => q.codigo == codigo);
    } catch (_) {
      return null;
    }
  }
}

final quimicoRepository = QuimicoRepository();
