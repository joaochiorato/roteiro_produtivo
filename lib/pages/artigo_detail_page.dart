import 'package:flutter/material.dart';
import 'artigo_list_page.dart';

/// Página de cadastro/edição de Artigo
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

    _codProdutoRPController = TextEditingController(text: artigo?.codProdutoRP ?? '');
    _nomeArtigoController = TextEditingController(text: artigo?.nomeArtigo ?? '');
    _nomeRoteiroController = TextEditingController(text: artigo?.nomeRoteiro ?? '');
    _opcaoPcpController = TextEditingController(text: artigo?.opcaoPcp.toString() ?? '0');
    _codClassifController = TextEditingController(text: artigo?.codClassif.toString() ?? '');
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
              _sectionTitle('Dados do Artigo'),
              const SizedBox(height: 16),

              // Linha 1: Código Artigo e Cod Ref.
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _codClassifController,
                      decoration: const InputDecoration(
                        labelText: 'Código Artigo',
                        hintText: 'Ex: 7',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (v) => (v == null || v.isEmpty) ? 'Informe o código.' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _opcaoPcpController,
                      decoration: const InputDecoration(
                        labelText: 'Cod Ref.',
                        hintText: 'Ex: 0',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Linha 2: Código e Nome do Artigo
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _codProdutoRPController,
                      decoration: const InputDecoration(
                        labelText: 'Código',
                        hintText: 'Ex: PRP001',
                      ),
                      textCapitalization: TextCapitalization.characters,
                      validator: (v) => (v == null || v.isEmpty) ? 'Informe o código.' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _nomeArtigoController,
                      decoration: const InputDecoration(
                        labelText: 'Nome do Artigo',
                        hintText: 'Ex: QUARTZO',
                      ),
                      textCapitalization: TextCapitalization.characters,
                      validator: (v) => (v == null || v.isEmpty) ? 'Informe o nome.' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Linha 3: Nome do Roteiro
              TextFormField(
                controller: _nomeRoteiroController,
                decoration: const InputDecoration(
                  labelText: 'Nome do Roteiro',
                  hintText: 'Ex: Roteiro QUARTZO PRP001',
                ),
              ),
              const SizedBox(height: 16),

              // Linha 4: Status
              DropdownButtonFormField<String>(
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
