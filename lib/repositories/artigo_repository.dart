import '../models/artigo.dart';
import '../database/database.dart';

class ArtigoRepository {
  List<Artigo> getAll() => List.unmodifiable(Database.artigos);

  List<Artigo> getAtivos() => Database.artigos.where((a) => a.isAtivo).toList();

  void add(Artigo artigo) => Database.artigos.add(artigo);

  void update(Artigo old, Artigo novo) {
    final index = Database.artigos.indexOf(old);
    if (index != -1) Database.artigos[index] = novo;
  }

  void remove(Artigo artigo) => Database.artigos.remove(artigo);

  Artigo? findByCodigo(String codigo) {
    try {
      return Database.artigos.firstWhere((a) => a.codProdutoRP == codigo);
    } catch (_) {
      return null;
    }
  }
}

final artigoRepository = ArtigoRepository();
