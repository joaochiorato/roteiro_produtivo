import '../models/artigo_roteiro_header.dart';
import '../database/database.dart';

class ArtigoRoteiroRepository {
  List<ArtigoRoteiroHeader> getAll() => List.unmodifiable(Database.artigoRoteiroHeaders);

  List<ArtigoRoteiroHeader> getAtivos() =>
      Database.artigoRoteiroHeaders.where((h) => h.isAtivo).toList();

  void add(ArtigoRoteiroHeader header) => Database.artigoRoteiroHeaders.add(header);

  void update(ArtigoRoteiroHeader old, ArtigoRoteiroHeader novo) {
    final index = Database.artigoRoteiroHeaders.indexOf(old);
    if (index != -1) Database.artigoRoteiroHeaders[index] = novo;
  }

  void remove(ArtigoRoteiroHeader header) => Database.artigoRoteiroHeaders.remove(header);

  ArtigoRoteiroHeader? findByCodigo(String codigo) {
    try {
      return Database.artigoRoteiroHeaders.firstWhere((h) => h.codProdutoRP == codigo);
    } catch (_) {
      return null;
    }
  }
}

final artigoRoteiroRepository = ArtigoRoteiroRepository();
