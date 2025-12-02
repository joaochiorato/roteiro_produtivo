import 'package:flutter/material.dart';
import 'artigo_list_page.dart';
import 'artigo_roteiro_list_page.dart';
import 'cadastro_roteiro_produtivo_page.dart';
import 'roteiro_list_page.dart';

// Armazena as operações salvas por artigo (codProduto -> lista de operações)
final Map<String, List<SeqRoteiro>> operacoesPorArtigo = {
  'PRP001': [
    SeqRoteiro(
      codProduto: 'PRP001',
      codRef: 0,
      codOperacao: 1000,
      descOperacao: 'REMOLHO',
      codPosto: 'ENX',
      opcaoPcp: 0,
      seq: 1,
    ),
    SeqRoteiro(
      codProduto: 'PRP001',
      codRef: 0,
      codOperacao: 1001,
      descOperacao: 'ENXUGADEIRA',
      codPosto: 'RML',
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

class ArtigoRoteiroDetailPage extends StatefulWidget {
  final ArtigoRoteiroHeader? header;

  const ArtigoRoteiroDetailPage({super.key, this.header});

  @override
  State<ArtigoRoteiroDetailPage> createState() =>
      _ArtigoRoteiroDetailPageState();
}

class _ArtigoRoteiroDetailPageState extends State<ArtigoRoteiroDetailPage> {
  final _formKey = GlobalKey<FormState>();

  Artigo? _artigoSelecionado;
  final List<SeqRoteiro> _operacoes = [];

  @override
  void initState() {
    super.initState();
    final header = widget.header;

    // Se editando, busca o artigo correspondente
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

      // Carrega operações existentes (mock)
      _carregarOperacoesDoRoteiro(header.codProdutoRP);
    }
  }

  void _carregarOperacoesDoRoteiro(String codProduto) {
    // Carrega apenas as operações que foram SALVAS para este vínculo
    // Busca na lista global de operações por artigo
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

    // Salva as operações na estrutura global
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

    // Mostra dialog para selecionar roteiro configurado
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
      // Reordena sequência
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
    // Busca o roteiro configurado para esta operação
    final roteiro = roteirosConfigurados.firstWhere(
      (r) => r.codOperacao == seq.codOperacao,
      orElse: () => roteirosConfigurados.first,
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CadastroRoteiroProdutivoPage(
          roteiroExistente: roteiro,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdicao = widget.header != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
            isEdicao ? 'Editar Artigo/Roteiro' : 'Novo Roteiro para Artigo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
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
            ],
          ),
        ),
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
                child: Text(
                  'Nenhum artigo cadastrado. Cadastre um artigo primeiro no menu "Cadastro de Artigo".',
                ),
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
        border: OutlineInputBorder(),
        isDense: true,
      ),
      hint: const Text('Selecione um artigo...'),
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
          // Carrega operações salvas para este artigo, se existirem
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
      color: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Roteiro: ${artigo.nomeRoteiro}',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Opção PCP: ${artigo.opcaoPcp} | Cod. Classif: ${artigo.codClassif}',
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildOperacoesTable() {
    if (_operacoes.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Text(
              _artigoSelecionado == null
                  ? 'Selecione um artigo para adicionar operações.'
                  : 'Nenhuma operação adicionada. Clique em "Adicionar Operação".',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
        ),
      );
    }

    return Card(
      child: Table(
        columnWidths: const {
          0: FixedColumnWidth(40),
          1: FlexColumnWidth(),
          2: FixedColumnWidth(80),
          3: FixedColumnWidth(50),
        },
        border: TableBorder.all(color: Colors.grey),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          const TableRow(
            decoration: BoxDecoration(color: Color(0xFFE0E0E0)),
            children: [
              Padding(
                padding: EdgeInsets.all(6),
                child: Text(
                  'Seq',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(6),
                child: Text(
                  'Operação',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(6),
                child: Text(
                  'Posto',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(6),
                child: Text(''),
              ),
            ],
          ),
          ..._operacoes.map(
            (op) => TableRow(
              children: [
                _cellTap(
                  op: op,
                  child: Text(op.seq.toString()),
                ),
                _cellTap(
                  op: op,
                  child: Text(op.descOperacao),
                ),
                _cellTap(
                  op: op,
                  child: Text(op.codPosto),
                ),
                Padding(
                  padding: const EdgeInsets.all(2),
                  child: IconButton(
                    icon: const Icon(Icons.delete_outline, size: 18),
                    onPressed: () => _removerOperacao(op),
                    tooltip: 'Remover operação',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cellTap({required SeqRoteiro op, required Widget child}) {
    return InkWell(
      onTap: () => _abrirDetalhesRoteiro(op),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: child,
      ),
    );
  }
}

// Dialog para selecionar roteiro configurado
class _DialogSelecionarRoteiro extends StatelessWidget {
  final List<int> roteirosJaAdicionados;

  const _DialogSelecionarRoteiro({
    required this.roteirosJaAdicionados,
  });

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
                    subtitle: Text(
                      'Código: ${r.codOperacao} | Posto: ${r.codPosto} | TMV: ${r.codTipoMv}',
                    ),
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
