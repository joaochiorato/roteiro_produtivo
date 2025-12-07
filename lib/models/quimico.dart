class Quimico {
  final String codigo;
  final String descricao;
  final String unidade;
  final String status;

  Quimico({
    required this.codigo,
    required this.descricao,
    required this.unidade,
    required this.status,
  });

  bool get isAtivo => status == 'Ativo';

  Quimico copyWith({
    String? codigo,
    String? descricao,
    String? unidade,
    String? status,
  }) {
    return Quimico(
      codigo: codigo ?? this.codigo,
      descricao: descricao ?? this.descricao,
      unidade: unidade ?? this.unidade,
      status: status ?? this.status,
    );
  }
}
