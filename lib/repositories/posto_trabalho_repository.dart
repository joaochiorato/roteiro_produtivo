import '../models/posto_trabalho.dart';
import '../database/database.dart';

class PostoTrabalhoRepository {
  List<PostoTrabalho> getAll() => List.unmodifiable(Database.postosTrabalho);

  List<PostoTrabalho> getAtivos() => Database.postosTrabalho.where((p) => p.isAtivo).toList();

  void add(PostoTrabalho posto) => Database.postosTrabalho.add(posto);

  void update(PostoTrabalho old, PostoTrabalho novo) {
    final index = Database.postosTrabalho.indexOf(old);
    if (index != -1) Database.postosTrabalho[index] = novo;
  }

  void remove(PostoTrabalho posto) => Database.postosTrabalho.remove(posto);

  PostoTrabalho? findByCodigo(String codigo) {
    try {
      return Database.postosTrabalho.firstWhere((p) => p.codPosto == codigo);
    } catch (_) {
      return null;
    }
  }
}

final postoTrabalhoRepository = PostoTrabalhoRepository();
