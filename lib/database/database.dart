import '../models/artigo.dart';
import '../models/artigo_roteiro_header.dart';
import '../models/operacao.dart';
import '../models/posto_trabalho.dart';
import '../models/produto_quimico.dart';
import '../models/quimico.dart';
import '../models/roteiro_configuracao.dart';
import '../models/seq_roteiro.dart';
import '../models/variavel_controle.dart';

/// Simulação de banco de dados em memória
/// Todos os dados mockados ficam centralizados aqui
class Database {
  // ==================== TABELA: ARTIGOS ====================
  static final List<Artigo> artigos = [
    Artigo(
      codProdutoRP: 'PRP001',
      nomeArtigo: 'COURO WET BLUE',
      descArtigo: 'QUARTZO CHOKWANG',
      opcaoPcp: 0,
      codClassif: 1,
      status: 'Ativo',
    ),

  ];

  // ==================== TABELA: ARTIGO_ROTEIRO_HEADER ====================
  static final List<ArtigoRoteiroHeader> artigoRoteiroHeaders = [
    ArtigoRoteiroHeader(
      codClassif: 1,
      codProdutoRP: 'PRP001',
      codRefRP: 0,
      nomeArtigo: 'COURO SEMI ACABADO',
      descArtigo: 'QUARTZO',
      opcaoPcp: 0,
      status: 'Ativo',
    ),
  ];

  // ==================== TABELA: ROTEIROS ====================
  static final List<RoteiroConfiguracao> roteiros = [
    RoteiroConfiguracao(
      codOperacao: 1000,
      descOperacao: 'REMOLHO',
      codTipoMv: 'C900',
      codPosto: 'RML',
      tempoSetup: '00:00',
      tempoEspera: '00:00',
      tempoRepouso: '00:00',
      tempoInicio: '00:00',
      status: 'Ativo',
    ),
    RoteiroConfiguracao(
      codOperacao: 1001,
      descOperacao: 'ENXUGADEIRA',
      codTipoMv: 'C901',
      codPosto: 'ENX',
      tempoSetup: '00:00',
      tempoEspera: '00:00',
      tempoRepouso: '00:00',
      tempoInicio: '00:00',
      status: 'Ativo',
    ),
    RoteiroConfiguracao(
      codOperacao: 1002,
      descOperacao: 'DIVISORA',
      codTipoMv: 'C902',
      codPosto: 'DIV',
      tempoSetup: '00:00',
      tempoEspera: '00:00',
      tempoRepouso: '00:00',
      tempoInicio: '00:00',
      status: 'Ativo',
    ),
    RoteiroConfiguracao(
      codOperacao: 1003,
      descOperacao: 'REBAIXADEIRA',
      codTipoMv: 'C903',
      codPosto: 'RBX',
      tempoSetup: '00:00',
      tempoEspera: '00:00',
      tempoRepouso: '00:00',
      tempoInicio: '00:00',
      status: 'Ativo',
    ),
    RoteiroConfiguracao(
      codOperacao: 1004,
      descOperacao: 'REFILA',
      codTipoMv: 'C904',
      codPosto: 'RFL',
      tempoSetup: '00:00',
      tempoEspera: '00:00',
      tempoRepouso: '00:00',
      tempoInicio: '00:00',
      status: 'Ativo',
    ),
  ];

  // ==================== TABELA: SEQ_ROTEIRO ====================
  static final Map<String, List<SeqRoteiro>> seqRoteiros = {
    'PRP001': [
      SeqRoteiro(
        codProduto: 'PRP001',
        codRef: 0,
        codOperacao: 1000,
        descOperacao: 'REMOLHO',
        codPosto: 'RML',
        opcaoPcp: 0,
        seq: 1,
      ),
      SeqRoteiro(
        codProduto: 'PRP001',
        codRef: 0,
        codOperacao: 1001,
        descOperacao: 'ENXUGADEIRA',
        codPosto: 'ENX',
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
      SeqRoteiro(
        codProduto: 'PRP001',
        codRef: 0,
        codOperacao: 1003,
        descOperacao: 'REBAIXADEIRA',
        codPosto: 'RBX',
        opcaoPcp: 0,
        seq: 4,
      ),
      SeqRoteiro(
        codProduto: 'PRP001',
        codRef: 0,
        codOperacao: 1004,
        descOperacao: 'REFILA',
        codPosto: 'RFL',
        opcaoPcp: 0,
        seq: 5,
      ),
    ],
  };

  // ==================== TABELA: OPERACOES ====================
  static final List<Operacao> operacoes = [
    Operacao(
      codOperacao: 1000,
      descOperacao: 'REMOLHO',
      codTipoMv: 'C900',
      status: 'Ativo',
    ),
    Operacao(
      codOperacao: 1001,
      descOperacao: 'ENXUGADEIRA',
      codTipoMv: 'C901',
      status: 'Ativo',
    ),
    Operacao(
      codOperacao: 1002,
      descOperacao: 'DIVISORA',
      codTipoMv: 'C902',
      status: 'Ativo',
    ),
    Operacao(
      codOperacao: 1003,
      descOperacao: 'REBAIXADEIRA',
      codTipoMv: 'C903',
      status: 'Ativo',
    ),
    Operacao(
      codOperacao: 1004,
      descOperacao: 'REFILA',
      codTipoMv: 'C904',
      status: 'Ativo',
    ),
  ];

  // ==================== TABELA: POSTOS_TRABALHO ====================
  static final List<PostoTrabalho> postosTrabalho = [
    PostoTrabalho(
      codPosto: 'RML',
      descPosto: 'Remolho',
      status: 'Ativo',
    ),
    PostoTrabalho(
      codPosto: 'ENX',
      descPosto: 'Enxugadeira',
      status: 'Ativo',
    ),
    PostoTrabalho(
      codPosto: 'DIV',
      descPosto: 'Divisora',
      status: 'Ativo',
    ),
    PostoTrabalho(
      codPosto: 'RBX',
      descPosto: 'Rebaixadeira',
      status: 'Ativo',
    ),
    PostoTrabalho(
      codPosto: 'RFL',
      descPosto: 'Refila',
      status: 'Ativo',
    ),
  ];

  // ==================== TABELA: QUIMICOS ====================
  static final List<Quimico> quimicos = [];

  // ==================== TABELA: VARIAVEIS_CONTROLE ====================
  static final Map<int, List<VariavelControle>> variaveisControle = {
    1000: [
      // REMOLHO
      VariavelControle(
        seq: '1',
        descricao: 'Volume de Água',
        previstoTolerancia: '100',
        padrao: '100% peso líquido do lote',
        unidade: 'Litros',
      ),
      VariavelControle(
        seq: '2',
        descricao: 'Temperatura da Água (dentro do fulão remolho)',
        previstoTolerancia: '60',
        padrao: '60 +/- 10',
        unidade: '°C',
      ),
      VariavelControle(
        seq: '3',
        descricao: 'Tensoativo',
        previstoTolerancia: '5',
        padrao: '5 +/- 0.200',
        unidade: 'Litros',
      ),
    ],
    1001: [
      // ENXUGADEIRA
      VariavelControle(
        seq: '1',
        descricao: 'Pressão do Rolo (1º manômetro)',
        previstoTolerancia: '75',
        padrao: '40 a 110',
        unidade: 'Bar.',
      ),
      VariavelControle(
        seq: '2',
        descricao: 'Pressão do Rolo (2º e 3º manômetro)',
        previstoTolerancia: '85',
        padrao: '60 a 110',
        unidade: 'Bar.',
      ),
      VariavelControle(
        seq: '3',
        descricao: 'Velocidade do Feltro',
        previstoTolerancia: '15',
        padrao: '15 +/- 3',
        unidade: 'mt/min.',
      ),
      VariavelControle(
        seq: '4',
        descricao: 'Velocidade do Tapete',
        previstoTolerancia: '13',
        padrao: '13 +/- 3',
        unidade: 'mt/min.',
      ),
    ],
    1002: [
      // DIVISORA
      VariavelControle(
        seq: '1',
        descricao: 'Velocidade da Máquina',
        previstoTolerancia: '23',
        padrao: '23 +/- 2',
        unidade: 'metro/minuto',
      ),
      VariavelControle(
        seq: '2',
        descricao: 'Distância da Navalha',
        previstoTolerancia: '8.25',
        padrao: '23 +/- 2',
        unidade: 'mm',
      ),
      VariavelControle(
        seq: '3',
        descricao: 'Fio da Navalha Inferior',
        previstoTolerancia: '5.0',
        padrao: '5,0 +/- 0,5',
        unidade: 'mm',
      ),
      VariavelControle(
        seq: '4',
        descricao: 'Fio da Navalha Superior',
        previstoTolerancia: '6.0',
        padrao: '6,0 +/- 0,5',
        unidade: 'mm',
      ),
    ],
    1003: [
      // REBAIXADEIRA
      VariavelControle(
        seq: '1',
        descricao: 'Velocidade do Rolo de Transporte',
        previstoTolerancia: '11',
        padrao: '10/12',
        unidade: '',
      ),
      VariavelControle(
        seq: '2',
        descricao: 'Espessura e rebaixe',
        previstoTolerancia: '1.3',
        padrao: '1.2/1.3',
        unidade: '',
      ),
    ],
    1004: [
      // REFILA
      VariavelControle(
        seq: '1',
        descricao: 'PESO LÍQUIDO',
        previstoTolerancia: '',
        padrao: '',
        unidade: 'KGS',
      ),
      VariavelControle(
        seq: '2',
        descricao: 'PESO DO REFILE',
        previstoTolerancia: '',
        padrao: '',
        unidade: 'KGS',
      ),
      VariavelControle(
        seq: '3',
        descricao: 'PESO DO CUPIM',
        previstoTolerancia: '',
        padrao: '',
        unidade: 'KGS',
      ),
    ],
  };

  // ==================== TABELA: PRODUTOS_QUIMICOS ====================
  static final Map<int, List<ProdutoQuimico>> produtosQuimicos = {
    1000: [
      // REMOLHO
      ProdutoQuimico(
        seq: '1',
        codProdutoComp: '89396',
        codRef: '0',
        descricao: 'CAL VIRGEM 20 KG',
        padrao: '8.0 ± 0.5',
        previstoTolerancia: '8.0',
        unidade: 'kg',
      ),
      ProdutoQuimico(
        seq: '2',
        codProdutoComp: '95001',
        codRef: '0',
        descricao: 'SULFETO DE SODIO 60%',
        padrao: '2.5 ± 0.3',
        previstoTolerancia: '2.5',
        unidade: 'kg',
      ),
      ProdutoQuimico(
        seq: '3',
        codProdutoComp: '95209',
        codRef: '0',
        descricao: 'TENSOATIVO',
        padrao: '0.5 ± 0.1',
        previstoTolerancia: '0.5',
        unidade: 'kg',
      ),
    ],
  };

  // ==================== PRODUTOS DISPONÍVEIS ====================
  static final List<Map<String, String>> produtosDisponiveis = [
    {'codigo': 'PRP001', 'descricao': 'COURO WET BLUE'},
    {'codigo': 'PRP002', 'descricao': 'COURO SEMI ACABADO'},
    {'codigo': 'PRP003', 'descricao': 'COURO ACABADO'},
  ];

  /// Limpa todos os dados (útil para testes)
  static void clearAll() {
    artigos.clear();
    artigoRoteiroHeaders.clear();
    roteiros.clear();
    seqRoteiros.clear();
    operacoes.clear();
    postosTrabalho.clear();
    quimicos.clear();
  }

  /// Reseta para dados iniciais
  static void resetToDefaults() {
    clearAll();

    // Recarrega dados padrão
    artigos.add(Artigo(
      codProdutoRP: 'PRP001',
      nomeArtigo: 'COURO SEMI ACABADO',
      descArtigo: '',
      opcaoPcp: 0,
      codClassif: 1,
      status: 'Ativo',
    ));

    // ... adicionar outros dados padrão conforme necessário
  }
}
