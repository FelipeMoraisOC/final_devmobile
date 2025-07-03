class Categoria {
  final int? id;
  final String nome;
  final int usuarioId;

  Categoria({this.id, required this.nome, required this.usuarioId});

  Map<String, dynamic> toMap() {
    return {'id': id, 'nome': nome, 'usuario_id': usuarioId};
  }

  factory Categoria.fromMap(Map<String, dynamic> map) {
    return Categoria(
      id: map['id'],
      nome: map['nome'],
      usuarioId: map['usuario_id'],
    );
  }

  Categoria copyWith({int? id, String? nome, int? usuarioId}) {
    return Categoria(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      usuarioId: usuarioId ?? this.usuarioId,
    );
  }
}
