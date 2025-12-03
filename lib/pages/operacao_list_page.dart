import 'package:flutter/material.dart';
import 'operacao_detail_page.dart';

/// Modelo de Operação
class Operacao {
  final int codOperacao;
  final String descricao;
  final String tipoMovimento;
  final String status;

  Operacao({
    required this.codOperacao,
    required this.descricao,
    required this.tipoMovimento,
    required this.status,
  });
}

/// Lista global de operações cadastradas
final List<Operacao> operacoesCadastradas = [
  Operacao(
    codOperacao: 1000,
    descricao: 'REMOLHO',
    tipoMovimento: 'C901',
    status: 'Ativo',
  ),
  Operacao(
    codOperacao: 1001,
    descricao: 'ENXUGADEIRA',
    tipoMovimento: 'C902',
    status: 'Ativo',
  ),
  Operacao(
    codOperacao: 1002,
    descricao: 'DIVISORA',
    tipoMovimento: 'C903',
    status: 'Ativo',
  ),
];

/// Página de listagem de Operações
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
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: Text('Deseja remover a operação "${operacao.descricao}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => operacoesCadastradas.remove(operacao));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Operação removida.')),
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
        title: const Text('Cadastro de Operação'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Nova Operação',
            onPressed: () => _abrirDetalhe(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: operacoesCadastradas.isEmpty
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
          Icon(Icons.build_outlined, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'Nenhuma operação cadastrada.',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _abrirDetalhe(),
            icon: const Icon(Icons.add),
            label: const Text('Nova Operação'),
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
              DataColumn(label: Text('Código')),
              DataColumn(label: Text('Descrição')),
              DataColumn(label: Text('Tipo Movimento')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Ações')),
            ],
            rows: operacoesCadastradas.map((op) {
              return DataRow(
                cells: [
                  DataCell(Text(op.codOperacao.toString())),
                  DataCell(Text(op.descricao)),
                  DataCell(Text(op.tipoMovimento)),
                  DataCell(_buildStatusBadge(op.status)),
                  DataCell(
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, size: 20),
                          tooltip: 'Editar',
                          onPressed: () => _abrirDetalhe(operacao: op),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                          tooltip: 'Remover',
                          onPressed: () => _remover(op),
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
