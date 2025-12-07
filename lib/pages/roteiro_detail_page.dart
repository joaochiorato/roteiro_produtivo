import 'package:flutter/material.dart';
import '../models/roteiro_configuracao.dart';
import '../models/operacao.dart' as models;
import '../models/variavel_controle.dart';
import '../models/produto_quimico.dart';
import '../repositories/operacao_repository.dart';
import '../repositories/variavel_controle_repository.dart';
import '../repositories/produto_quimico_repository.dart';

/// Página de cadastro/edição de Roteiro Produtivo
class RoteiroDetailPage extends StatefulWidget {
  final RoteiroConfiguracao? roteiroExistente;

  const RoteiroDetailPage({super.key, this.roteiroExistente});

  @override
  State<RoteiroDetailPage> createState() => _RoteiroDetailPageState();
}

class _RoteiroDetailPageState extends State<RoteiroDetailPage> {
  final _formKey = GlobalKey<FormState>();

  models.Operacao? _operacaoSelecionada;

  late TextEditingController _tempoSetupController;
  late TextEditingController _tempoEsperaController;
  late TextEditingController _tempoRepousoController;
  late TextEditingController _tempoInicioController;
  late TextEditingController _observacaoController;

  String? _postoTrabalho = 'ENX';
  String _status = 'Ativo';

  List<VariavelControle> _variaveis = [];
  List<ProdutoQuimico> _quimicos = [];

  @override
  void initState() {
    super.initState();

    final roteiro = widget.roteiroExistente;

    if (roteiro != null) {
      try {
        _operacaoSelecionada = operacaoRepository.getAll().firstWhere(
          (o) => o.codOperacao == roteiro.codOperacao,
        );
      } catch (_) {}

      _postoTrabalho = roteiro.codPosto;
      _status = roteiro.status;
      _carregarVariaveisEQuimicos(roteiro.codOperacao);
    }

    _tempoSetupController =
        TextEditingController(text: roteiro?.tempoSetup ?? '00:00');
    _tempoEsperaController =
        TextEditingController(text: roteiro?.tempoEspera ?? '00:00');
    _tempoRepousoController =
        TextEditingController(text: roteiro?.tempoRepouso ?? '00:00');
    _tempoInicioController =
        TextEditingController(text: roteiro?.tempoInicio ?? '00:00');
    _observacaoController =
        TextEditingController(text: '');
  }

  void _carregarVariaveisEQuimicos(int codOperacao) {
    _variaveis = variavelControleRepository.getPorOperacao(codOperacao);
    _quimicos = produtoQuimicoRepository.getPorOperacao(codOperacao);
  }

  void _onOperacaoChanged(models.Operacao? operacao) {
    if (operacao == null) return;

    setState(() {
      _operacaoSelecionada = operacao;

      switch (operacao.codOperacao) {
        case 1000:
          _postoTrabalho = 'ENX';
          break;
        case 1001:
          _postoTrabalho = 'RML';
          break;
        case 1002:
          _postoTrabalho = 'DIV';
          break;
        default:
          _postoTrabalho = 'ENX';
      }

      _carregarVariaveisEQuimicos(operacao.codOperacao);
    });
  }

  @override
  void dispose() {
    _tempoSetupController.dispose();
    _tempoEsperaController.dispose();
    _tempoRepousoController.dispose();
    _tempoInicioController.dispose();
    _observacaoController.dispose();
    super.dispose();
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;

    if (_operacaoSelecionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione uma operação.')),
      );
      return;
    }

    final novo = RoteiroConfiguracao(
      codOperacao: _operacaoSelecionada!.codOperacao,
      descOperacao: _operacaoSelecionada!.descOperacao,
      codTipoMv: _operacaoSelecionada!.codTipoMv,
      codPosto: _postoTrabalho ?? 'ENX',
      tempoSetup: _tempoSetupController.text,
      tempoEspera: _tempoEsperaController.text,
      tempoRepouso: _tempoRepousoController.text,
      tempoInicio: _tempoInicioController.text,
      status: _status,
    );

    Navigator.of(context).pop(novo);
  }

  void _adicionarVariavel() async {
    if (_operacaoSelecionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione uma operação primeiro.')),
      );
      return;
    }

    final novaVariavel = await showDialog<VariavelControle>(
      context: context,
      builder: (context) => _DialogAdicionarVariavel(
        proximaSeq:
            (_variaveis.isEmpty ? 0 : int.parse(_variaveis.last.seq)) + 1,
      ),
    );

    if (novaVariavel != null) {
      setState(() => _variaveis.add(novaVariavel));
    }
  }

  void _adicionarQuimico() async {
    if (_operacaoSelecionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione uma operação primeiro.')),
      );
      return;
    }

    final novoQuimico = await showDialog<ProdutoQuimico>(
      context: context,
      builder: (context) => _DialogAdicionarQuimico(
        proximaSeq: (_quimicos.isEmpty ? 0 : int.parse(_quimicos.last.seq)) + 1,
      ),
    );

    if (novoQuimico != null) {
      setState(() => _quimicos.add(novoQuimico));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdicao = widget.roteiroExistente != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdicao ? 'Editar Roteiro' : 'Novo Roteiro'),
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
              _sectionTitle('Operação'),
              const SizedBox(height: 8),
              _buildOperacaoDropdown(isEdicao),
              const SizedBox(height: 24),

              _sectionTitle('Configuração de Tempos'),
              const SizedBox(height: 8),
              _buildTemposSection(),
              const SizedBox(height: 24),

              _sectionTitle('Observação'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _observacaoController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Observação',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 24),

              _sectionTitle('Posto de Trabalho e Status'),
              const SizedBox(height: 8),
              _buildPostoStatusSection(),
              const SizedBox(height: 24),

              _buildVariaveisSection(),
              const SizedBox(height: 24),

              _buildQuimicosSection(),
              const SizedBox(height: 32),

              // Botões de ação
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

  Widget _buildOperacaoDropdown(bool isEdicao) {
    final operacoes = operacaoRepository.getAll();
    if (operacoes.isEmpty) {
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
                    'Nenhuma operação cadastrada. Cadastre uma operação primeiro.'),
              ),
            ],
          ),
        ),
      );
    }

    return DropdownButtonFormField<models.Operacao>(
      value: _operacaoSelecionada,
      decoration: const InputDecoration(
        labelText: 'Operação',
        hintText: 'Selecione uma operação...',
      ),
      items: operacaoRepository.getAll()
          .where((o) => o.status == 'Ativo')
          .map(
            (o) => DropdownMenuItem<models.Operacao>(
              value: o,
              child: Text('${o.codOperacao} - ${o.descOperacao}'),
            ),
          )
          .toList(),
      onChanged: _onOperacaoChanged,
      validator: (v) => v == null ? 'Selecione uma operação.' : null,
    );
  }

  Widget _buildTemposSection() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _tempoSetupController,
            decoration: const InputDecoration(labelText: 'Tempo Setup'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TextFormField(
            controller: _tempoEsperaController,
            decoration: const InputDecoration(labelText: 'Tempo Espera'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TextFormField(
            controller: _tempoRepousoController,
            decoration: const InputDecoration(labelText: 'Tempo Repouso'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TextFormField(
            controller: _tempoInicioController,
            decoration: const InputDecoration(labelText: 'Tempo Início'),
          ),
        ),
      ],
    );
  }

  Widget _buildPostoStatusSection() {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            value: _postoTrabalho,
            decoration: const InputDecoration(labelText: 'Posto de Trabalho'),
            items: const [
              DropdownMenuItem(value: 'ENX', child: Text('ENX - Enxugadeira')),
              DropdownMenuItem(value: 'RML', child: Text('RML - Remolho')),
              DropdownMenuItem(value: 'DIV', child: Text('DIV - Divisora')),
              DropdownMenuItem(value: 'RBX', child: Text('RBX - Rebaixadeira')),
              DropdownMenuItem(value: 'RFL', child: Text('RFL - Refila')),
              DropdownMenuItem(value: 'CUR', child: Text('CUR - Curtimento')),
              DropdownMenuItem(value: 'REC', child: Text('REC - Recurtimento')),
              DropdownMenuItem(value: 'SEC', child: Text('SEC - SECAGEM')),
              DropdownMenuItem(value: 'TIN', child: Text('TIN - Tingimento')),
              DropdownMenuItem(value: 'RCL', child: Text('RCL - Reclassificação')),
              DropdownMenuItem(value: 'CAL', child: Text('CAL - Calha')),
            ],
            onChanged: (v) => setState(() => _postoTrabalho = v),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: DropdownButtonFormField<String>(
            value: _status,
            decoration: const InputDecoration(labelText: 'Status'),
            items: const [
              DropdownMenuItem(value: 'Ativo', child: Text('Ativo')),
              DropdownMenuItem(value: 'Inativo', child: Text('Inativo')),
            ],
            onChanged: (v) => setState(() => _status = v!),
          ),
        ),
      ],
    );
  }

  Widget _buildVariaveisSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _sectionTitle('Variáveis de Controle'),
            ElevatedButton.icon(
              onPressed: _adicionarVariavel,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Adicionar'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (_operacaoSelecionada == null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Center(
              child: Text(
                'Selecione uma operação para ver as variáveis.',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
          )
        else if (_variaveis.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Center(
              child: Text(
                'Nenhuma variável cadastrada.',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
          )
        else
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: DataTable(
              columnSpacing: 24,
              horizontalMargin: 16,
              columns: const [
                DataColumn(
                    label: Text('Seq',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Descrição',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Padrão',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Previsto/Toler.',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Unid',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Ações',
                        style: TextStyle(fontWeight: FontWeight.bold))),
              ],
              rows: _variaveis.map((v) {
                return DataRow(
                  cells: [
                    DataCell(Text(v.seq)),
                    DataCell(Text(v.descricao)),
                    DataCell(Text(v.padrao)),
                    DataCell(Text(v.previstoTolerancia)),
                    DataCell(Text(v.unidade)),
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, size: 18),
                            onPressed: () => _editarVariavel(v),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete,
                                size: 18, color: Colors.red),
                            onPressed: () =>
                                setState(() => _variaveis.remove(v)),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildQuimicosSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _sectionTitle('Produtos Químicos'),
            ElevatedButton.icon(
              onPressed: _adicionarQuimico,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Adicionar'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (_operacaoSelecionada == null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Center(
              child: Text(
                'Selecione uma operação para ver os químicos.',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
          )
        else if (_quimicos.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Center(
              child: Text(
                'Nenhum químico cadastrado.',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
          )
        else
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: DataTable(
              columnSpacing: 24,
              horizontalMargin: 16,
              columns: const [
                DataColumn(
                    label: Text('Seq',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Cód. Prod.',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Cód. Ref.',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Descrição',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Padrão',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Previsto/Toler.',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Unid',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Ações',
                        style: TextStyle(fontWeight: FontWeight.bold))),
              ],
              rows: _quimicos.map((q) {
                return DataRow(
                  cells: [
                    DataCell(Text(q.seq)),
                    DataCell(Text(q.codProdutoComp)),
                    DataCell(Text(q.codRef)),
                    DataCell(Text(q.descricao)),
                    DataCell(Text(q.padrao)),
                    DataCell(Text(q.previstoTolerancia)),
                    DataCell(Text(q.unidade)),
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, size: 18),
                            onPressed: () => _editarQuimico(q),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete,
                                size: 18, color: Colors.red),
                            onPressed: () =>
                                setState(() => _quimicos.remove(q)),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  void _editarVariavel(VariavelControle variavel) async {
    final variavelEditada = await showDialog<VariavelControle>(
      context: context,
      builder: (context) => _DialogEditarVariavel(variavel: variavel),
    );

    if (variavelEditada != null) {
      setState(() {
        final idx = _variaveis.indexOf(variavel);
        if (idx >= 0) {
          _variaveis[idx] = variavelEditada;
        }
      });
    }
  }

  void _editarQuimico(ProdutoQuimico quimico) async {
    final quimicoEditado = await showDialog<ProdutoQuimico>(
      context: context,
      builder: (context) => _DialogEditarQuimico(quimico: quimico),
    );

    if (quimicoEditado != null) {
      setState(() {
        final idx = _quimicos.indexOf(quimico);
        if (idx >= 0) {
          _quimicos[idx] = quimicoEditado;
        }
      });
    }
  }
}

/// Dialog para adicionar variável
class _DialogAdicionarVariavel extends StatefulWidget {
  final int proximaSeq;

  const _DialogAdicionarVariavel({required this.proximaSeq});

  @override
  State<_DialogAdicionarVariavel> createState() =>
      _DialogAdicionarVariavelState();
}

class _DialogAdicionarVariavelState extends State<_DialogAdicionarVariavel> {
  final _formKey = GlobalKey<FormState>();
  final _descricaoController = TextEditingController();
  final _padraoController = TextEditingController();
  final _previstoController = TextEditingController();
  final _unidadeController = TextEditingController();

  // Lista de unidades disponíveis para seleção
  final List<String> _unidades = const [
    'Kg',
    'Mt',
    'Tempo',
    'PC',
    'Uni',
    'Lt',
    'mL',
    '%',
  ];

  @override
  void dispose() {
    _descricaoController.dispose();
    _padraoController.dispose();
    _previstoController.dispose();
    _unidadeController.dispose();
    super.dispose();
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;

    final variavel = VariavelControle(
      seq: widget.proximaSeq.toString(),
      descricao: _descricaoController.text.trim(),
      padrao: _padraoController.text.trim(),
      previstoTolerancia: _previstoController.text.trim(),
      unidade: _unidadeController.text.trim(),
    );

    Navigator.of(context).pop(variavel);
  }

  Future<void> _selecionarUnidade() async {
    final unidadeSelecionada = await showDialog<String>(
      context: context,
      builder: (ctx) {
        return SimpleDialog(
          title: const Text('Selecionar unidade'),
          children: _unidades.map((u) {
            return SimpleDialogOption(
              onPressed: () => Navigator.pop(ctx, u),
              child: Text(u),
            );
          }).toList(),
        );
      },
    );

    if (unidadeSelecionada != null) {
      setState(() {
        _unidadeController.text = unidadeSelecionada;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nova Variável'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _descricaoController,
              decoration: const InputDecoration(labelText: 'Descrição'),
              validator: (v) => (v == null || v.isEmpty) ? 'Obrigatório' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _padraoController,
              decoration: const InputDecoration(labelText: 'Padrão'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _previstoController,
              decoration: const InputDecoration(labelText: 'Previsto/Toler.'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _unidadeController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Unidade',
                suffixIcon: Icon(Icons.arrow_drop_down),
              ),
              onTap: _selecionarUnidade,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _salvar,
          child: const Text('Adicionar'),
        ),
      ],
    );
  }
}

/// Dialog para adicionar químico
class _DialogAdicionarQuimico extends StatefulWidget {
  final int proximaSeq;

  const _DialogAdicionarQuimico({required this.proximaSeq});

  @override
  State<_DialogAdicionarQuimico> createState() =>
      _DialogAdicionarQuimicoState();
}

class _DialogAdicionarQuimicoState extends State<_DialogAdicionarQuimico> {
  final _formKey = GlobalKey<FormState>();
  final _codigoController = TextEditingController();
  final _codRefController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _padraoController = TextEditingController();
  final _previstoController = TextEditingController();
  final _unidadeController = TextEditingController();

  // Lista fixa de produtos químicos disponíveis para seleção
  final List<Map<String, String>> _produtosQuimicos = const [
    {'codigo': '89396', 'ref': '0', 'descricao': 'CAL VIRGEM 20 KG'},
    {'codigo': '95001', 'ref': '0', 'descricao': 'SULFETO DE SODIO 60%'},
    {'codigo': '95209', 'ref': '0', 'descricao': 'TENSOATIVO'},
    {'codigo': '74123', 'ref': '0', 'descricao': 'ÁCIDO FÓRMICO'},
    {'codigo': '96321', 'ref': '0', 'descricao': 'ENZIMA DESENGRAXANTE'},
    {'codigo': '85247', 'ref': '0', 'descricao': 'SEQUESTRANTE'},
    {'codigo': '77411', 'ref': '0', 'descricao': 'SODA 50%'},
    {'codigo': '66543', 'ref': '0', 'descricao': 'REDUTOR DE ODOR'},
  ];

  // Lista de unidades disponíveis para seleção
  final List<String> _unidades = const [
    'Kg',
    'Mt',
    'Tempo',
    'PC',
    'Uni',
    'Lt',
    'mL',
    '%',
  ];

  @override
  void dispose() {
    _codigoController.dispose();
    _descricaoController.dispose();
    _padraoController.dispose();
    _previstoController.dispose();
    _unidadeController.dispose();
    super.dispose();
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;

    final quimico = ProdutoQuimico(
      seq: widget.proximaSeq.toString(),
      codProdutoComp: _codigoController.text.trim().toUpperCase(),
      codRef: _codRefController.text.trim(),
      descricao: _descricaoController.text.trim(),
      padrao: _padraoController.text.trim(),
      previstoTolerancia: _previstoController.text.trim(),
      unidade: _unidadeController.text.trim(),
    );

    Navigator.of(context).pop(quimico);
  }

  Future<void> _selecionarProdutoQuimico() async {
    final selecionado = await showDialog<Map<String, String>>(
      context: context,
      builder: (ctx) {
        return SimpleDialog(
          title: const Text('Selecionar produto químico'),
          children: _produtosQuimicos.map((produto) {
            final codigo = produto['codigo'] ?? '';
            final ref = produto['ref'] ?? '';
            final descricao = produto['descricao'] ?? '';
            final label = '$codigo - $ref - $descricao';

            return SimpleDialogOption(
              onPressed: () => Navigator.pop(ctx, produto),
              child: Text(label),
            );
          }).toList(),
        );
      },
    );

    if (selecionado != null) {
      setState(() {
        _codigoController.text = (selecionado['codigo'] ?? '').toUpperCase();
        _codRefController.text = selecionado['ref'] ?? '';
        _descricaoController.text = selecionado['descricao'] ?? '';
      });
    }
  }

  Future<void> _selecionarUnidade() async {
    final unidadeSelecionada = await showDialog<String>(
      context: context,
      builder: (ctx) {
        return SimpleDialog(
          title: const Text('Selecionar unidade'),
          children: _unidades.map((u) {
            return SimpleDialogOption(
              onPressed: () => Navigator.pop(ctx, u),
              child: Text(u),
            );
          }).toList(),
        );
      },
    );

    if (unidadeSelecionada != null) {
      setState(() {
        _unidadeController.text = unidadeSelecionada;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Novo Produto Químico'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _codigoController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Cód. Prod.',
                suffixIcon: Icon(Icons.arrow_drop_down),
              ),
              textCapitalization: TextCapitalization.characters,
              onTap: _selecionarProdutoQuimico,
              validator: (v) => (v == null || v.isEmpty) ? 'Obrigatório' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _codRefController,
              decoration: const InputDecoration(labelText: 'Cód. Ref.'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descricaoController,
              decoration: const InputDecoration(labelText: 'Descrição'),
              validator: (v) => (v == null || v.isEmpty) ? 'Obrigatório' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _padraoController,
              decoration: const InputDecoration(labelText: 'Padrão'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _previstoController,
              decoration: const InputDecoration(labelText: 'Previsto/Toler.'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _unidadeController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Unidade',
                suffixIcon: Icon(Icons.arrow_drop_down),
              ),
              onTap: _selecionarUnidade,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _salvar,
          child: const Text('Adicionar'),
        ),
      ],
    );
  }
}

/// Dialog para editar variável
class _DialogEditarVariavel extends StatefulWidget {
  final VariavelControle variavel;

  const _DialogEditarVariavel({required this.variavel});

  @override
  State<_DialogEditarVariavel> createState() => _DialogEditarVariavelState();
}

class _DialogEditarVariavelState extends State<_DialogEditarVariavel> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _descricaoController;
  late TextEditingController _padraoController;
  late TextEditingController _previstoController;
  late TextEditingController _unidadeController;

  // Lista de unidades disponíveis para seleção
  final List<String> _unidades = const [
    'Kg',
    'Mt',
    'Tempo',
    'PC',
    'Uni',
    'Lt',
    'mL',
    '%',
  ];

  @override
  void initState() {
    super.initState();
    _descricaoController =
        TextEditingController(text: widget.variavel.descricao);
    _padraoController = TextEditingController(text: widget.variavel.padrao);
    _previstoController =
        TextEditingController(text: widget.variavel.previstoTolerancia);
    _unidadeController = TextEditingController(text: widget.variavel.unidade);
  }

  @override
  void dispose() {
    _descricaoController.dispose();
    _padraoController.dispose();
    _previstoController.dispose();
    _unidadeController.dispose();
    super.dispose();
  }

  Future<void> _selecionarUnidade() async {
    final unidadeSelecionada = await showDialog<String>(
      context: context,
      builder: (ctx) {
        return SimpleDialog(
          title: const Text('Selecionar unidade'),
          children: _unidades.map((u) {
            return SimpleDialogOption(
              onPressed: () => Navigator.pop(ctx, u),
              child: Text(u),
            );
          }).toList(),
        );
      },
    );

    if (unidadeSelecionada != null) {
      setState(() {
        _unidadeController.text = unidadeSelecionada;
      });
    }
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;

    final variavelAtualizada = VariavelControle(
      seq: widget.variavel.seq,
      descricao: _descricaoController.text.trim(),
      padrao: _padraoController.text.trim(),
      previstoTolerancia: _previstoController.text.trim(),
      unidade: _unidadeController.text.trim(),
    );

    Navigator.of(context).pop(variavelAtualizada);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar Variável'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _descricaoController,
              decoration: const InputDecoration(labelText: 'Descrição'),
              validator: (v) => (v == null || v.isEmpty) ? 'Obrigatório' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _padraoController,
              decoration: const InputDecoration(labelText: 'Padrão'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _previstoController,
              decoration: const InputDecoration(labelText: 'Previsto/Toler.'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _unidadeController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Unidade',
                suffixIcon: Icon(Icons.arrow_drop_down),
              ),
              onTap: _selecionarUnidade,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _salvar,
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}

/// Dialog para editar produto químico
class _DialogEditarQuimico extends StatefulWidget {
  final ProdutoQuimico quimico;

  const _DialogEditarQuimico({required this.quimico});

  @override
  State<_DialogEditarQuimico> createState() => _DialogEditarQuimicoState();
}

class _DialogEditarQuimicoState extends State<_DialogEditarQuimico> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _codigoController;
  late TextEditingController _codRefController;
  late TextEditingController _descricaoController;
  late TextEditingController _padraoController;
  late TextEditingController _previstoController;
  late TextEditingController _unidadeController;

  // Lista fixa de produtos químicos disponíveis para seleção
  final List<Map<String, String>> _produtosQuimicos = const [
    {'codigo': '89396', 'ref': '0', 'descricao': 'CAL VIRGEM 20 KG'},
    {'codigo': '95001', 'ref': '0', 'descricao': 'SULFETO DE SODIO 60%'},
    {'codigo': '95209', 'ref': '0', 'descricao': 'TENSOATIVO'},
    {'codigo': '74123', 'ref': '0', 'descricao': 'ÁCIDO FÓRMICO'},
    {'codigo': '96321', 'ref': '0', 'descricao': 'ENZIMA DESENGRAXANTE'},
    {'codigo': '85247', 'ref': '0', 'descricao': 'SEQUESTRANTE'},
    {'codigo': '77411', 'ref': '0', 'descricao': 'SODA 50%'},
    {'codigo': '66543', 'ref': '0', 'descricao': 'REDUTOR DE ODOR'},
  ];

  // Lista de unidades disponíveis para seleção
  final List<String> _unidades = const [
    'Kg',
    'Mt',
    'Tempo',
    'PC',
    'Uni',
    'Lt',
    'mL',
    '%',
  ];

  @override
  void initState() {
    super.initState();
    _codigoController =
        TextEditingController(text: widget.quimico.codProdutoComp);
    _codRefController = TextEditingController(text: widget.quimico.codRef);
    _descricaoController =
        TextEditingController(text: widget.quimico.descricao);
    _padraoController = TextEditingController(text: widget.quimico.padrao);
    _previstoController =
        TextEditingController(text: widget.quimico.previstoTolerancia);
    _unidadeController = TextEditingController(text: widget.quimico.unidade);
  }

  @override
  void dispose() {
    _codigoController.dispose();
    _codRefController.dispose();
    _descricaoController.dispose();
    _padraoController.dispose();
    _previstoController.dispose();
    _unidadeController.dispose();
    super.dispose();
  }

  Future<void> _selecionarProdutoQuimico() async {
    final selecionado = await showDialog<Map<String, String>>(
      context: context,
      builder: (ctx) {
        return SimpleDialog(
          title: const Text('Selecionar produto químico'),
          children: _produtosQuimicos.map((produto) {
            final codigo = produto['codigo'] ?? '';
            final ref = produto['ref'] ?? '';
            final descricao = produto['descricao'] ?? '';
            final label = '$codigo - $ref - $descricao';

            return SimpleDialogOption(
              onPressed: () => Navigator.pop(ctx, produto),
              child: Text(label),
            );
          }).toList(),
        );
      },
    );

    if (selecionado != null) {
      setState(() {
        _codigoController.text = (selecionado['codigo'] ?? '').toUpperCase();
        _codRefController.text = selecionado['ref'] ?? '';
        _descricaoController.text = selecionado['descricao'] ?? '';
      });
    }
  }

  Future<void> _selecionarUnidade() async {
    final unidadeSelecionada = await showDialog<String>(
      context: context,
      builder: (ctx) {
        return SimpleDialog(
          title: const Text('Selecionar unidade'),
          children: _unidades.map((u) {
            return SimpleDialogOption(
              onPressed: () => Navigator.pop(ctx, u),
              child: Text(u),
            );
          }).toList(),
        );
      },
    );

    if (unidadeSelecionada != null) {
      setState(() {
        _unidadeController.text = unidadeSelecionada;
      });
    }
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;

    final quimicoAtualizado = ProdutoQuimico(
      seq: widget.quimico.seq,
      codProdutoComp: _codigoController.text.trim().toUpperCase(),
      codRef: _codRefController.text.trim(),
      descricao: _descricaoController.text.trim(),
      padrao: _padraoController.text.trim(),
      previstoTolerancia: _previstoController.text.trim(),
      unidade: _unidadeController.text.trim(),
    );

    Navigator.of(context).pop(quimicoAtualizado);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar Produto Químico'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _codigoController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Cód. Prod.',
                suffixIcon: Icon(Icons.arrow_drop_down),
              ),
              textCapitalization: TextCapitalization.characters,
              onTap: _selecionarProdutoQuimico,
              validator: (v) => (v == null || v.isEmpty) ? 'Obrigatório' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _codRefController,
              decoration: const InputDecoration(labelText: 'Cód. Ref.'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descricaoController,
              decoration: const InputDecoration(labelText: 'Descrição'),
              validator: (v) => (v == null || v.isEmpty) ? 'Obrigatório' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _padraoController,
              decoration: const InputDecoration(labelText: 'Padrão'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _previstoController,
              decoration: const InputDecoration(labelText: 'Previsto/Toler.'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _unidadeController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Unidade',
                suffixIcon: Icon(Icons.arrow_drop_down),
              ),
              onTap: _selecionarUnidade,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _salvar,
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
