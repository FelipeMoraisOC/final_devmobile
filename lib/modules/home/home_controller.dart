// home_controller.dart
import 'package:flutter/material.dart';
import 'package:final_devmobile/database/local/lista_compra_dao.dart';
import 'package:final_devmobile/database/local/item_compra_dao.dart';
import 'package:final_devmobile/database/local/produto_dao.dart';
import 'package:final_devmobile/database/local/categoria_dao.dart';

/// Classe de resumo para exibição na HomeScreen
class ListaResumo {
  final int id;
  final String nome;
  final int quantidadeItens;
  final int itensComprados;
  final String categorias;

  ListaResumo({
    required this.id,
    required this.nome,
    required this.quantidadeItens,
    required this.itensComprados,
    required this.categorias,
  });

  /// Progresso de compra (0.0 a 1.0)
  double get progress =>
      quantidadeItens == 0 ? 0 : itensComprados / quantidadeItens;
}

/// Controller para gerenciar dados da HomeScreen
class HomeController extends ChangeNotifier {
  final List<ListaResumo> listaResumos = [];
  bool loading = true;

  /// Carrega listas, itens, produtos e categorias para resumir
  Future<void> loadData(String usuarioId) async {
    loading = true;
    notifyListeners();

    // Carrega mapas de produtos e categorias
    final produtos = await ProdutoDao.getAllProduto(int.parse(usuarioId));
    final categorias = await CategoriaDao.getAllCategoriaByUsuarioId(
      int.parse(usuarioId),
    );
    final prodMap = {for (var p in produtos) p.id!: p};
    final catMap = {for (var c in categorias) c.id!: c};

    // Busca todas as listas de compras do usuário
    final listas = await ListaCompraDao.getAll(usuarioId);
    listaResumos.clear();

    for (var lista in listas) {
      // Itens da lista
      final items = await ItemCompraDao.getByListaId(lista.id!);
      final total = items.length;
      final comprados = items.where((i) => i.comprado).length;

      // Extrai categorias únicas
      final nomesCats = <String>{};
      for (var item in items) {
        final prod = prodMap[item.produtoId];
        if (prod != null) {
          final cat = catMap[prod.categoriaId];
          if (cat != null) nomesCats.add(cat.nome);
        }
      }
      final listaCats = nomesCats.toList();
      final exibidas = listaCats.take(3).join(', ');
      final mais = listaCats.length > 3 ? '...' : '';

      listaResumos.add(
        ListaResumo(
          id: lista.id!,
          nome: lista.nome,
          quantidadeItens: total,
          itensComprados: comprados,
          categorias: '$exibidas$mais',
        ),
      );
    }

    loading = false;
    notifyListeners();
  }
}
