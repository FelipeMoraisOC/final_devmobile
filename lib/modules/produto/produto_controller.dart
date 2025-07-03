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

  Future<void> adicionarProduto(Produto produto) async {
    final novo = await ProdutoDao.insertProduto(produto);
    produtos.add(novo);
    notifyListeners();
  }

  Future<void> atualizarProduto(Produto produto) async {
    await ProdutoDao.deleteProdutoById(produto.id!, produto.usuarioId);
    final novo = await ProdutoDao.insertProduto(produto);
    final index = produtos.indexWhere((p) => p.id == produto.id);
    produtos[index] = novo;
    notifyListeners();
  }

  Future<void> deletarProduto(int id, int usuarioId) async {
    await ProdutoDao.deleteProdutoById(id, usuarioId);
    produtos.removeWhere((p) => p.id == id);
    notifyListeners();
  }
}
