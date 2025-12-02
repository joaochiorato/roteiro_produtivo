import 'package:flutter/material.dart';
import 'operacao_list_page.dart';
import 'roteiro_list_page.dart';

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
      unidade: 'Bar.',
    ),
    VariavelControle(
      seq: '2',
      descricao: 'Pressão do Rolo(2º manômetro)',
      padrao: '60 a 110',
      previstoTolerancia: '',
      unidade: 'Bar.',
    ),
    VariavelControle(
      seq: '3',
      descricao: 'Velocidade do Feltro',
      padrao: '15 +/- 3',
      previstoTolerancia: '',
      unidade: 'm/min',
    ),
    VariavelControle(
      seq: '4',
      descricao: 'Velocidade do Tapete',
      padrao: '13 +/- 3',
      previstoTolerancia: '',
      unidade: 'm/min',
    ),
  ],
  1002: [
    VariavelControle(
      seq: '1',
      descricao: 'Velocidade da Máquina',
      padrao: '23 +/- 2',
      previstoTolerancia: '',
      unidade: 'm/min',
    ),
    VariavelControle(
      seq: '2',
      descricao: 'Distância da Navalha',
      padrao: '8,0 a 8,5',
      previstoTolerancia: '',
      unidade: 'mm',
    ),
    VariavelControle(
      seq: '3',
      descricao: 'Fio da Navalha Inferior',
      padrao: '5,0 +/- 0,5',
      previstoTolerancia: '',
      unidade: 'mm',
    ),
    VariavelControle(
      seq: '4',
      descricao: 'Fio da Navalha Superior',
      padrao: '6,0 +/- 0,5',
      previstoTolerancia: '',
      unidade: 'mm',
    ),
  ],
};

final Map<int, List<ProdutoQuimico>> quimicosPorOperacaoMock = {
  1000: [
    ProdutoQuimico(
      seq: '2',
      codProdutoComp: '89396',
      codRef: '0',
      descricao: 'CAL VIRGEM 20 KG',
      padrao: '',
      previstoTolerancia: '',
      unidade: 'kg',
    ),
    ProdutoQuimico(
      seq: '3',
      codProdutoComp: '95001',
      codRef: '0',
      descricao: 'SULFETO DE SODIO 60%',
      padrao: '',
      previstoTolerancia: '',
      unidade: 'kg',
    ),
    ProdutoQuimico(
      seq: '4',
      codProdutoComp: '95209',
      codRef: '0',
      descricao: 'TENSOATIVO',
      padrao: '',
      previstoTolerancia: '',
      unidade: 'kg',
    ),
  ],
};

class CadastroRoteiroProdutivoPage extends StatefulWidget {
  final RoteiroConfiguracao? roteiroExistente;

  const CadastroRoteiroProdutivoPage({super.key, this.roteiroExistente});

  @override
  State<CadastroRoteiroProdutivoPage> createState() =>
      _CadastroRoteiroProdutivoPageState();
}

class _CadastroRoteiroProdutivoPageState
    extends State<CadastroRoteiroProdutivoPage> {
  final _formKey = GlobalKey<FormState>();

  Operacao? _operacaoSelecionada;

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

    // Se editando, busca a operação correspondente
    if (roteiro != null) {
      try {
        _operacaoSelecionada = operacoesCadastradas.firstWhere(
          (o) => o.codOperacao == roteiro.codOperacao,
        );
      } catch (_) {}

      _postoTrabalho = roteiro.codPosto;
      _status = roteiro.status;

      _carregarVariaveisEQuimicos(roteiro.codOperacao);
    }

    _tempoSetupController = TextEditingController(
      text: roteiro?.tempoSetup ?? '00:00',
    );
    _tempoEsperaController = TextEditingController(
      text: roteiro?.tempoEspera ?? '00:00',
    );
    _tempoRepousoController = TextEditingController(
      text: roteiro?.tempoRepouso ?? '00:00',
    );
    _tempoInicioController = TextEditingController(
      text: roteiro?.tempoInicio ?? '00:00',
    );
    _observacaoController = TextEditingController();
  }

  void _carregarVariaveisEQuimicos(int codOperacao) {
    _variaveis = [...?variaveisPorOperacaoMock[codOperacao]];
    _quimicos = [...?quimicosPorOperacaoMock[codOperacao]];
  }

  void _onOperacaoChanged(Operacao? operacao) {
    if (operacao == null) return;

    setState(() {
      _operacaoSelecionada = operacao;

      // Atualiza posto de trabalho baseado na operação
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

      // Carrega variáveis e químicos
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
            (_variaveis.isEmpty ? 1 : int.parse(_variaveis.last.seq) + 1)
                .toString(),
      ),
    );

    if (novaVariavel != null) {
      setState(() {
        _variaveis.add(novaVariavel);
      });
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
        proximaSeq: (_quimicos.isEmpty ? 1 : int.parse(_quimicos.last.seq) + 1)
            .toString(),
      ),
    );

    if (novoQuimico != null) {
      setState(() {
        _quimicos.add(novoQuimico);
      });
    }
  }

  void _onSalvar() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verifique os campos obrigatórios.')),
      );
      return;
    }

    if (_operacaoSelecionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione uma operação.')),
      );
      return;
    }

    final resultado = RoteiroConfiguracao(
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

    Navigator.of(context).pop(resultado);
  }

  @override
  Widget build(BuildContext context) {
    final isEdicao = widget.roteiroExistente != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
            isEdicao ? 'Editar Roteiro Produtivo' : 'Novo Roteiro Produtivo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _onSalvar,
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
              _sectionTitle('Selecione a Operação'),
              const SizedBox(height: 8),
              _buildOperacaoDropdown(isEdicao),
              if (_operacaoSelecionada != null) ...[
                const SizedBox(height: 12),
                _buildOperacaoInfo(),
              ],
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildDropdown(
                      label: 'Posto de Trabalho',
                      value: _postoTrabalho,
                      items: const ['ENX', 'RML', 'DIV', 'REB', 'TIN', 'CAL'],
                      onChanged: (v) => setState(() => _postoTrabalho = v),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _status,
                      decoration: const InputDecoration(
                        labelText: 'Status',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      items: const [
                        DropdownMenuItem(value: 'Ativo', child: Text('Ativo')),
                        DropdownMenuItem(
                            value: 'Inativo', child: Text('Inativo')),
                      ],
                      onChanged: (v) {
                        if (v != null) setState(() => _status = v);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _sectionTitle('Tempos'),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      label: 'Tempo Setup',
                      controller: _tempoSetupController,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildTextField(
                      label: 'Tempo Espera',
                      controller: _tempoEsperaController,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildTextField(
                      label: 'Tempo Repouso',
                      controller: _tempoRepousoController,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildTextField(
                      label: 'Tempo para Início',
                      controller: _tempoInicioController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildMultilineField(
                label: 'Observação',
                controller: _observacaoController,
              ),
              const SizedBox(height: 24),
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
              _buildVariaveisTable(),
              const SizedBox(height: 24),
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
              _buildQuimicosTable(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOperacaoDropdown(bool isEdicao) {
    if (operacoesCadastradas.isEmpty) {
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
                  'Nenhuma operação cadastrada. Cadastre uma operação primeiro no menu "Cadastro de Operação".',
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Filtra operações que ainda não foram configuradas (exceto a atual em edição)
    final operacoesDisponiveis = operacoesCadastradas.where((op) {
      if (isEdicao && op.codOperacao == widget.roteiroExistente?.codOperacao) {
        return true; // Permite a operação atual em edição
      }
      // Verifica se já existe roteiro configurado para esta operação
      final jaConfigurada = roteirosConfigurados.any(
        (r) => r.codOperacao == op.codOperacao,
      );
      return !jaConfigurada;
    }).toList();

    if (operacoesDisponiveis.isEmpty && !isEdicao) {
      return Card(
        color: Colors.blue.shade50,
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.info, color: Colors.blue),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Todas as operações já possuem roteiro configurado.',
                ),
              ),
            ],
          ),
        ),
      );
    }

    return DropdownButtonFormField<Operacao>(
      value: _operacaoSelecionada,
      decoration: const InputDecoration(
        labelText: 'Operação',
        border: OutlineInputBorder(),
        isDense: true,
      ),
      hint: const Text('Selecione uma operação...'),
      items: operacoesDisponiveis
          .where((o) => o.status == 'Ativo')
          .map(
            (o) => DropdownMenuItem<Operacao>(
              value: o,
              child: Text(o.operacaoFormatada),
            ),
          )
          .toList(),
      onChanged: isEdicao ? null : _onOperacaoChanged,
      validator: (v) => v == null ? 'Selecione uma operação.' : null,
    );
  }

  Widget _buildOperacaoInfo() {
    final op = _operacaoSelecionada!;
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
                    'Operação: ${op.descOperacao}',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Código: ${op.codOperacao} | Tipo Mov.: ${op.codTipoMv}',
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    String? validatorMessage,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        isDense: true,
      ),
      validator: validatorMessage == null
          ? null
          : (value) =>
              (value == null || value.isEmpty) ? validatorMessage : null,
    );
  }

  Widget _buildMultilineField({
    required String label,
    required TextEditingController controller,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: 3,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        isDense: true,
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        isDense: true,
      ),
      items: items
          .map(
            (e) => DropdownMenuItem<String>(
              value: e,
              child: Text(e),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildVariaveisTable() {
    if (_operacaoSelecionada == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Text(
              'Selecione uma operação para ver as variáveis.',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
        ),
      );
    }

    if (_variaveis.isEmpty) {
      return const Text(
        'Nenhuma variável cadastrada para esta operação.',
      );
    }

    return Card(
      child: Table(
        columnWidths: const {
          0: FixedColumnWidth(40),
          1: FlexColumnWidth(),
          2: FixedColumnWidth(140),
          3: FixedColumnWidth(120),
          4: FixedColumnWidth(70),
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
                  'Descrição',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(6),
                child: Text(
                  'Padrão',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(6),
                child: Text(
                  'Previsto/Toler.',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(6),
                child: Text(
                  'Unid',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          ..._variaveis.map(
            (v) => TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: Text(v.seq),
                ),
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: Text(v.descricao),
                ),
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: Text(v.padrao),
                ),
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: Text(v.previstoTolerancia),
                ),
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: Text(v.unidade),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuimicosTable() {
    if (_operacaoSelecionada == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Text(
              'Selecione uma operação para ver os produtos químicos.',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
        ),
      );
    }

    if (_quimicos.isEmpty) {
      return const Text(
        'Nenhum produto químico configurado para esta operação.',
      );
    }

    return Card(
      child: Table(
        columnWidths: const {
          0: FixedColumnWidth(40),
          1: FixedColumnWidth(90),
          2: FixedColumnWidth(70),
          3: FlexColumnWidth(),
          4: FixedColumnWidth(100),
          5: FixedColumnWidth(120),
          6: FixedColumnWidth(70),
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
                  'Cód. Prod.',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(6),
                child: Text(
                  'Cod. Ref.',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(6),
                child: Text(
                  'Descrição',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(6),
                child: Text(
                  'Padrão',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(6),
                child: Text(
                  'Previsto/Toler.',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(6),
                child: Text(
                  'Unid',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          ..._quimicos.map(
            (q) => TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: Text(q.seq),
                ),
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: Text(q.codProdutoComp),
                ),
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: Text(q.codRef),
                ),
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: Text(q.descricao),
                ),
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: Text(q.padrao),
                ),
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: Text(q.previstoTolerancia),
                ),
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: Text(q.unidade),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Dialog para adicionar variável de controle
class _DialogAdicionarVariavel extends StatefulWidget {
  final String proximaSeq;

  const _DialogAdicionarVariavel({required this.proximaSeq});

  @override
  State<_DialogAdicionarVariavel> createState() =>
      _DialogAdicionarVariavelState();
}

class _DialogAdicionarVariavelState extends State<_DialogAdicionarVariavel> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _seqController;
  late TextEditingController _descricaoController;
  late TextEditingController _padraoController;
  late TextEditingController _previstoController;
  late TextEditingController _unidadeController;

  @override
  void initState() {
    super.initState();
    _seqController = TextEditingController(text: widget.proximaSeq);
    _descricaoController = TextEditingController();
    _padraoController = TextEditingController();
    _previstoController = TextEditingController();
    _unidadeController = TextEditingController();
  }

  @override
  void dispose() {
    _seqController.dispose();
    _descricaoController.dispose();
    _padraoController.dispose();
    _previstoController.dispose();
    _unidadeController.dispose();
    super.dispose();
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;

    final variavel = VariavelControle(
      seq: _seqController.text,
      descricao: _descricaoController.text,
      padrao: _padraoController.text,
      previstoTolerancia: _previstoController.text,
      unidade: _unidadeController.text,
    );

    Navigator.of(context).pop(variavel);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Adicionar Variável de Controle'),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 450,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: _seqController,
                      decoration: const InputDecoration(
                        labelText: 'Seq',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: _descricaoController,
                      decoration: const InputDecoration(
                        labelText: 'Descrição',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Informe a descrição.'
                          : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _padraoController,
                      decoration: const InputDecoration(
                        labelText: 'Padrão',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _previstoController,
                      decoration: const InputDecoration(
                        labelText: 'Previsto/Toler.',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _unidadeController,
                      decoration: const InputDecoration(
                        labelText: 'Unidade',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
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

// Dialog para adicionar produto químico
class _DialogAdicionarQuimico extends StatefulWidget {
  final String proximaSeq;

  const _DialogAdicionarQuimico({required this.proximaSeq});

  @override
  State<_DialogAdicionarQuimico> createState() =>
      _DialogAdicionarQuimicoState();
}

class _DialogAdicionarQuimicoState extends State<_DialogAdicionarQuimico> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _seqController;
  late TextEditingController _codProdutoController;
  late TextEditingController _codRefController;
  late TextEditingController _descricaoController;
  late TextEditingController _padraoController;
  late TextEditingController _previstoController;
  late TextEditingController _unidadeController;

  @override
  void initState() {
    super.initState();
    _seqController = TextEditingController(text: widget.proximaSeq);
    _codProdutoController = TextEditingController();
    _codRefController = TextEditingController(text: '0');
    _descricaoController = TextEditingController();
    _padraoController = TextEditingController();
    _previstoController = TextEditingController();
    _unidadeController = TextEditingController();
  }

  @override
  void dispose() {
    _seqController.dispose();
    _codProdutoController.dispose();
    _codRefController.dispose();
    _descricaoController.dispose();
    _padraoController.dispose();
    _previstoController.dispose();
    _unidadeController.dispose();
    super.dispose();
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;

    final quimico = ProdutoQuimico(
      seq: _seqController.text,
      codProdutoComp: _codProdutoController.text,
      codRef: _codRefController.text,
      descricao: _descricaoController.text,
      padrao: _padraoController.text,
      previstoTolerancia: _previstoController.text,
      unidade: _unidadeController.text,
    );

    Navigator.of(context).pop(quimico);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Adicionar Produto Químico'),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: _seqController,
                      decoration: const InputDecoration(
                        labelText: 'Seq',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _codProdutoController,
                      decoration: const InputDecoration(
                        labelText: 'Cód. Produto',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Informe o código.' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: _codRefController,
                      decoration: const InputDecoration(
                        labelText: 'Cod. Ref.',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Informe a descrição.' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _padraoController,
                      decoration: const InputDecoration(
                        labelText: 'Padrão',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _previstoController,
                      decoration: const InputDecoration(
                        labelText: 'Previsto/Toler.',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _unidadeController,
                      decoration: const InputDecoration(
                        labelText: 'Unidade',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
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
