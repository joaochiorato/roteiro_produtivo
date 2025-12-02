import 'package:flutter/material.dart';
import 'artigo_detail_page.dart';

class Artigo {
  final String codProdutoRP;
  final String nomeArtigo;
  final String nomeRoteiro;
  final int opcaoPcp;
  final int codClassif;
  final String status;

  Artigo({
    required this.codProdutoRP,
    required this.nomeArtigo,
    required this.nomeRoteiro,
    required this.opcaoPcp,
    required this.codClassif,
    required this.status,
  });

  String get artigoFormatado => '$codProdutoRP - $nomeArtigo';
}

// Lista global para compartilhar entre telas
final List<Artigo> artigosCadastrados = [
  Artigo(
    codProdutoRP: 'PRP001',
    nomeArtigo: 'QUARTZO',
    nomeRoteiro: 'Roteiro QUARTZO PRP001',
    opcaoPcp: 0,
    codClassif: 7,
    status: 'Ativo',
  ),
];

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
    setState(() {
      artigosCadastrados.remove(artigo);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Artigo removido.')),
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
            onPressed: () => _abrirDetalhe(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Artigo')),
                DataColumn(label: Text('Código')),
                DataColumn(label: Text('Cod Ref.')),
                DataColumn(label: Text('Artigo')),
                DataColumn(label: Text('Roteiro Produtivo')),
                DataColumn(label: Text('Status')),
                DataColumn(label: Text('')),
              ],
              rows: artigosCadastrados
                  .map(
                    (a) => DataRow(
                      cells: [
                        DataCell(
                          Text(a.codClassif.toString()),
                          onTap: () => _abrirDetalhe(artigo: a),
                        ),
                        DataCell(
                          Text(a.codProdutoRP),
                          onTap: () => _abrirDetalhe(artigo: a),
                        ),
                        DataCell(
                          Text(a.opcaoPcp.toString()),
                          onTap: () => _abrirDetalhe(artigo: a),
                        ),
                        DataCell(
                          Text(a.nomeArtigo),
                          onTap: () => _abrirDetalhe(artigo: a),
                        ),
                        DataCell(
                          Text(a.nomeRoteiro),
                          onTap: () => _abrirDetalhe(artigo: a),
                        ),
                        DataCell(
                          Text(a.status),
                          onTap: () => _abrirDetalhe(artigo: a),
                        ),
                        DataCell(
                          IconButton(
                            icon: const Icon(Icons.delete_outline, size: 18),
                            onPressed: () => _remover(a),
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}
