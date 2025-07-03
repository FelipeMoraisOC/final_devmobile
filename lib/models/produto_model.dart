class Produto {
  final int? id;
  final String nome;
  final int? categoriaId;
  final int usuarioId;

  Produto({
    this.id,
    required this.nome,
    this.categoriaId,
    required this.usuarioId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'categoria_id': categoriaId,
      'usuario_id': usuarioId,
    };
  }

  factory Produto.fromMap(Map<String, dynamic> map) {
    return Produto(
      id: map['id'],
      nome: map['nome'],
      categoriaId: map['categoria_id'],
      usuarioId: map['usuario_id'],
    );
  }

  Produto copyWith({int? id, String? nome, int? categoriaId, int? usuarioId}) {
    return Produto(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      categoriaId: categoriaId ?? this.categoriaId,
      usuarioId: usuarioId ?? this.usuarioId,
    );
  }
}
