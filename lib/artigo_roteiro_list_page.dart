import 'package:flutter/material.dart';
import 'artigo_roteiro_detail_page.dart';

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

// Lista de vínculos Artigo x Roteiro
final List<ArtigoRoteiroHeader> artigoRoteiroVinculos = [
  ArtigoRoteiroHeader(
    codClassif: 7,
    codProdutoRP: 'PRP001',
    codRefRP: 0,
    nomeArtigo: 'QUARTZO',
    nomeRoteiro: 'QUARTZO PRP001',
    opcaoPcp: 0,
    status: 'Ativo',
  ),
];

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
        // Verifica se já existe vínculo para este artigo
        final existente = artigoRoteiroVinculos.indexWhere(
          (v) => v.codProdutoRP == result.codProdutoRP,
        );
        if (existente >= 0) {
          artigoRoteiroVinculos[existente] = result;
        } else {
          artigoRoteiroVinculos.add(result);
        }
      } else {
        final idx = artigoRoteiroVinculos.indexOf(header);
        artigoRoteiroVinculos[idx] = result;
      }
    });
  }

  void _remover(ArtigoRoteiroHeader header) {
    setState(() {
      artigoRoteiroVinculos.remove(header);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Vínculo Artigo x Roteiro removido.')),
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
            onPressed: () => _abrirDetalhe(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: artigoRoteiroVinculos.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.link_off, size: 64, color: Colors.grey.shade400),
                    const SizedBox(height: 16),
                    Text(
                      'Nenhum vínculo Artigo x Roteiro cadastrado.',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => _abrirDetalhe(),
                      icon: const Icon(Icons.add),
                      label: const Text('Criar Vínculo'),
                    ),
                  ],
                ),
              )
            : Card(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Cod. Artigo')),
                      DataColumn(label: Text('Opção PCP')),
                      DataColumn(label: Text('Artigo')),
                      DataColumn(label: Text('Roteiro Produtivo')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('')),
                    ],
                    rows: artigoRoteiroVinculos
                        .map(
                          (h) => DataRow(
                            cells: [
                              DataCell(
                                Text(h.codClassif.toString()),
                                onTap: () => _abrirDetalhe(header: h),
                              ),
                              DataCell(
                                Text(h.opcaoPcp.toString()),
                                onTap: () => _abrirDetalhe(header: h),
                              ),
                              DataCell(
                                Text('${h.codProdutoRP} - ${h.nomeArtigo}'),
                                onTap: () => _abrirDetalhe(header: h),
                              ),
                              DataCell(
                                Text(h.nomeRoteiro),
                                onTap: () => _abrirDetalhe(header: h),
                              ),
                              DataCell(
                                Text(h.status),
                                onTap: () => _abrirDetalhe(header: h),
                              ),
                              DataCell(
                                IconButton(
                                  icon:
                                      const Icon(Icons.delete_outline, size: 18),
                                  onPressed: () => _remover(h),
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
