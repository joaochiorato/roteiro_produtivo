import 'package:flutter/material.dart';
import '../models/artigo_roteiro_header.dart';
import '../repositories/artigo_roteiro_repository.dart';
import 'artigo_roteiro_detail_page.dart';

/// Página de listagem de Artigo x Roteiro
class ArtigoRoteiroListPage extends StatefulWidget {
  const ArtigoRoteiroListPage({super.key});

  @override
  State<ArtigoRoteiroListPage> createState() => _ArtigoRoteiroListPageState();
}

class _ArtigoRoteiroListPageState extends State<ArtigoRoteiroListPage> {
  final _repository = artigoRoteiroRepository;

  void _abrirDetalhe({ArtigoRoteiroHeader? header}) async {
    final result = await Navigator.of(context).push<ArtigoRoteiroHeader>(
      MaterialPageRoute(
        builder: (_) => ArtigoRoteiroDetailPage(header: header),
      ),
    );

    if (result == null) return;

    setState(() {
      if (header == null) {
        _repository.add(result);
      } else {
        _repository.update(header, result);
      }
    });
  }

  void _remover(ArtigoRoteiroHeader header) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: Text('Remover vínculo "${header.nomeArtigo}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => _repository.remove(header));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Vínculo removido.')),
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
    final artigos = _repository.getAll();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro Artigo x Roteiro'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Novo Vínculo',
            onPressed: () => _abrirDetalhe(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: artigos.isEmpty
            ? _buildEmptyState()
            : _buildDataTable(artigos),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.link_off, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'Nenhum vínculo Artigo x Roteiro cadastrado.',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Text(
            'Vincule artigos às operações do roteiro.',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _abrirDetalhe(),
            icon: const Icon(Icons.add),
            label: const Text('Novo Vínculo'),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable(List<ArtigoRoteiroHeader> artigos) {
    final screenWidth = MediaQuery.of(context).size.width;
    double tableMinWidth = screenWidth - 32; // 16 de padding de cada lado
    if (tableMinWidth < 0) {
      tableMinWidth = screenWidth;
    }

    return Card(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: tableMinWidth),
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Cód. Artigo')),
              DataColumn(label: Text('Nome Artigo')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Ações')),
            ],
            rows: artigos.map((header) {
              return DataRow(
                cells: [
                  DataCell(Text(header.codClassif.toString())),
                  DataCell(Text(header.descArtigo)),
                  DataCell(_buildStatusBadge(header.status)),
                  DataCell(
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, size: 20),
                          tooltip: 'Editar',
                          onPressed: () => _abrirDetalhe(header: header),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                          tooltip: 'Remover',
                          onPressed: () => _remover(header),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
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
