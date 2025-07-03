class ItemCompra {
  final int? id;
  final int produtoId;
  final String medida;
  final double quantidade;
  final double? preco;
  final bool comprado;
  final String usuarioId; // Adicionado
  ItemCompra({
    this.id,
    required this.produtoId,
    required this.medida,
    required this.quantidade,
    this.preco,
    this.comprado = false,
    required this.usuarioId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'produto_id': produtoId,
      'medida': medida,
      'quantidade': quantidade,
      'preco': preco,
      'comprado': comprado ? 1 : 0,
      'usuario_id': usuarioId,
    };
  }

  factory ItemCompra.fromMap(Map<String, dynamic> map) {
    return ItemCompra(
      id: map['id'],
      produtoId: map['produto_id'],
      medida: map['medida'],
      quantidade: map['quantidade'],
      preco: map['preco'],
      comprado: map['comprado'] == 1,
      usuarioId: map['usuario_id'].toString(), // Adicionado
    );
  }
  ItemCompra copyWith({
    int? id,
    int? produtoId,
    String? medida,
    double? quantidade,
    double? preco,
    bool? comprado,
    String? usuarioId,
  }) {
    return ItemCompra(
      id: id ?? this.id,
      produtoId: produtoId ?? this.produtoId,
      medida: medida ?? this.medida,
      quantidade: quantidade ?? this.quantidade,
      preco: preco ?? this.preco,
      comprado: comprado ?? this.comprado,
      usuarioId: usuarioId ?? this.usuarioId,
    );
  }
}
