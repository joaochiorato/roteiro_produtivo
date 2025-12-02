import 'package:flutter/material.dart';
import 'operacao_list_page.dart';

class OperacaoDetailPage extends StatefulWidget {
  final Operacao? operacao;

  const OperacaoDetailPage({super.key, this.operacao});

  @override
  State<OperacaoDetailPage> createState() => _OperacaoDetailPageState();
}

class _OperacaoDetailPageState extends State<OperacaoDetailPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _codOperacaoController;
  late TextEditingController _descOperacaoController;
  String _codTipoMv = 'C901';
  String _status = 'Ativo';

  @override
  void initState() {
    super.initState();
    final operacao = widget.operacao;

    _codOperacaoController = TextEditingController(
      text: operacao?.codOperacao.toString() ?? '',
    );
    _descOperacaoController = TextEditingController(
      text: operacao?.descOperacao ?? '',
    );
    _codTipoMv = operacao?.codTipoMv ?? 'C901';
    _status = operacao?.status ?? 'Ativo';
  }

  @override
  void dispose() {
    _codOperacaoController.dispose();
    _descOperacaoController.dispose();
    super.dispose();
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;

    final codOperacao = int.tryParse(_codOperacaoController.text);
    if (codOperacao == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Código da operação inválido.')),
      );
      return;
    }

    // Verifica duplicidade (apenas se for novo)
    if (widget.operacao == null) {
      final existe = operacoesCadastradas.any((o) => o.codOperacao == codOperacao);
      if (existe) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Já existe uma operação com este código.')),
        );
        return;
      }
    }

    final nova = Operacao(
      codOperacao: codOperacao,
      descOperacao: _descOperacaoController.text.trim().toUpperCase(),
      codTipoMv: _codTipoMv,
      status: _status,
    );

    Navigator.of(context).pop(nova);
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
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: _codOperacaoController,
                      decoration: const InputDecoration(
                        labelText: 'Cód. Operação',
                        border: OutlineInputBorder(),
                        isDense: true,
                        hintText: 'Ex: 1000',
                      ),
                      keyboardType: TextInputType.number,
                      readOnly: isEdicao, // Não permite editar código em edição
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Informe o código.' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _descOperacaoController,
                      decoration: const InputDecoration(
                        labelText: 'Descrição',
                        border: OutlineInputBorder(),
                        isDense: true,
                        hintText: 'Ex: REMOLHO',
                      ),
                      textCapitalization: TextCapitalization.characters,
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Informe a descrição.' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: DropdownButtonFormField<String>(
                      value: _codTipoMv,
                      decoration: const InputDecoration(
                        labelText: 'Tipo Movimento',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      items: const [
                        DropdownMenuItem(value: 'C901', child: Text('C901')),
                        DropdownMenuItem(value: 'C902', child: Text('C902')),
                        DropdownMenuItem(value: 'C903', child: Text('C903')),
                        DropdownMenuItem(value: 'C904', child: Text('C904')),
                        DropdownMenuItem(value: 'C905', child: Text('C905')),
                      ],
                      onChanged: (v) {
                        if (v == null) return;
                        setState(() => _codTipoMv = v);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: DropdownButtonFormField<String>(
                      value: _status,
                      decoration: const InputDecoration(
                        labelText: 'Status',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Ativo',
                          child: Text('Ativo'),
                        ),
                        DropdownMenuItem(
                          value: 'Inativo',
                          child: Text('Inativo'),
                        ),
                      ],
                      onChanged: (v) {
                        if (v == null) return;
                        setState(() => _status = v);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
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
}
