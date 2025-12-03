import 'package:flutter/material.dart';
import 'artigo_list_page.dart';
import 'operacao_list_page.dart';
import 'roteiro_list_page.dart';
import 'artigo_roteiro_list_page.dart';
import 'artigo_detail_page.dart';
import 'operacao_detail_page.dart';
import 'roteiro_detail_page.dart';
import 'artigo_roteiro_detail_page.dart';

/// Página principal com layout ERP ATAK
/// Menu lateral + Área de conteúdo
class HomeMenuPage extends StatefulWidget {
  const HomeMenuPage({super.key});

  @override
  State<HomeMenuPage> createState() => _HomeMenuPageState();
}

class _HomeMenuPageState extends State<HomeMenuPage> {
  // Controle do menu expandido
  bool _roteiroExpanded = true;
  
  // Página atual selecionada
  int _selectedIndex = 0;
  
  // Títulos para o breadcrumb
  final List<String> _titulos = [
    'Cadastro de Artigo',
    'Cadastro de Operação',
    'Cadastro de Roteiro Produtivo',
    'Cadastro Artigo x Roteiro',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          // === CABEÇALHO ===
          _buildHeader(),
          
          // === CORPO (SIDEBAR + CONTEÚDO) ===
          Expanded(
            child: Row(
              children: [
                // Menu Lateral
                _buildSidebar(),
                
                // Área de Conteúdo
                Expanded(
                  child: _buildContentArea(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Cabeçalho estilo ATAK
  Widget _buildHeader() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Logo ATAK
          Container(
            width: 250,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // Ícone/Logo - Círculo preto com pirâmide
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Color(0xFF212121),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: CustomPaint(
                      size: const Size(18, 16),
                      painter: _PyramidLogoPainter(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Atak Sistemas',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF212121),
                  ),
                ),
              ],
            ),
          ),
          
          // Botão Menu (hambúrguer)
          Container(
            margin: const EdgeInsets.only(left: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(4),
            ),
            child: IconButton(
              icon: const Icon(Icons.menu, color: Color(0xFF616161)),
              onPressed: () {},
              tooltip: 'Menu',
            ),
          ),
          
          const Spacer(),
          
          // Empresa atual
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Empresa atual',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF757575),
                      ),
                    ),
                    const Text(
                      'ADM',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF212121),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Icon(Icons.inbox_outlined, color: Colors.grey.shade600),
                const SizedBox(width: 12),
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.grey.shade300,
                  child: Icon(Icons.person, color: Colors.grey.shade600, size: 22),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Menu lateral (Sidebar)
  Widget _buildSidebar() {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(height: 8),
          
          // Item principal: Roteiro Produtivo (expansível)
          _buildMenuItemExpansible(
            icon: Icons.settings,
            title: 'Roteiro Produtivo',
            isExpanded: _roteiroExpanded,
            onTap: () {
              setState(() {
                _roteiroExpanded = !_roteiroExpanded;
              });
            },
          ),
          
          // Submenus (visíveis quando expandido)
          if (_roteiroExpanded) ...[
            _buildSubMenuItem(
              title: 'Cadastro de Artigo',
              index: 0,
            ),
            _buildSubMenuItem(
              title: 'Cadastro de Operação',
              index: 1,
            ),
            _buildSubMenuItem(
              title: 'Cadastro de Roteiro Produtivo',
              index: 2,
            ),
            _buildSubMenuItem(
              title: 'Cadastro Artigo x Roteiro',
              index: 3,
            ),
          ],
        ],
      ),
    );
  }

  /// Item de menu expansível
  Widget _buildMenuItemExpansible({
    required IconData icon,
    required String title,
    required bool isExpanded,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF616161), size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF212121),
                ),
              ),
            ),
            Icon(
              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: const Color(0xFF616161),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  /// Submenu item
  Widget _buildSubMenuItem({
    required String title,
    required int index,
  }) {
    final isSelected = _selectedIndex == index;
    
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE3F2FD) : null,
          border: isSelected
              ? const Border(
                  left: BorderSide(color: Color(0xFF1976D2), width: 3),
                )
              : null,
        ),
        child: Row(
          children: [
            const SizedBox(width: 34),
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF1976D2) : const Color(0xFF9E9E9E),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  color: isSelected ? const Color(0xFF1976D2) : const Color(0xFF616161),
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            ),
            if (isSelected)
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF4CAF50),
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Área de conteúdo principal
  Widget _buildContentArea() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTopBar(),
        Expanded(
          child: _buildPageContent(),
        ),
      ],
    );
  }

  /// Barra superior com breadcrumb e data
  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          Text(
            'Roteiro Produtivo',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text('/', style: TextStyle(color: Colors.grey)),
          ),
          Text(
            _titulos[_selectedIndex],
            style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
          ),
          const Spacer(),
          Text(
            'Data Movimento: ${_formatDataAtual()}',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  String _formatDataAtual() {
    final now = DateTime.now();
    final dias = ['Domingo', 'Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta', 'Sábado'];
    final meses = [
      '', 'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
      'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
    ];
    return '${dias[now.weekday % 7]}, ${now.day} de ${meses[now.month]} de ${now.year}';
  }

  Widget _buildPageContent() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: _getPage(_selectedIndex),
      ),
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return const ArtigoListPageContent();
      case 1:
        return const OperacaoListPageContent();
      case 2:
        return const RoteiroListPageContent();
      case 3:
        return const ArtigoRoteiroListPageContent();
      default:
        return const ArtigoListPageContent();
    }
  }
}

// ============================================================
// CONTEÚDOS DAS PÁGINAS (sem AppBar, apenas o body)
// ============================================================

/// Conteúdo da lista de Artigos
class ArtigoListPageContent extends StatefulWidget {
  const ArtigoListPageContent({super.key});

  @override
  State<ArtigoListPageContent> createState() => _ArtigoListPageContentState();
}

class _ArtigoListPageContentState extends State<ArtigoListPageContent> {
  void _abrirDetalhe({Artigo? artigo}) async {
    final result = await Navigator.of(context).push<Artigo>(
      MaterialPageRoute(builder: (_) => ArtigoDetailPage(artigo: artigo)),
    );
    if (result == null) return;
    setState(() {
      if (artigo == null) {
        artigosCadastrados.add(result);
      } else {
        final idx = artigosCadastrados.indexOf(artigo);
        artigosCadastrados[idx] = result;
      }
    });
  }

  void _remover(Artigo artigo) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: Text('Deseja remover o artigo "${artigo.nomeArtigo}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => artigosCadastrados.remove(artigo));
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
    return Column(
      children: [
        _buildHeader('Cadastro de Artigo', Icons.category, () => _abrirDetalhe()),
        Expanded(
          child: artigosCadastrados.isEmpty
              ? _emptyState(Icons.category_outlined, 'Nenhum artigo cadastrado.')
              : _buildTable(),
        ),
      ],
    );
  }

  Widget _buildHeader(String title, IconData icon, VoidCallback onAdd) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade200))),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const Spacer(),
          ElevatedButton.icon(onPressed: onAdd, icon: const Icon(Icons.add, size: 18), label: const Text('Novo')),
        ],
      ),
    );
  }

  Widget _emptyState(IconData icon, String msg) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(msg, style: TextStyle(color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  Widget _buildTable() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Cod. Classif')),
            DataColumn(label: Text('Cod Ref.')),
            DataColumn(label: Text('Artigo')),
            DataColumn(label: Text('Código')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Ações')),
          ],
          rows: artigosCadastrados.map((a) => DataRow(cells: [
            DataCell(Text(a.codClassif.toString())),
            DataCell(Text(a.opcaoPcp.toString())),
            DataCell(Text(a.nomeArtigo)),
            DataCell(Text(a.codProdutoRP)),
            DataCell(_statusBadge(a.status)),
            DataCell(Row(mainAxisSize: MainAxisSize.min, children: [
              IconButton(icon: const Icon(Icons.edit, size: 20), onPressed: () => _abrirDetalhe(artigo: a)),
              IconButton(icon: const Icon(Icons.delete, size: 20, color: Colors.red), onPressed: () => _remover(a)),
            ])),
          ])).toList(),
        ),
      ),
    );
  }

  Widget _statusBadge(String status) {
    final ok = status == 'Ativo';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: ok ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(status, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: ok ? Colors.green.shade700 : Colors.red.shade700)),
    );
  }
}

/// Conteúdo da lista de Operações
class OperacaoListPageContent extends StatefulWidget {
  const OperacaoListPageContent({super.key});

  @override
  State<OperacaoListPageContent> createState() => _OperacaoListPageContentState();
}

class _OperacaoListPageContentState extends State<OperacaoListPageContent> {
  void _abrirDetalhe({Operacao? operacao}) async {
    final result = await Navigator.of(context).push<Operacao>(
      MaterialPageRoute(builder: (_) => OperacaoDetailPage(operacao: operacao)),
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

  void _remover(Operacao op) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: Text('Remover "${op.descricao}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => operacoesCadastradas.remove(op));
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
    return Column(
      children: [
        _buildHeader('Cadastro de Operação', Icons.build, () => _abrirDetalhe()),
        Expanded(
          child: operacoesCadastradas.isEmpty
              ? _emptyState(Icons.build_outlined, 'Nenhuma operação cadastrada.')
              : _buildTable(),
        ),
      ],
    );
  }

  Widget _buildHeader(String title, IconData icon, VoidCallback onAdd) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade200))),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const Spacer(),
          ElevatedButton.icon(onPressed: onAdd, icon: const Icon(Icons.add, size: 18), label: const Text('Novo')),
        ],
      ),
    );
  }

  Widget _emptyState(IconData icon, String msg) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(msg, style: TextStyle(color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  Widget _buildTable() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Código')),
            DataColumn(label: Text('Descrição')),
            DataColumn(label: Text('Tipo Movimento')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Ações')),
          ],
          rows: operacoesCadastradas.map((op) => DataRow(cells: [
            DataCell(Text(op.codOperacao.toString())),
            DataCell(Text(op.descricao)),
            DataCell(Text(op.tipoMovimento)),
            DataCell(_statusBadge(op.status)),
            DataCell(Row(mainAxisSize: MainAxisSize.min, children: [
              IconButton(icon: const Icon(Icons.edit, size: 20), onPressed: () => _abrirDetalhe(operacao: op)),
              IconButton(icon: const Icon(Icons.delete, size: 20, color: Colors.red), onPressed: () => _remover(op)),
            ])),
          ])).toList(),
        ),
      ),
    );
  }

  Widget _statusBadge(String status) {
    final ok = status == 'Ativo';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: ok ? Colors.green.shade50 : Colors.red.shade50, borderRadius: BorderRadius.circular(12)),
      child: Text(status, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: ok ? Colors.green.shade700 : Colors.red.shade700)),
    );
  }
}

/// Conteúdo da lista de Roteiros
class RoteiroListPageContent extends StatefulWidget {
  const RoteiroListPageContent({super.key});

  @override
  State<RoteiroListPageContent> createState() => _RoteiroListPageContentState();
}

class _RoteiroListPageContentState extends State<RoteiroListPageContent> {
  void _abrirCadastro({RoteiroConfiguracao? roteiro}) async {
    final result = await Navigator.of(context).push<RoteiroConfiguracao>(
      MaterialPageRoute(builder: (_) => RoteiroDetailPage(roteiroExistente: roteiro)),
    );
    if (result == null) return;
    setState(() {
      if (roteiro == null) {
        final idx = roteirosConfigurados.indexWhere((r) => r.codOperacao == result.codOperacao);
        if (idx >= 0) {
          roteirosConfigurados[idx] = result;
        } else {
          roteirosConfigurados.add(result);
        }
      } else {
        final idx = roteirosConfigurados.indexOf(roteiro);
        roteirosConfigurados[idx] = result;
      }
    });
  }

  void _remover(RoteiroConfiguracao r) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: Text('Remover "${r.descOperacao}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => roteirosConfigurados.remove(r));
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
    return Column(
      children: [
        _buildHeader('Cadastro de Roteiro Produtivo', Icons.settings, () => _abrirCadastro()),
        Expanded(
          child: roteirosConfigurados.isEmpty
              ? _emptyState(Icons.route_outlined, 'Nenhum roteiro configurado.')
              : _buildTable(),
        ),
      ],
    );
  }

  Widget _buildHeader(String title, IconData icon, VoidCallback onAdd) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade200))),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const Spacer(),
          ElevatedButton.icon(onPressed: onAdd, icon: const Icon(Icons.add, size: 18), label: const Text('Novo')),
        ],
      ),
    );
  }

  Widget _emptyState(IconData icon, String msg) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(msg, style: TextStyle(color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  Widget _buildTable() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Cód. Operação')),
            DataColumn(label: Text('Descrição')),
            DataColumn(label: Text('Tipo Mov.')),
            DataColumn(label: Text('Posto')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Ações')),
          ],
          rows: roteirosConfigurados.map((r) => DataRow(cells: [
            DataCell(Text(r.codOperacao.toString())),
            DataCell(Text(r.descOperacao)),
            DataCell(Text(r.codTipoMv)),
            DataCell(Text(r.codPosto)),
            DataCell(_statusBadge(r.status)),
            DataCell(Row(mainAxisSize: MainAxisSize.min, children: [
              IconButton(icon: const Icon(Icons.edit, size: 20), onPressed: () => _abrirCadastro(roteiro: r)),
              IconButton(icon: const Icon(Icons.delete, size: 20, color: Colors.red), onPressed: () => _remover(r)),
            ])),
          ])).toList(),
        ),
      ),
    );
  }

  Widget _statusBadge(String status) {
    final ok = status == 'Ativo';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: ok ? Colors.green.shade50 : Colors.red.shade50, borderRadius: BorderRadius.circular(12)),
      child: Text(status, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: ok ? Colors.green.shade700 : Colors.red.shade700)),
    );
  }
}

/// Conteúdo da lista de Artigo x Roteiro
class ArtigoRoteiroListPageContent extends StatefulWidget {
  const ArtigoRoteiroListPageContent({super.key});

  @override
  State<ArtigoRoteiroListPageContent> createState() => _ArtigoRoteiroListPageContentState();
}

class _ArtigoRoteiroListPageContentState extends State<ArtigoRoteiroListPageContent> {
  void _abrirDetalhe({ArtigoRoteiroHeader? header}) async {
    final result = await Navigator.of(context).push<ArtigoRoteiroHeader>(
      MaterialPageRoute(builder: (_) => ArtigoRoteiroDetailPage(header: header)),
    );
    if (result == null) return;
    setState(() {
      if (header == null) {
        // Novo vínculo: apenas adiciona à lista,
        // preservando os vínculos já existentes.
        artigosRoteirosCadastrados.add(result);
      } else {
        // Edição: atualiza apenas o item daquela linha.
        final idx = artigosRoteirosCadastrados.indexOf(header);
        if (idx >= 0) {
          artigosRoteirosCadastrados[idx] = result;
        }
      }
    });
  }


  void _remover(ArtigoRoteiroHeader h) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: Text('Remover "${h.nomeArtigo}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => artigosRoteirosCadastrados.remove(h));
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
    return Column(
      children: [
        _buildHeader('Cadastro Artigo x Roteiro', Icons.link, () => _abrirDetalhe()),
        Expanded(
          child: artigosRoteirosCadastrados.isEmpty
              ? _emptyState(Icons.link_off, 'Nenhum vínculo cadastrado.')
              : _buildTable(),
        ),
      ],
    );
  }

  Widget _buildHeader(String title, IconData icon, VoidCallback onAdd) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade200))),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const Spacer(),
          ElevatedButton.icon(onPressed: onAdd, icon: const Icon(Icons.add, size: 18), label: const Text('Novo')),
        ],
      ),
    );
  }

  Widget _emptyState(IconData icon, String msg) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(msg, style: TextStyle(color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  Widget _buildTable() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Cód. Artigo')),
            DataColumn(label: Text('Cód. Produto')),
            DataColumn(label: Text('Artigo')),
            DataColumn(label: Text('Roteiro')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Ações')),
          ],
          rows: artigosRoteirosCadastrados.map((h) => DataRow(cells: [
            DataCell(Text(h.codClassif.toString())),
            DataCell(Text(h.codProdutoRP)),
            DataCell(Text(h.nomeArtigo)),
            DataCell(Text(h.nomeRoteiro)),
            DataCell(_statusBadge(h.status)),
            DataCell(Row(mainAxisSize: MainAxisSize.min, children: [
              IconButton(icon: const Icon(Icons.edit, size: 20), onPressed: () => _abrirDetalhe(header: h)),
              IconButton(icon: const Icon(Icons.delete, size: 20, color: Colors.red), onPressed: () => _remover(h)),
            ])),
          ])).toList(),
        ),
      ),
    );
  }

  Widget _statusBadge(String status) {
    final ok = status == 'Ativo';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: ok ? Colors.green.shade50 : Colors.red.shade50, borderRadius: BorderRadius.circular(12)),
      child: Text(status, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: ok ? Colors.green.shade700 : Colors.red.shade700)),
    );
  }
}

/// Painter para desenhar o logo de pirâmide ATAK
class _PyramidLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Desenha a pirâmide (triângulo)
    final path = Path();
    path.moveTo(size.width / 2, 2); // Topo
    path.lineTo(size.width - 2, size.height - 2); // Canto direito
    path.lineTo(2, size.height - 2); // Canto esquerdo
    path.close();

    canvas.drawPath(path, paint);

    // Linha horizontal no meio da pirâmide
    final linePaint = Paint()
      ..color = const Color(0xFF212121)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawLine(
      Offset(size.width * 0.25, size.height * 0.6),
      Offset(size.width * 0.75, size.height * 0.6),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
