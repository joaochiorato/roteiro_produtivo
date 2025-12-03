import 'package:flutter/material.dart';
import 'artigo_detail_page.dart';

/// Modelo de Artigo
class Artigo {
  final int codClassif;
  final String codProdutoRP;
  final String nomeArtigo;
  final String nomeRoteiro;
  final int opcaoPcp;
  final String status;

  Artigo({
    required this.codClassif,
    required this.codProdutoRP,
    required this.nomeArtigo,
    required this.nomeRoteiro,
    required this.opcaoPcp,
    required this.status,
  });

  String get artigoFormatado => '$codProdutoRP - $nomeArtigo';
}

/// Lista global para compartilhar entre telas
final List<Artigo> artigosCadastrados = [
  Artigo(
    codProdutoRP: 'PRP001',
    nomeArtigo: 'QUARTZO',
    nomeRoteiro: 'QUARTZO PRP001',
    opcaoPcp: 0,
    codClassif: 7,
    status: 'Ativo',
  ),
];

/// Página de listagem de Artigos
class ArtigoListPage extends StatefulWidget {
  const ArtigoListPage({super.key});

  @override
  State<ArtigoListPage> createState() => _ArtigoListPageState();
}

class _ArtigoListPageState extends State<ArtigoListPage> {
  void _abrirDetalhe({Artigo? artigo}) async {
    final result = await Navigator.of(context).push<Artigo>(
      MaterialPageRoute(
        builder: (_) => ArtigoDetailPage(artigo: artigo),
      ),
    );

    if (result == null) return;

    setState(() {
      if (artigo == null) {
        artigosCadastrados.add(result);
      } else {
        final idx = artigosCadastrados.indexOf(artigo);
        artigosCadastrados[idx] = result;
      }
    });
  }

  void _remover(Artigo artigo) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: Text('Deseja remover o artigo "${artigo.nomeArtigo}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => artigosCadastrados.remove(artigo));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Artigo removido.')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Remover'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
        child:
            artigosCadastrados.isEmpty ? _buildEmptyState() : _buildDataTable(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.category_outlined, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'Nenhum artigo cadastrado.',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _abrirDetalhe(),
            icon: const Icon(Icons.add),
            label: const Text('Novo Artigo'),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable() {
    return Card(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Cod. Classif')),
            DataColumn(label: Text('Código')),
            DataColumn(label: Text('Artigo')),
            DataColumn(label: Text('Cod Ref.')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Ações')),
          ],
          rows: artigosCadastrados.map((artigo) {
            return DataRow(
              cells: [
                DataCell(Text(artigo.codClassif.toString())), // 4º
                DataCell(Text(artigo.codProdutoRP)), // 1º
                DataCell(Text(artigo.nomeArtigo)), // 2º
                DataCell(Text(artigo.opcaoPcp.toString())), // 3º
                DataCell(_buildStatusBadge(artigo.status)), // 5º
                DataCell(
                  // 6º
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        tooltip: 'Editar',
                        onPressed: () => _abrirDetalhe(artigo: artigo),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete,
                            size: 20, color: Colors.red),
                        tooltip: 'Remover',
                        onPressed: () => _remover(artigo),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final isAtivo = status == 'Ativo';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isAtivo ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isAtivo ? Colors.green.shade200 : Colors.red.shade200,
        ),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: isAtivo ? Colors.green.shade700 : Colors.red.shade700,
        ),
      ),
    );
  }
}
