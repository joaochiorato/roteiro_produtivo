import 'package:flutter/material.dart';
import 'artigo_list_page.dart';

class ArtigoDetailPage extends StatefulWidget {
  final Artigo? artigo;

  const ArtigoDetailPage({super.key, this.artigo});

  @override
  State<ArtigoDetailPage> createState() => _ArtigoDetailPageState();
}

class _ArtigoDetailPageState extends State<ArtigoDetailPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _codProdutoRPController;
  late TextEditingController _nomeArtigoController;
  late TextEditingController _nomeRoteiroController;
  late TextEditingController _opcaoPcpController;
  late TextEditingController _codClassifController;
  String _status = 'Ativo';

  @override
  void initState() {
    super.initState();
    final artigo = widget.artigo;

    _codProdutoRPController = TextEditingController(
      text: artigo?.codProdutoRP ?? '',
    );
    _nomeArtigoController = TextEditingController(
      text: artigo?.nomeArtigo ?? '',
    );
    _nomeRoteiroController = TextEditingController(
      text: artigo?.nomeRoteiro ?? '',
    );
    _opcaoPcpController = TextEditingController(
      text: artigo?.opcaoPcp.toString() ?? '0',
    );
    _codClassifController = TextEditingController(
      text: artigo?.codClassif.toString() ?? '',
    );
    _status = artigo?.status ?? 'Ativo';
  }

  @override
  void dispose() {
    _codProdutoRPController.dispose();
    _nomeArtigoController.dispose();
    _nomeRoteiroController.dispose();
    _opcaoPcpController.dispose();
    _codClassifController.dispose();
    super.dispose();
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;

    final novo = Artigo(
      codProdutoRP: _codProdutoRPController.text.trim().toUpperCase(),
      nomeArtigo: _nomeArtigoController.text.trim().toUpperCase(),
      nomeRoteiro: _nomeRoteiroController.text.trim(),
      opcaoPcp: int.tryParse(_opcaoPcpController.text) ?? 0,
      codClassif: int.tryParse(_codClassifController.text) ?? 0,
      status: _status,
    );

    Navigator.of(context).pop(novo);
  }

  @override
  Widget build(BuildContext context) {
    final isEdicao = widget.artigo != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdicao ? 'Editar Artigo' : 'Novo Artigo'),
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
              _sectionTitle('Dados do Artigo'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: _codClassifController,
                      decoration: const InputDecoration(
                        labelText: 'Codigo Artigo',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      keyboardType: TextInputType.number,
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Informe o código.'
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: _opcaoPcpController,
                      decoration: const InputDecoration(
                        labelText: 'Cod Ref.',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: _codProdutoRPController,
                      decoration: const InputDecoration(
                        labelText: 'Codigo',
                        border: OutlineInputBorder(),
                        isDense: true,
                        hintText: 'Ex: PRP001',
                      ),
                      textCapitalization: TextCapitalization.characters,
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Informe o código.' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _nomeArtigoController,
                      decoration: const InputDecoration(
                        labelText: 'Nome Artigo',
                        border: OutlineInputBorder(),
                        isDense: true,
                        hintText: 'Ex: QUARTZO',
                      ),
                      textCapitalization: TextCapitalization.characters,
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Informe o nome.' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nomeRoteiroController,
                decoration: const InputDecoration(
                  labelText: 'Roteiro Produtivo',
                  border: OutlineInputBorder(),
                  isDense: true,
                  hintText: 'Ex: Roteiro QUARTZO PRP001',
                ),
                validator: (v) => (v == null || v.isEmpty)
                    ? 'Informe o nome do roteiro.'
                    : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
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
