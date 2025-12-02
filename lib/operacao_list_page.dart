import 'package:flutter/material.dart';
import 'operacao_detail_page.dart';

class Operacao {
  final int codOperacao;
  final String descOperacao;
  final String codTipoMv;
  final String status;

  const Operacao({
    required this.codOperacao,
    required this.descOperacao,
    required this.codTipoMv,
    required this.status,
  });

  String get operacaoFormatada => '$codOperacao - $descOperacao';
}

// Lista global de operações cadastradas
final List<Operacao> operacoesCadastradas = [
  const Operacao(
    codOperacao: 1000,
    descOperacao: 'REMOLHO',
    codTipoMv: 'C901',
    status: 'Ativo',
  ),
  const Operacao(
    codOperacao: 1001,
    descOperacao: 'ENXUGADEIRA',
    codTipoMv: 'C902',
    status: 'Ativo',
  ),
  const Operacao(
    codOperacao: 1002,
    descOperacao: 'DIVISORA',
    codTipoMv: 'C903',
    status: 'Ativo',
  ),
];

class OperacaoListPage extends StatefulWidget {
  const OperacaoListPage({super.key});

  @override
  State<OperacaoListPage> createState() => _OperacaoListPageState();
}

class _OperacaoListPageState extends State<OperacaoListPage> {
  void _abrirDetalhe({Operacao? operacao}) async {
    final result = await Navigator.of(context).push<Operacao>(
      MaterialPageRoute(
        builder: (_) => OperacaoDetailPage(operacao: operacao),
      ),
    );

    if (result == null) return;

    setState(() {
      if (operacao == null) {
        operacoesCadastradas.add(result);
      } else {
        final idx = operacoesCadastradas.indexOf(operacao);
        operacoesCadastradas[idx] = result;
      }
    });
  }

  void _remover(Operacao operacao) {
    setState(() {
      operacoesCadastradas.remove(operacao);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Operação removida.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Operação'),
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
                DataColumn(label: Text('Cód. Operação')),
                DataColumn(label: Text('Descrição')),
                DataColumn(label: Text('Tipo Movimento')),
                DataColumn(label: Text('Status')),
                DataColumn(label: Text('')),
              ],
              rows: operacoesCadastradas
                  .map(
                    (op) => DataRow(
                      cells: [
                        DataCell(
                          Text(op.codOperacao.toString()),
                          onTap: () => _abrirDetalhe(operacao: op),
                        ),
                        DataCell(
                          Text(op.descOperacao),
                          onTap: () => _abrirDetalhe(operacao: op),
                        ),
                        DataCell(
                          Text(op.codTipoMv),
                          onTap: () => _abrirDetalhe(operacao: op),
                        ),
                        DataCell(
                          Text(op.status),
                          onTap: () => _abrirDetalhe(operacao: op),
                        ),
                        DataCell(
                          IconButton(
                            icon: const Icon(Icons.delete_outline, size: 18),
                            onPressed: () => _remover(op),
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
