import 'package:flutter/material.dart';
import 'artigo_list_page.dart';
import 'artigo_roteiro_list_page.dart';
import 'roteiro_list_page.dart';
import 'roteiro_detail_page.dart';

/// Modelo de sequência de roteiro
class SeqRoteiro {
  final String codProduto;
  final int codRef;
  final int codOperacao;
  final String descOperacao;
  final String codPosto;
  final int opcaoPcp;
  final int seq;

  SeqRoteiro({
    required this.codProduto,
    required this.codRef,
    required this.codOperacao,
    required this.descOperacao,
    required this.codPosto,
    required this.opcaoPcp,
    required this.seq,
  });
}

/// Armazena as operações salvas por artigo (codProduto -> lista de operações)
final Map<String, List<SeqRoteiro>> operacoesPorArtigo = {
  'PRP001': [
    SeqRoteiro(
      codProduto: 'PRP001',
      codRef: 0,
      codOperacao: 1000,
      descOperacao: 'REMOLHO',
      codPosto: 'RML',
      opcaoPcp: 0,
      seq: 1,
    ),
    SeqRoteiro(
      codProduto: 'PRP001',
      codRef: 0,
      codOperacao: 1001,
      descOperacao: 'ENXUGADEIRA',
      codPosto: 'ENX',
      opcaoPcp: 0,
      seq: 2,
    ),
    SeqRoteiro(
      codProduto: 'PRP001',
      codRef: 0,
      codOperacao: 1002,
      descOperacao: 'DIVISORA',
      codPosto: 'DIV',
      opcaoPcp: 0,
      seq: 3,
    ),
  ],
};

/// Página de cadastro/edição de Artigo x Roteiro
class ArtigoRoteiroDetailPage extends StatefulWidget {
  final ArtigoRoteiroHeader? header;

  const ArtigoRoteiroDetailPage({super.key, this.header});

  @override
  State<ArtigoRoteiroDetailPage> createState() => _ArtigoRoteiroDetailPageState();
}

class _ArtigoRoteiroDetailPageState extends State<ArtigoRoteiroDetailPage> {
  final _formKey = GlobalKey<FormState>();

  Artigo? _artigoSelecionado;
  final List<SeqRoteiro> _operacoes = [];

  @override
  void initState() {
    super.initState();
    final header = widget.header;

    if (header != null) {
      try {
        _artigoSelecionado = artigosCadastrados.firstWhere(
          (a) => a.codProdutoRP == header.codProdutoRP,
        );
      } catch (_) {
        if (artigosCadastrados.isNotEmpty) {
          _artigoSelecionado = artigosCadastrados.first;
        }
      }

      _carregarOperacoesDoRoteiro(header.codProdutoRP);
    }
  }

  void _carregarOperacoesDoRoteiro(String codProduto) {
    final operacoesSalvas = operacoesPorArtigo[codProduto] ?? [];
    _operacoes.addAll(operacoesSalvas);
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;

    if (_artigoSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione um artigo.')),
      );
      return;
    }

    operacoesPorArtigo[_artigoSelecionado!.codProdutoRP] = List.from(_operacoes);

    final novo = ArtigoRoteiroHeader(
      codClassif: _artigoSelecionado!.codClassif,
      codProdutoRP: _artigoSelecionado!.codProdutoRP,
      codRefRP: 0,
      nomeArtigo: _artigoSelecionado!.nomeArtigo,
      nomeRoteiro: _artigoSelecionado!.nomeRoteiro,
      opcaoPcp: _artigoSelecionado!.opcaoPcp,
      status: _artigoSelecionado!.status,
    );

    Navigator.of(context).pop(novo);
  }

  void _adicionarOperacao() async {
    if (_artigoSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione um artigo primeiro.')),
      );
      return;
    }

    final roteiroSelecionado = await showDialog<RoteiroConfiguracao>(
      context: context,
      builder: (context) => _DialogSelecionarRoteiro(
        roteirosJaAdicionados: _operacoes.map((o) => o.codOperacao).toList(),
      ),
    );

    if (roteiroSelecionado == null) return;

    setState(() {
      final novaSeq = _operacoes.isEmpty ? 1 : _operacoes.last.seq + 1;
      _operacoes.add(
        SeqRoteiro(
          codProduto: _artigoSelecionado!.codProdutoRP,
          codRef: 0,
          codOperacao: roteiroSelecionado.codOperacao,
          descOperacao: roteiroSelecionado.descOperacao,
          codPosto: roteiroSelecionado.codPosto,
          opcaoPcp: 0,
          seq: novaSeq,
        ),
      );
    });
  }

  void _removerOperacao(SeqRoteiro op) {
    setState(() {
      _operacoes.remove(op);
      for (int i = 0; i < _operacoes.length; i++) {
        final atual = _operacoes[i];
        _operacoes[i] = SeqRoteiro(
          codProduto: atual.codProduto,
          codRef: atual.codRef,
          codOperacao: atual.codOperacao,
          descOperacao: atual.descOperacao,
          codPosto: atual.codPosto,
          opcaoPcp: atual.opcaoPcp,
          seq: i + 1,
        );
      }
    });
  }

  void _abrirDetalhesRoteiro(SeqRoteiro seq) {
    final roteiro = roteirosConfigurados.firstWhere(
      (r) => r.codOperacao == seq.codOperacao,
      orElse: () => roteirosConfigurados.first,
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RoteiroDetailPage(roteiroExistente: roteiro),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdicao = widget.header != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdicao ? 'Editar Artigo/Roteiro' : 'Novo Roteiro para Artigo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Salvar',
            onPressed: _salvar,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle('Selecione o Artigo'),
              const SizedBox(height: 8),
              _buildArtigoDropdown(),
              if (_artigoSelecionado != null) ...[
                const SizedBox(height: 12),
                _buildArtigoInfo(),
              ],
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _sectionTitle('Operações do Roteiro (SEQ. ROTEIRO)'),
                  ElevatedButton.icon(
                    onPressed: _adicionarOperacao,
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Adicionar Operação'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildOperacoesTable(),
              const SizedBox(height: 32),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: _salvar,
                    icon: const Icon(Icons.save),
                    label: const Text('Salvar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Color(0xFF212121),
      ),
    );
  }

  Widget _buildArtigoDropdown() {
    if (artigosCadastrados.isEmpty) {
      return Card(
        color: Colors.amber.shade50,
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.warning, color: Colors.amber),
              SizedBox(width: 12),
              Expanded(
                child: Text('Nenhum artigo cadastrado. Cadastre um artigo primeiro.'),
              ),
            ],
          ),
        ),
      );
    }

    return DropdownButtonFormField<Artigo>(
      value: _artigoSelecionado,
      decoration: const InputDecoration(
        labelText: 'Artigo',
        hintText: 'Selecione um artigo...',
      ),
      items: artigosCadastrados
          .where((a) => a.status == 'Ativo')
          .map(
            (a) => DropdownMenuItem<Artigo>(
              value: a,
              child: Text(a.artigoFormatado),
            ),
          )
          .toList(),
      onChanged: (v) {
        if (v == null) return;
        setState(() {
          _artigoSelecionado = v;
          _operacoes.clear();
          final operacoesSalvas = operacoesPorArtigo[v.codProdutoRP] ?? [];
          _operacoes.addAll(operacoesSalvas);
        });
      },
      validator: (v) => v == null ? 'Selecione um artigo.' : null,
    );
  }

  Widget _buildArtigoInfo() {
    final artigo = _artigoSelecionado!;
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.info, color: Colors.blue),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Artigo: ${artigo.nomeArtigo}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Código: ${artigo.codProdutoRP} | Classificação: ${artigo.codClassif}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOperacoesTable() {
    if (_operacoes.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Center(
          child: Text(
            'Nenhuma operação adicionada ao roteiro.',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: DataTable(
        columnSpacing: 48,
        horizontalMargin: 24,
        columns: const [
          DataColumn(label: Text('Seq', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('Operação', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('Posto', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('Ações', style: TextStyle(fontWeight: FontWeight.bold))),
        ],
        rows: _operacoes.map((op) {
          return DataRow(
            cells: [
              DataCell(Text(op.seq.toString())),
              DataCell(
                InkWell(
                  onTap: () => _abrirDetalhesRoteiro(op),
                  child: Text(
                    op.descOperacao,
                    style: const TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              DataCell(Text(op.codPosto)),
              DataCell(
                IconButton(
                  icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                  onPressed: () => _removerOperacao(op),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

/// Dialog para selecionar roteiro configurado
class _DialogSelecionarRoteiro extends StatelessWidget {
  final List<int> roteirosJaAdicionados;

  const _DialogSelecionarRoteiro({required this.roteirosJaAdicionados});

  @override
  Widget build(BuildContext context) {
    final roteirosDisponiveis = roteirosConfigurados
        .where((r) => !roteirosJaAdicionados.contains(r.codOperacao))
        .where((r) => r.status == 'Ativo')
        .toList();

    return AlertDialog(
      title: const Text('Selecionar Operação'),
      content: SizedBox(
        width: 400,
        child: roteirosDisponiveis.isEmpty
            ? const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Todas as operações configuradas já foram adicionadas.\n\nConfigure mais operações no menu "Cadastro de Roteiro Produtivo".',
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                itemCount: roteirosDisponiveis.length,
                itemBuilder: (context, index) {
                  final r = roteirosDisponiveis[index];
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(r.codOperacao.toString().substring(0, 2)),
                    ),
                    title: Text(r.descOperacao),
                    subtitle: Text('Código: ${r.codOperacao} | Posto: ${r.codPosto}'),
                    onTap: () => Navigator.of(context).pop(r),
                  );
                },
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
      ],
    );
  }
}
