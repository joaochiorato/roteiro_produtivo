class PostoTrabalho {
  final String codPosto;
  final String descPosto;
  final String status;

  PostoTrabalho({
    required this.codPosto,
    required this.descPosto,
    required this.status,
  });

  bool get isAtivo => status == 'Ativo';

  PostoTrabalho copyWith({
    String? codPosto,
    String? descPosto,
    String? status,
  }) {
    return PostoTrabalho(
      codPosto: codPosto ?? this.codPosto,
      descPosto: descPosto ?? this.descPosto,
      status: status ?? this.status,
    );
  }
}
