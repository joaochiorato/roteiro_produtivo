# Protótipo Roteiro Produtivo - Curtume ATAK

Projeto Flutter com menu front-end para Cadastro de Roteiro Produtivo.

## Estrutura do Menu

O menu principal contém os seguintes submenus:

1. **Cadastro de Artigo** - Cadastro de artigos (tbClassifAnimal)
2. **Cadastro de Operação** - Cadastro mestre de operações (tbCodOperacao)
3. **Cadastro de Roteiro Produtivo** - Configuração de tempos, variáveis e químicos por operação
4. **Cadastro Artigo x Roteiro** - Vincula artigo às operações do roteiro (tbSeqOperacao)

## Layout Visual

O layout foi desenvolvido seguindo o estilo visual do ERP ATAK:
- Cards de menu com ícones e descrições
- Cores neutras e profissionais
- Breadcrumb e data no cabeçalho
- Espaçamentos e bordas suaves
- Tema limpo e organizado

## Como Executar

1. Certifique-se de ter o Flutter instalado
2. Na pasta do projeto, execute:

```bash
flutter pub get
flutter create .
flutter run -d chrome
```

Para Windows/Desktop:
```bash
flutter run -d windows
```

## Estrutura de Arquivos

```
lib/
├── main.dart                    # Entry point principal
└── pages/
    ├── home_menu_page.dart      # Menu principal (estilo ATAK)
    ├── artigo_list_page.dart    # Lista de artigos
    ├── artigo_detail_page.dart  # Cadastro/edição de artigo
    ├── operacao_list_page.dart  # Lista de operações
    ├── operacao_detail_page.dart# Cadastro/edição de operação
    ├── roteiro_list_page.dart   # Lista de roteiros
    ├── roteiro_detail_page.dart # Cadastro/edição de roteiro
    ├── artigo_roteiro_list_page.dart   # Lista artigo x roteiro
    └── artigo_roteiro_detail_page.dart # Vínculo artigo x roteiro
```

## Dados Mockados

Todos os dados são mantidos em memória (listas globais), sem banco de dados ou APIs reais.
O protótipo já vem com dados de exemplo:
- Artigo: PRP001 - QUARTZO
- Operações: REMOLHO, ENXUGADEIRA, DIVISORA
- Roteiros configurados com variáveis e químicos

## Regras de Negócio

Nenhuma regra de negócio foi alterada. O protótipo mantém:
- Fluxo de navegação existente
- Estrutura de dados original
- Comportamento e validações existentes
