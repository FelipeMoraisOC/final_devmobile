import 'package:final_devmobile/models/produto_model.dart';
import 'package:final_devmobile/models/categoria_model.dart';
import 'package:final_devmobile/shared/utils/shared_preferences.dart';
import 'package:final_devmobile/modules/produto/produto_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProdutoScreen extends StatefulWidget {
  const ProdutoScreen({super.key});

  @override
  State<ProdutoScreen> createState() => _ProdutoScreenState();
}

class _ProdutoScreenState extends State<ProdutoScreen> {
  late ProdutoController controller;
  int? usuarioId;

  @override
  void initState() {
    super.initState();
    controller = ProdutoController();
    SharedPreferencesUtils().getUserInfoFromPrefs().then((user) {
      usuarioId = int.parse(user['id'].toString());
      controller.carregarDados(usuarioId!);
      setState(() {}); // força rebuild
    });
  }

  void abrirModal({Produto? produto}) {
    final TextEditingController nomeController = TextEditingController(
      text: produto?.nome ?? '',
    );
    Categoria? categoriaSelecionada =
        produto != null
            ? controller.categorias.firstWhere(
              (c) => c.id == produto.categoriaId,
              orElse: () => controller.categorias.first,
            )
            : null;

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(produto == null ? 'Novo Produto' : 'Editar Produto'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nomeController,
                  decoration: const InputDecoration(labelText: 'Nome'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<Categoria>(
                  value: categoriaSelecionada,
                  items:
                      controller.categorias
                          .map(
                            (cat) => DropdownMenuItem(
                              value: cat,
                              child: Text(cat.nome),
                            ),
                          )
                          .toList(),
                  onChanged: (cat) => categoriaSelecionada = cat,
                  decoration: const InputDecoration(labelText: 'Categoria'),
                ),
              ],
            ),
            actions: [
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                child: const Text('Salvar'),
                onPressed: () {
                  if (nomeController.text.isNotEmpty &&
                      categoriaSelecionada != null) {
                    final novoProduto = Produto(
                      id: produto?.id,
                      nome: nomeController.text,
                      categoriaId: categoriaSelecionada!.id!,
                      usuarioId: usuarioId!,
                    );
                    produto == null
                        ? controller.adicionarProduto(novoProduto, context)
                        : controller.atualizarProduto(novoProduto, context);
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
    );
  }

  void abrirModalExcluir(Produto produto) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Excluir Produto'),
            content: Text('Tem certeza que deseja excluir "${produto.nome}"?'),
            actions: [
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                child: const Text('Excluir'),
                onPressed: () {
                  controller.deletarProduto(produto.id!, usuarioId!, context);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: controller,
      child: Consumer<ProdutoController>(
        builder:
            (_, ctrl, __) => Scaffold(
              appBar: AppBar(title: const Text('Produtos')),
              floatingActionButton: FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () => abrirModal(),
              ),
              body:
                  ctrl.produtos.isEmpty
                      ? const Center(child: Text('Nenhum produto cadastrado.'))
                      : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 4,
                        ),
                        itemCount: ctrl.produtos.length,
                        itemBuilder: (_, index) {
                          final produto = ctrl.produtos[index];
                          final categoria = ctrl.categorias.firstWhere(
                            (c) => c.id == produto.categoriaId,
                            orElse:
                                () => Categoria(
                                  nome: 'Categoria não encontrada',
                                  usuarioId: usuarioId!,
                                ),
                          );
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              title: Text(produto.nome),
                              subtitle: Text(categoria.nome),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed:
                                        () => abrirModal(produto: produto),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () => abrirModalExcluir(produto),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
            ),
      ),
    );
  }
}
