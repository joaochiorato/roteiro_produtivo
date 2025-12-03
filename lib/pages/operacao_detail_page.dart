import 'package:flutter/material.dart';
import 'operacao_list_page.dart';

/// Lista de Tipos de Movimento disponíveis
final List<Map<String, String>> tiposMovimento = [
  {'codigo': 'C901', 'descricao': 'C901 - Remolho'},
  {'codigo': 'C902', 'descricao': 'C902 - Enxugadeira'},
  {'codigo': 'C903', 'descricao': 'C903 - Divisora'},
  {'codigo': 'C904', 'descricao': 'C904 - Rebaixadeira'},
  {'codigo': 'C905', 'descricao': 'C905 - Curtimento'},
  {'codigo': 'C906', 'descricao': 'C906 - Recurtimento'},
  {'codigo': 'C907', 'descricao': 'C907 - Secagem'},
  {'codigo': 'C908', 'descricao': 'C908 - Acabamento'},
  {'codigo': 'C909', 'descricao': 'C909 - Expedição'},
];

/// Página de cadastro/edição de Operação
class OperacaoDetailPage extends StatefulWidget {
  final Operacao? operacao;

  const OperacaoDetailPage({super.key, this.operacao});

  @override
  State<OperacaoDetailPage> createState() => _OperacaoDetailPageState();
}

class _OperacaoDetailPageState extends State<OperacaoDetailPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _codOperacaoController;
  late TextEditingController _descricaoController;
  String? _tipoMovimentoSelecionado;
  String _status = 'Ativo';

  @override
  void initState() {
    super.initState();
    final op = widget.operacao;

    _codOperacaoController = TextEditingController(text: op?.codOperacao.toString() ?? '');
    _descricaoController = TextEditingController(text: op?.descricao ?? '');
    _tipoMovimentoSelecionado = op?.tipoMovimento;
    _status = op?.status ?? 'Ativo';
  }

  @override
  void dispose() {
    _codOperacaoController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;

    final novo = Operacao(
      codOperacao: int.tryParse(_codOperacaoController.text) ?? 0,
      descricao: _descricaoController.text.trim().toUpperCase(),
      tipoMovimento: _tipoMovimentoSelecionado ?? '',
      status: _status,
    );

    Navigator.of(context).pop(novo);
  }

  void _mostrarListaMovimentos() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Selecionar Tipo de Movimento'),
        content: SizedBox(
          width: 400,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: tiposMovimento.length,
            itemBuilder: (context, index) {
              final tipo = tiposMovimento[index];
              final isSelected = _tipoMovimentoSelecionado == tipo['codigo'];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: isSelected ? Colors.blue : Colors.grey.shade200,
                  child: Text(
                    tipo['codigo']!.substring(0, 2),
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? Colors.white : Colors.grey.shade700,
                    ),
                  ),
                ),
                title: Text(tipo['descricao']!),
                selected: isSelected,
                selectedTileColor: Colors.blue.shade50,
                onTap: () {
                  setState(() {
                    _tipoMovimentoSelecionado = tipo['codigo'];
                  });
                  Navigator.pop(ctx);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdicao = widget.operacao != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdicao ? 'Editar Operação' : 'Nova Operação'),
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
              _sectionTitle('Dados da Operação'),
              const SizedBox(height: 16),

              // Linha 1: Código e Descrição
              Row(
                children: [
                  SizedBox(
                    width: 150,
                    child: TextFormField(
                      controller: _codOperacaoController,
                      decoration: const InputDecoration(
                        labelText: 'Código',
                        hintText: 'Ex: 1000',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (v) => (v == null || v.isEmpty) ? 'Informe o código.' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _descricaoController,
                      decoration: const InputDecoration(
                        labelText: 'Descrição',
                        hintText: 'Ex: REMOLHO',
                      ),
                      textCapitalization: TextCapitalization.characters,
                      validator: (v) => (v == null || v.isEmpty) ? 'Informe a descrição.' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Linha 2: Tipo Movimento (com botão listar) e Status
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: _mostrarListaMovimentos,
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Tipo Movimento',
                              suffixIcon: Icon(Icons.arrow_drop_down),
                            ),
                            child: Text(
                              _tipoMovimentoSelecionado ?? 'Selecione...',
                              style: TextStyle(
                                color: _tipoMovimentoSelecionado != null 
                                    ? Colors.black 
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                                              ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _status,
                      decoration: const InputDecoration(
                        labelText: 'Status',
                      ),
                      items: const [
                        DropdownMenuItem(value: 'Ativo', child: Text('Ativo')),
                        DropdownMenuItem(value: 'Inativo', child: Text('Inativo')),
                      ],
                      onChanged: (v) => setState(() => _status = v!),
                    ),
                  ),
                ],
              ),
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
}
