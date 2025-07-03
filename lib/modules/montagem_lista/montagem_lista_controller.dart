// montagem_lista_controller.dart
import 'package:final_devmobile/database/local/item_compra_dao.dart';
import 'package:final_devmobile/database/local/lista_compra_dao.dart';
import 'package:final_devmobile/models/lista_compra_model.dart';
import 'package:final_devmobile/shared/widgets/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:final_devmobile/models/produto_model.dart';
import 'package:final_devmobile/models/item_compra_model.dart';
import 'package:final_devmobile/models/categoria_model.dart';
import 'package:final_devmobile/database/local/produto_dao.dart';
import 'package:final_devmobile/database/local/categoria_dao.dart';

class MontagemListaController extends ChangeNotifier {
  final TextEditingController nomeListaController = TextEditingController();
  List<Produto> todosProdutos = [];
  List<Produto> produtosFiltrados = [];
  List<ItemCompra> itensSelecionados = [];
  List<Categoria> categorias = [];
  Categoria? categoriaSelecionada;
  String termoBusca = '';
  late String usuarioId;

  Future<void> inicializar(String userId) async {
    usuarioId = userId;
    categorias = await CategoriaDao.getAllCategoriaByUsuarioId(
      int.parse(usuarioId),
    );
    todosProdutos = await ProdutoDao.getAllProduto(int.parse(usuarioId));
    produtosFiltrados = List.from(todosProdutos);
    notifyListeners();
  }

  void buscarProduto(String valor) {
    termoBusca = valor;
    aplicarFiltros();
  }

  void filtrarPorCategoria(Categoria? cat) {
    categoriaSelecionada = cat;
    aplicarFiltros();
  }

  void aplicarFiltros() {
    produtosFiltrados =
        todosProdutos.where((p) {
          final matchesCategoria =
              categoriaSelecionada == null ||
              p.categoriaId == categoriaSelecionada!.id;
          final matchesBusca = p.nome.toLowerCase().contains(
            termoBusca.toLowerCase(),
          );
          return matchesCategoria && matchesBusca;
        }).toList();
    notifyListeners();
  }

  void incrementarQuantidade(Produto p) {
    final index = itensSelecionados.indexWhere((i) => i.produtoId == p.id);
    if (index >= 0) {
      itensSelecionados[index] = itensSelecionados[index].copyWith(
        quantidade: itensSelecionados[index].quantidade + 1,
      );
    } else {
      itensSelecionados.add(
        ItemCompra(
          produtoId: p.id!,
          medida: 'Unidade',
          quantidade: 1,
          comprado: false,
          usuarioId: usuarioId,
        ),
      );
    }
    notifyListeners();
  }

  void decrementarQuantidade(Produto p) {
    final index = itensSelecionados.indexWhere((i) => i.produtoId == p.id);
    if (index >= 0) {
      final current = itensSelecionados[index];
      if (current.quantidade > 1) {
        itensSelecionados[index] = current.copyWith(
          quantidade: current.quantidade - 1,
        );
      } else {
        itensSelecionados.removeAt(index);
      }
      notifyListeners();
    }
  }

  bool estaNaLista(Produto p) =>
      itensSelecionados.any((i) => i.produtoId == p.id);

  void adicionarOuRemover(Produto p) {
    if (estaNaLista(p)) {
      itensSelecionados.removeWhere((i) => i.produtoId == p.id);
    } else {
      itensSelecionados.add(
        ItemCompra(
          produtoId: p.id!,
          medida: 'Unidade',
          quantidade: 1,
          comprado: false,
          usuarioId: usuarioId,
        ),
      );
    }
    notifyListeners();
  }

  Future<void> salvarLista(BuildContext context) async {
    final nome = nomeListaController.text.trim();
    if (nome.isEmpty || itensSelecionados.isEmpty) {
      CustomSnackBar.show(
        context,
        'Por favor, preencha o nome da lista e adicione itens.',
        fail: true,
      );
      return;
    }

    final novaLista = ListaCompra(
      nome: nome,
      dataCriacao: DateTime.now(),
      usuarioId: usuarioId,
    );
    final listaId = await ListaCompraDao.insert(novaLista);
    for (var item in itensSelecionados) {
      final itemId = await ItemCompraDao.insert(item);
      await ListaCompraDao.associarItem(listaId, itemId);
    }

    CustomSnackBar.show(context, 'Lista de compras criada com sucesso!');
    Navigator.pop(context);
  }

  void removerItem(ItemCompra item) {
    itensSelecionados.removeWhere((i) => i.produtoId == item.produtoId);
    notifyListeners();
  }

  String getNomeProduto(int produtoId) {
    try {
      return todosProdutos.firstWhere((p) => p.id == produtoId).nome;
    } catch (_) {
      return 'Produto não encontrado';
    }
  }
}
