import 'package:flutter/material.dart';
import 'operacao_list_page.dart';
import 'roteiro_list_page.dart';
import 'artigo_list_page.dart';
import 'artigo_roteiro_list_page.dart';

class HomeMenuPage extends StatelessWidget {
  const HomeMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Curtume - Roteiro Produtivo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _MenuButton(
                icon: Icons.category,
                title: 'Cadastro de Artigo',
                subtitle: 'Cadastro de Artigo',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const ArtigoListPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              _MenuButton(
                icon: Icons.build,
                title: 'Cadastro de Operação',
                subtitle: 'Cadastro mestre de operações',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const OperacaoListPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              _MenuButton(
                icon: Icons.settings,
                title: 'Cadastro de Roteiro Produtivo',
                subtitle: 'Configuração de tempos, variáveis e químicos por operação',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const RoteiroListPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              _MenuButton(
                icon: Icons.list_alt,
                title: 'Cadastro Artigo x Roteiro',
                subtitle: 'Vincula artigo às operações do roteiro',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const ArtigoRoteiroListPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MenuButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, size: 36),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
