class ListaCompra {
  final int? id;
  final String nome;
  final DateTime dataCriacao;
  final String usuarioId;

  ListaCompra({
    this.id,
    required this.nome,
    required this.dataCriacao,
    required this.usuarioId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'data_criacao': dataCriacao.toIso8601String(),
      'usuario_id': usuarioId,
    };
  }

  factory ListaCompra.fromMap(Map<String, dynamic> map) {
    return ListaCompra(
      id: map['id'],
      nome: map['nome'],
      dataCriacao: DateTime.parse(map['data_criacao']),
      usuarioId: map['usuario_id'].toString(),
    );
  }

  ListaCompra copyWith({
    int? id,
    String? nome,
    DateTime? dataCriacao,
    String? usuarioId,
  }) {
    return ListaCompra(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      usuarioId: usuarioId ?? this.usuarioId,
    );
  }
}
