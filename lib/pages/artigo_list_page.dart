import 'package:flutter/material.dart';
import '../models/artigo.dart';
import '../repositories/artigo_repository.dart';
import '../widgets/status_badge.dart';
import '../widgets/empty_state.dart';
import 'artigo_detail_page.dart';

class ArtigoListPage extends StatefulWidget {
  const ArtigoListPage({super.key});

  @override
  State<ArtigoListPage> createState() => _ArtigoListPageState();
}

class _ArtigoListPageState extends State<ArtigoListPage> {
  final _repository = artigoRepository;

  Future<void> _abrirDetalhe({Artigo? artigo}) async {
    final result = await Navigator.of(context).push<Artigo>(
      MaterialPageRoute(
        builder: (_) => ArtigoDetailPage(artigo: artigo),
      ),
    );

    if (result == null) return;

    setState(() {
      if (artigo == null) {
        _repository.add(result);
      } else {
        _repository.update(artigo, result);
      }
    });
  }

  Future<void> _confirmarRemocao(Artigo artigo) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: Text('Deseja remover o artigo "${artigo.nomeArtigo}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Remover'),
          ),
        ],
      ),
    );

    if (confirmado == true) {
      setState(() => _repository.remove(artigo));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Artigo removido.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final artigos = _repository.getAll();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Artigo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Novo Artigo',
            onPressed: () => _abrirDetalhe(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: artigos.isEmpty ? _buildEmptyState() : _buildDataTable(artigos),
      ),
    );
  }

  Widget _buildEmptyState() {
    return EmptyState(
      icon: Icons.category_outlined,
      message: 'Nenhum artigo cadastrado.',
      buttonLabel: 'Novo Artigo',
      onButtonPressed: () => _abrirDetalhe(),
    );
  }

  Widget _buildDataTable(List<Artigo> artigos) {
    return Card(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Cod. Produto')),
            DataColumn(label: Text('Cod Ref.')),
            DataColumn(label: Text('Desc. Produto')),
            DataColumn(label: Text('Cod. Artigo')),
            DataColumn(label: Text('Desc. Artigo')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Ações')),
          ],
          rows: artigos.map(_buildDataRow).toList(),
        ),
      ),
    );
  }

  DataRow _buildDataRow(Artigo artigo) {
    return DataRow(
      cells: [
        DataCell(Text(artigo.codProdutoRP)),
        DataCell(Text(artigo.opcaoPcp.toString())),
        DataCell(Text(artigo.nomeArtigo)),
        DataCell(Text(artigo.codClassif.toString())),
        DataCell(Text(artigo.descArtigo)),
        DataCell(StatusBadge(status: artigo.status)),
        DataCell(_buildActionButtons(artigo)),
      ],
    );
  }

  Widget _buildActionButtons(Artigo artigo) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.edit, size: 20),
          tooltip: 'Editar',
          onPressed: () => _abrirDetalhe(artigo: artigo),
        ),
        IconButton(
          icon: const Icon(Icons.delete, size: 20, color: Colors.red),
          tooltip: 'Remover',
          onPressed: () => _confirmarRemocao(artigo),
        ),
      ],
    );
  }
}
