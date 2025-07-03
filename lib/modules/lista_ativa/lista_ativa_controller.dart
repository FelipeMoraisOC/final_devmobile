// lista_ativa_controller.dart
import 'package:final_devmobile/database/local/lista_compra_dao.dart';
import 'package:final_devmobile/models/lista_compra_model.dart';
import 'package:final_devmobile/models/produto_model.dart';
import 'package:final_devmobile/modules/home/home_screen.dart';
import 'package:final_devmobile/shared/widgets/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:final_devmobile/models/item_compra_model.dart';
import 'package:final_devmobile/models/categoria_model.dart';
import 'package:final_devmobile/database/local/item_compra_dao.dart';
import 'package:final_devmobile/database/local/produto_dao.dart';
import 'package:final_devmobile/database/local/categoria_dao.dart';
import 'package:flutter/services.dart';

class ListaAtivaController extends ChangeNotifier {
  final int listaId;
  final String usuarioId;
  List<ItemCompra> allItems = [];
  List<ItemCompra> filteredItems = [];
  List<Categoria> categorias = [];
  List<Produto> produtos = [];
  ListaCompra? listaCompra;

  int? selectedCategoriaId;
  String termoBusca = '';
  final TextEditingController buscaController = TextEditingController();

  ListaAtivaController({required this.listaId, required this.usuarioId});

  Future<void> init() async {
    listaCompra = await ListaCompraDao.getListaCompraById(listaId, usuarioId);
    // carrega todos os itens da lista
    allItems = await ItemCompraDao.getByListaId(listaId);
    // carrega produtos para lookup e extrai categorias para chips
    produtos = await ProdutoDao.getAllProduto(int.parse(usuarioId));
    final prodMap = {for (var p in produtos) p.id!: p};
    final catIds = <int?>{};
    for (var item in allItems) {
      final prod = prodMap[item.produtoId];
      if (prod != null) catIds.add(prod.categoriaId);
    }
    final listaCats = await CategoriaDao.getAllCategoriaByUsuarioId(
      int.parse(usuarioId),
    );
    categorias = listaCats.where((c) => catIds.contains(c.id)).toList();

    applyFilters();
  }

  void applyFilters() {
    filteredItems =
        allItems.where((item) {
          final prodName = getNomeProduto(item.produtoId).toLowerCase();
          final matchesBusca = prodName.contains(termoBusca.toLowerCase());
          final matchesCat =
              selectedCategoriaId == null ||
              (getCategoriaId(item.produtoId) == selectedCategoriaId);
          return matchesBusca && matchesCat;
        }).toList();
    notifyListeners();
  }

  void buscarItem(String termo) {
    termoBusca = termo;
    applyFilters();
  }

  void filtrarCategoria(int? categoriaId) {
    selectedCategoriaId = categoriaId;
    applyFilters();
  }

  /// Abre o modal para editar nome, quantidade e preço do item
  Future<void> editItem(ItemCompra item, BuildContext context) async {
    final qtdCtrl = TextEditingController(text: item.quantidade.toString());
    final precoCtrl = TextEditingController(text: item.preco?.toString() ?? '');

    await showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Editar item', style: const TextStyle(fontSize: 14)),
                Text(
                  getNomeProduto(item.produtoId),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        double current = double.tryParse(qtdCtrl.text) ?? 1.0;
                        if (current > 1.0) {
                          qtdCtrl.text = (current - 1.0).toString();
                        }
                      },
                    ),
                    Expanded(
                      child: TextField(
                        controller: qtdCtrl,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'\d+(\.\d+)?'),
                          ),
                        ],
                        decoration: const InputDecoration(
                          labelText: 'Quantidade',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        double current = double.tryParse(qtdCtrl.text) ?? 1.0;
                        qtdCtrl.text = (current + 1.0).toString();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: precoCtrl,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Preço'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final updated = item.copyWith(
                    quantidade:
                        double.tryParse(qtdCtrl.text) ?? item.quantidade,
                    preco: double.tryParse(precoCtrl.text),
                  );
                  await ItemCompraDao.update(updated);
                  // atualiza na lista local
                  allItems =
                      allItems
                          .map((i) => i.id == updated.id ? updated : i)
                          .toList();
                  applyFilters();
                  Navigator.pop(context);
                },
                child: const Text('Salvar'),
              ),
            ],
          ),
    );
  }

  /// Apenas alterna o flag `comprado` e salva no banco
  Future<void> toggleComprado(ItemCompra item) async {
    final updated = item.copyWith(comprado: !item.comprado);
    await ItemCompraDao.update(updated);
    // atualiza na lista local
    allItems = allItems.map((i) => i.id == updated.id ? updated : i).toList();
    applyFilters();
  }

  Future<void> salvarListaAtiva(BuildContext context) async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => HomeScreen()),
    );
  }

  // helpers:
  String getNomeProduto(int produtoId) {
    try {
      return produtos.firstWhere((p) => p.id == produtoId).nome;
    } catch (_) {
      return 'Produto não encontrado';
    }
  }

  int getCategoriaId(int produtoId) {
    final categoriaId =
        produtos.firstWhere((p) => p.id == produtoId).categoriaId;
    return categoriaId ?? 0;
  }

  Future<void> deletarLista(BuildContext context) async {
    await ListaCompraDao.delete(listaId, usuarioId);
    CustomSnackBar.show(context, 'Lista de compras deletada com sucesso!');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => HomeScreen()),
    );
  }

  Produto? getProdutoById(int produtoId) {
    try {
      return produtos.firstWhere((p) => p.id == produtoId);
    } catch (_) {
      return null;
    }
  }

  Future<void> addItemToLista({
    required Produto produto,
    required double quantidade,
  }) async {
    // 1) Cria o modelo de ItemCompra (id fica nulo pois é autoincrement)
    final novoItem = ItemCompra(
      produtoId: produto.id!,
      medida: '', // ou outro default
      quantidade: quantidade,
      preco: null,
      comprado: false,
      usuarioId: usuarioId,
    );

    // 2) Insere no banco
    final itemId = await ItemCompraDao.insert(novoItem);
    await ListaCompraDao.associarItem(listaId, itemId);
    novoItem.copyWith(id: itemId);
    allItems.add(novoItem);
    applyFilters();
  }

  double get totalComprado {
    return allItems
        .where((item) => item.comprado) // filtra só os comprados
        .fold(0.0, (soma, item) {
          final precoUnit = item.preco ?? 0.0;
          return soma + precoUnit * item.quantidade;
        });
  }
}
