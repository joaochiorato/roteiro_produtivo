import 'package:flutter/material.dart';
import '../models/artigo.dart';
import '../constants/app_constants.dart';
import '../database/database.dart';
import '../widgets/section_title.dart';

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
  late TextEditingController _descArtigoController;
  late TextEditingController _opcaoPcpController;
  late TextEditingController _codClassifController;
  late String _status;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    final artigo = widget.artigo;

    _codProdutoRPController =
        TextEditingController(text: artigo?.codProdutoRP ?? '');
    _nomeArtigoController =
        TextEditingController(text: artigo?.nomeArtigo ?? '');
    _descArtigoController =
        TextEditingController(text: artigo?.descArtigo ?? '');
    _opcaoPcpController =
        TextEditingController(text: artigo?.opcaoPcp.toString() ?? '0');
    _codClassifController =
        TextEditingController(text: artigo?.codClassif.toString() ?? '');
    _status = artigo?.status ?? AppConstants.statusAtivo;
  }

  @override
  void dispose() {
    _codProdutoRPController.dispose();
    _nomeArtigoController.dispose();
    _descArtigoController.dispose();
    _opcaoPcpController.dispose();
    _codClassifController.dispose();
    super.dispose();
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;

    final novo = Artigo(
      codProdutoRP: _codProdutoRPController.text.trim().toUpperCase(),
      nomeArtigo: _nomeArtigoController.text.trim().toUpperCase(),
      descArtigo: _descArtigoController.text.trim().toUpperCase(),
      opcaoPcp: int.tryParse(_opcaoPcpController.text) ?? 0,
      codClassif: int.tryParse(_codClassifController.text) ?? 0,
      status: _status,
    );

    Navigator.of(context).pop(novo);
  }

  Future<void> _selecionarProdutoCodigo() async {
    final selecionado = await showDialog<Map<String, String>>(
      context: context,
      builder: (_) => SimpleDialog(
        title: const Text('Selecionar produto'),
        children: Database.produtosDisponiveis.map((produto) {
          final codigo = produto['codigo'] ?? '';
          final descricao = produto['descricao'] ?? '';

          return SimpleDialogOption(
            onPressed: () => Navigator.pop(context, produto),
            child: Text('$codigo - $descricao'),
          );
        }).toList(),
      ),
    );

    if (selecionado != null) {
      setState(() {
        _codProdutoRPController.text =
            (selecionado['codigo'] ?? '').toUpperCase();
        _nomeArtigoController.text =
            (selecionado['descricao'] ?? '').toUpperCase();
      });
    }
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
              const SectionTitle(text: 'Dados do Artigo'),
              const SizedBox(height: 16),
              _buildFieldsSection(),
              const SizedBox(height: 32),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldsSection() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildCodigoField()),
            const SizedBox(width: 16),
            Expanded(child: _buildCodRefField()),
          ],
        ),
        const SizedBox(height: 16),
        _buildNomeArtigoField(),
        const SizedBox(height: 16),
        _buildCodClassifField(),
        const SizedBox(height: 16),
        _buildDescArtigoField(),
        const SizedBox(height: 16),
        _buildStatusField(),
      ],
    );
  }

  Widget _buildCodClassifField() {
    return TextFormField(
      controller: _codClassifController,
      decoration: const InputDecoration(
        labelText: 'Cod. Artigo',
        hintText: 'Ex: 7',
      ),
      keyboardType: TextInputType.number,
      validator: (v) => (v == null || v.isEmpty) ? 'Informe o código.' : null,
    );
  }

  Widget _buildCodRefField() {
    return TextFormField(
      controller: _opcaoPcpController,
      decoration: const InputDecoration(
        labelText: 'Cod Ref.',
        hintText: 'Ex: 0',
      ),
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildCodigoField() {
    return TextFormField(
      controller: _codProdutoRPController,
      readOnly: true,
      decoration: const InputDecoration(
        labelText: 'Produto Código',
        hintText: 'Ex: PRP001',
        suffixIcon: Icon(Icons.arrow_drop_down),
      ),
      textCapitalization: TextCapitalization.characters,
      onTap: _selecionarProdutoCodigo,
      validator: (v) => (v == null || v.isEmpty) ? 'Informe o código.' : null,
    );
  }

  Widget _buildNomeArtigoField() {
    return TextFormField(
      controller: _nomeArtigoController,
      decoration: const InputDecoration(
        labelText: 'Desc. Produto',
        hintText: 'Ex: COURO SEMI ACABADO',
      ),
      textCapitalization: TextCapitalization.characters,
      validator: (v) => (v == null || v.isEmpty) ? 'Informe o nome.' : null,
    );
  }

  Widget _buildDescArtigoField() {
    return TextFormField(
      controller: _descArtigoController,
      decoration: const InputDecoration(
        labelText: 'Desc. Artigo',
        hintText: 'Ex: QUARTZO',
      ),
      textCapitalization: TextCapitalization.characters,
      validator: (v) => (v == null || v.isEmpty) ? 'Informe a descrição.' : null,
    );
  }

  Widget _buildStatusField() {
    return DropdownButtonFormField<String>(
      value: _status,
      decoration: const InputDecoration(labelText: 'Status'),
      items: AppConstants.statusOptions
          .map((status) => DropdownMenuItem(
                value: status,
                child: Text(status),
              ))
          .toList(),
      onChanged: (v) {
        if (v != null) setState(() => _status = v);
      },
    );
  }

  Widget _buildActionButtons() {
    return Row(
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
    );
  }
}
