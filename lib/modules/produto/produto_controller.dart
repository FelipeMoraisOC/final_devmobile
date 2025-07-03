import 'package:final_devmobile/shared/widgets/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:final_devmobile/models/produto_model.dart';
import 'package:final_devmobile/models/categoria_model.dart';
import 'package:final_devmobile/database/local/produto_dao.dart';
import 'package:final_devmobile/database/local/categoria_dao.dart';

class ProdutoController extends ChangeNotifier {
  List<Produto> produtos = [];
  List<Categoria> categorias = [];

  Future<void> carregarDados(int usuarioId) async {
    categorias = await CategoriaDao.getAllCategoriaByUsuarioId(usuarioId);
    produtos = await ProdutoDao.getAllProduto(usuarioId);
    notifyListeners();
  }

  Future<void> adicionarProduto(Produto produto, context) async {
    final novo = await ProdutoDao.insertProduto(produto);
    produtos.add(novo);
    CustomSnackBar.show(context, 'Produto adicionado com sucesso!');
    notifyListeners();
  }

  Future<void> atualizarProduto(Produto produto, context) async {
    await ProdutoDao.deleteProdutoById(produto.id!, produto.usuarioId);
    final novo = await ProdutoDao.insertProduto(produto);
    final index = produtos.indexWhere((p) => p.id == produto.id);
    produtos[index] = novo;
    CustomSnackBar.show(context, 'Produto atualizado com sucesso!');

    notifyListeners();
  }

  Future<void> deletarProduto(int id, int usuarioId, context) async {
    await ProdutoDao.deleteProdutoById(id, usuarioId);
    produtos.removeWhere((p) => p.id == id);
    CustomSnackBar.show(context, 'Produto excluido com sucesso!');

    notifyListeners();
  }
}
