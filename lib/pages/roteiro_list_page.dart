import 'package:flutter/material.dart';
import 'operacao_list_page.dart';
import 'roteiro_detail_page.dart';

/// Modelo de Variável de Controle
class VariavelControle {
  String seq;
  String descricao;
  String previstoTolerancia;
  String padrao;
  String unidade;

  VariavelControle({
    required this.seq,
    required this.descricao,
    required this.previstoTolerancia,
    required this.padrao,
    required this.unidade,
  });
}

/// Modelo de Produto Químico
class ProdutoQuimico {
  String seq;
  String codProdutoComp;
  String codRef;
  String descricao;
  String padrao;
  String previstoTolerancia;
  String unidade;

  ProdutoQuimico({
    required this.seq,
    required this.codProdutoComp,
    required this.codRef,
    required this.descricao,
    required this.padrao,
    required this.previstoTolerancia,
    required this.unidade,
  });
}

/// Modelo de Configuração de Roteiro
class RoteiroConfiguracao {
  final int codOperacao;
  final String descOperacao;
  final String codTipoMv;
  final String codPosto;
  final String tempoSetup;
  final String tempoEspera;
  final String tempoRepouso;
  final String tempoInicio;
  final String observacao;
  final String status;
  final List<VariavelControle> variaveis;
  final List<ProdutoQuimico> quimicos;

  const RoteiroConfiguracao({
    required this.codOperacao,
    required this.descOperacao,
    required this.codTipoMv,
    required this.codPosto,
    required this.tempoSetup,
    required this.tempoEspera,
    required this.tempoRepouso,
    required this.tempoInicio,
    this.observacao = '',
    required this.status,
    this.variaveis = const [],
    this.quimicos = const [],
  });
}

/// Dados mock de variáveis por operação
final Map<int, List<VariavelControle>> variaveisPorOperacaoMock = {
  1000: [
    VariavelControle(
      seq: '1',
      descricao: 'Volume de Água',
      padrao: '100% do Peso do Couro',
      previstoTolerancia: '',
      unidade: 'Litros',
    ),
    VariavelControle(
      seq: '2',
      descricao: 'Temperatura da Água',
      padrao: 'Faixa 50 a 70',
      previstoTolerancia: '',
      unidade: 'ºC',
    ),
    VariavelControle(
      seq: '3',
      descricao: 'Tensoativo',
      padrao: 'Faixa 4.8 - 5.2',
      previstoTolerancia: '',
      unidade: 'kg',
    ),
  ],
  1001: [
    VariavelControle(
      seq: '1',
      descricao: 'Pressão do Rolo(1º manômetro)',
      padrao: '40 a 110',
      previstoTolerancia: '',
      unidade: 'Bar',
    ),
    VariavelControle(
      seq: '2',
      descricao: 'Pressão do Rolo(2º manômetro)',
      padrao: '60 a 110',
      previstoTolerancia: '',
      unidade: 'Bar',
    ),
  ],
  1002: [
    VariavelControle(
      seq: '1',
      descricao: 'Espessura do Couro',
      padrao: '1.2 a 1.8',
      previstoTolerancia: '',
      unidade: 'mm',
    ),
  ],
};

/// Dados mock de químicos por operação
final Map<int, List<ProdutoQuimico>> quimicosPorOperacaoMock = {
  1000: [
    ProdutoQuimico(
      seq: '1',
      codProdutoComp: 'QUI001',
      codRef: '0',
      descricao: 'Tensoativo Tipo A',
      padrao: '0.5%',
      previstoTolerancia: '',
      unidade: 'kg',
    ),
    ProdutoQuimico(
      seq: '2',
      codProdutoComp: 'QUI002',
      codRef: '0',
      descricao: 'Bactericida',
      padrao: '0.1%',
      previstoTolerancia: '',
      unidade: 'L',
    ),
  ],
};

/// Lista global de roteiros configurados
final List<RoteiroConfiguracao> roteirosConfigurados = [
  RoteiroConfiguracao(
    codOperacao: 1000,
    descOperacao: 'REMOLHO',
    codTipoMv: 'C901',
    codPosto: 'ENX',
    tempoSetup: '00:00',
    tempoEspera: '00:00',
    tempoRepouso: '00:00',
    tempoInicio: '00:00',
    status: 'Ativo',
    variaveis: variaveisPorOperacaoMock[1000] ?? [],
    quimicos: quimicosPorOperacaoMock[1000] ?? [],
  ),
  RoteiroConfiguracao(
    codOperacao: 1001,
    descOperacao: 'ENXUGADEIRA',
    codTipoMv: 'C902',
    codPosto: 'RML',
    tempoSetup: '00:00',
    tempoEspera: '00:00',
    tempoRepouso: '00:00',
    tempoInicio: '00:00',
    status: 'Ativo',
    variaveis: variaveisPorOperacaoMock[1001] ?? [],
    quimicos: [],
  ),
  RoteiroConfiguracao(
    codOperacao: 1002,
    descOperacao: 'DIVISORA',
    codTipoMv: 'C903',
    codPosto: 'DIV',
    tempoSetup: '00:00',
    tempoEspera: '00:00',
    tempoRepouso: '00:00',
    tempoInicio: '00:00',
    status: 'Ativo',
    variaveis: variaveisPorOperacaoMock[1002] ?? [],
    quimicos: [],
  ),
];

/// Página de listagem de Roteiros
class RoteiroListPage extends StatefulWidget {
  const RoteiroListPage({super.key});

  @override
  State<RoteiroListPage> createState() => _RoteiroListPageState();
}

class _RoteiroListPageState extends State<RoteiroListPage> {
  void _abrirCadastro({RoteiroConfiguracao? roteiro}) async {
    final result = await Navigator.of(context).push<RoteiroConfiguracao>(
      MaterialPageRoute(
        builder: (_) => RoteiroDetailPage(roteiroExistente: roteiro),
      ),
    );

    if (result == null) return;

    setState(() {
      if (roteiro == null) {
        final existente = roteirosConfigurados.indexWhere(
          (r) => r.codOperacao == result.codOperacao,
        );
        if (existente >= 0) {
          roteirosConfigurados[existente] = result;
        } else {
          roteirosConfigurados.add(result);
        }
      } else {
        final idx = roteirosConfigurados.indexOf(roteiro);
        roteirosConfigurados[idx] = result;
      }
    });
  }

  void _remover(RoteiroConfiguracao roteiro) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: Text('Remover configuração de roteiro "${roteiro.descOperacao}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => roteirosConfigurados.remove(roteiro));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Configuração de roteiro removida.')),
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
        title: const Text('Cadastro de Roteiro Produtivo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Novo Roteiro',
            onPressed: () => _abrirCadastro(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: roteirosConfigurados.isEmpty
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
          Icon(Icons.route_outlined, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'Nenhum roteiro configurado.',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Text(
            'Configure os roteiros selecionando operações cadastradas.',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _abrirCadastro(),
            icon: const Icon(Icons.add),
            label: const Text('Novo Roteiro'),
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
            DataColumn(label: Text('Cód. Operação')),
            DataColumn(label: Text('Descrição')),
            DataColumn(label: Text('Tipo Mov.')),
            DataColumn(label: Text('Posto')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Ações')),
          ],
          rows: roteirosConfigurados.map((roteiro) {
            return DataRow(
              cells: [
                DataCell(Text(roteiro.codOperacao.toString())),
                DataCell(Text(roteiro.descOperacao)),
                DataCell(Text(roteiro.codTipoMv)),
                DataCell(Text(roteiro.codPosto)),
                DataCell(_buildStatusBadge(roteiro.status)),
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        tooltip: 'Editar',
                        onPressed: () => _abrirCadastro(roteiro: roteiro),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                        tooltip: 'Remover',
                        onPressed: () => _remover(roteiro),
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
