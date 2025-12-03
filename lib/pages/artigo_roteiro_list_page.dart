import 'package:flutter/material.dart';
import 'artigo_list_page.dart';
import 'artigo_roteiro_detail_page.dart';

/// Header de Artigo x Roteiro (resumo)
class ArtigoRoteiroHeader {
  final int codClassif;
  final String codProdutoRP;
  final int codRefRP;
  final String nomeArtigo;
  final String nomeRoteiro;
  final int opcaoPcp;
  final String status;

  ArtigoRoteiroHeader({
    required this.codClassif,
    required this.codProdutoRP,
    required this.codRefRP,
    required this.nomeArtigo,
    required this.nomeRoteiro,
    required this.opcaoPcp,
    required this.status,
  });
}

/// Lista global de vínculos Artigo x Roteiro
final List<ArtigoRoteiroHeader> artigosRoteirosCadastrados = [
  ArtigoRoteiroHeader(
    codClassif: 7,
    codProdutoRP: 'PRP001',
    codRefRP: 0,
    nomeArtigo: 'QUARTZO',
    nomeRoteiro: 'Roteiro QUARTZO PRP001',
    opcaoPcp: 0,
    status: 'Ativo',
  ),
];

/// Página de listagem de Artigo x Roteiro
class ArtigoRoteiroListPage extends StatefulWidget {
  const ArtigoRoteiroListPage({super.key});

  @override
  State<ArtigoRoteiroListPage> createState() => _ArtigoRoteiroListPageState();
}

class _ArtigoRoteiroListPageState extends State<ArtigoRoteiroListPage> {
  void _abrirDetalhe({ArtigoRoteiroHeader? header}) async {
    final result = await Navigator.of(context).push<ArtigoRoteiroHeader>(
      MaterialPageRoute(
        builder: (_) => ArtigoRoteiroDetailPage(header: header),
      ),
    );

    if (result == null) return;

    setState(() {
      if (header == null) {
        // Verifica se já existe
        final existente = artigosRoteirosCadastrados.indexWhere(
          (h) => h.codProdutoRP == result.codProdutoRP,
        );
        if (existente >= 0) {
          artigosRoteirosCadastrados[existente] = result;
        } else {
          artigosRoteirosCadastrados.add(result);
        }
      } else {
        final idx = artigosRoteirosCadastrados.indexOf(header);
        artigosRoteirosCadastrados[idx] = result;
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
              setState(() => artigosRoteirosCadastrados.remove(header));
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
        child: artigosRoteirosCadastrados.isEmpty
            ? _buildEmptyState()
            : _buildDataTable(),
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

  Widget _buildDataTable() {
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
              DataColumn(label: Text('Cód. Produto')),
              DataColumn(label: Text('Artigo')),
              DataColumn(label: Text('Roteiro')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Ações')),
            ],
            rows: artigosRoteirosCadastrados.map((header) {
              return DataRow(
                cells: [
                  DataCell(Text(header.codClassif.toString())),
                  DataCell(Text(header.codProdutoRP)),
                  DataCell(Text(header.nomeArtigo)),
                  DataCell(Text(header.nomeRoteiro)),
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
