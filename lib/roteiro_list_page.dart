import 'package:flutter/material.dart';
import 'operacao_list_page.dart';
import 'cadastro_roteiro_produtivo_page.dart';

class RoteiroConfiguracao {
  final int codOperacao;
  final String descOperacao;
  final String codTipoMv;
  final String codPosto;
  final String tempoSetup;
  final String tempoEspera;
  final String tempoRepouso;
  final String tempoInicio;
  final String status;

  const RoteiroConfiguracao({
    required this.codOperacao,
    required this.descOperacao,
    required this.codTipoMv,
    required this.codPosto,
    required this.tempoSetup,
    required this.tempoEspera,
    required this.tempoRepouso,
    required this.tempoInicio,
    required this.status,
  });
}

// Lista global de roteiros configurados
final List<RoteiroConfiguracao> roteirosConfigurados = [
  const RoteiroConfiguracao(
    codOperacao: 1000,
    descOperacao: 'REMOLHO',
    codTipoMv: 'C901',
    codPosto: 'ENX',
    tempoSetup: '00:00',
    tempoEspera: '00:00',
    tempoRepouso: '00:00',
    tempoInicio: '00:00',
    status: 'Ativo',
  ),
  const RoteiroConfiguracao(
    codOperacao: 1001,
    descOperacao: 'ENXUGADEIRA',
    codTipoMv: 'C902',
    codPosto: 'RML',
    tempoSetup: '00:00',
    tempoEspera: '00:00',
    tempoRepouso: '00:00',
    tempoInicio: '00:00',
    status: 'Ativo',
  ),
  const RoteiroConfiguracao(
    codOperacao: 1002,
    descOperacao: 'DIVISORA',
    codTipoMv: 'C903',
    codPosto: 'DIV',
    tempoSetup: '00:00',
    tempoEspera: '00:00',
    tempoRepouso: '00:00',
    tempoInicio: '00:00',
    status: 'Ativo',
  ),
];

class RoteiroListPage extends StatefulWidget {
  const RoteiroListPage({super.key});

  @override
  State<RoteiroListPage> createState() => _RoteiroListPageState();
}

class _RoteiroListPageState extends State<RoteiroListPage> {
  void _abrirCadastro({RoteiroConfiguracao? roteiro}) async {
    final result = await Navigator.of(context).push<RoteiroConfiguracao>(
      MaterialPageRoute(
        builder: (_) => CadastroRoteiroProdutivoPage(
          roteiroExistente: roteiro,
        ),
      ),
    );

    if (result == null) return;

    setState(() {
      if (roteiro == null) {
        // Verifica se já existe configuração para esta operação
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
    setState(() {
      roteirosConfigurados.remove(roteiro);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Configuração de roteiro removida.')),
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
            onPressed: () => _abrirCadastro(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: roteirosConfigurados.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.route, size: 64, color: Colors.grey.shade400),
                    const SizedBox(height: 16),
                    Text(
                      'Nenhum roteiro configurado.',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Configure os roteiros selecionando operações cadastradas.',
                      style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => _abrirCadastro(),
                      icon: const Icon(Icons.add),
                      label: const Text('Novo Roteiro'),
                    ),
                  ],
                ),
              )
            : Card(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Cód. Operação')),
                      DataColumn(label: Text('Descrição')),
                      DataColumn(label: Text('Tipo Mov.')),
                      DataColumn(label: Text('Posto')),
                      DataColumn(label: Text('Setup')),
                      DataColumn(label: Text('Espera')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('')),
                    ],
                    rows: roteirosConfigurados
                        .map(
                          (r) => DataRow(
                            cells: [
                              DataCell(
                                Text(r.codOperacao.toString()),
                                onTap: () => _abrirCadastro(roteiro: r),
                              ),
                              DataCell(
                                Text(r.descOperacao),
                                onTap: () => _abrirCadastro(roteiro: r),
                              ),
                              DataCell(
                                Text(r.codTipoMv),
                                onTap: () => _abrirCadastro(roteiro: r),
                              ),
                              DataCell(
                                Text(r.codPosto),
                                onTap: () => _abrirCadastro(roteiro: r),
                              ),
                              DataCell(
                                Text(r.tempoSetup),
                                onTap: () => _abrirCadastro(roteiro: r),
                              ),
                              DataCell(
                                Text(r.tempoEspera),
                                onTap: () => _abrirCadastro(roteiro: r),
                              ),
                              DataCell(
                                Text(r.status),
                                onTap: () => _abrirCadastro(roteiro: r),
                              ),
                              DataCell(
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, size: 18),
                                  onPressed: () => _remover(r),
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
