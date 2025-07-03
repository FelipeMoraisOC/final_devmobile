import 'package:final_devmobile/database/local/categoria_dao.dart';
import 'package:final_devmobile/models/categoria_model.dart';
import 'package:final_devmobile/modules/categoria/categoria_controller.dart';
import 'package:final_devmobile/shared/utils/shared_preferences.dart';
import 'package:final_devmobile/shared/widgets/custom_snack_bar.dart';
import 'package:flutter/material.dart';

class CategoriaScreen extends StatefulWidget {
  const CategoriaScreen({Key? key}) : super(key: key);

  @override
  State<CategoriaScreen> createState() => _CategoriaScreenState();
}

class _CategoriaScreenState extends State<CategoriaScreen> {
  List<Categoria> _categorias = [];
  final TextEditingController _nomeController = TextEditingController();
  int? usuarioId;
  bool _carregado = false;

  void _excluirCategoria(int index) {
    setState(() {
      _categorias.removeAt(index);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final userInfo = await SharedPreferencesUtils().getUserInfoFromPrefs();
    setState(() {
      usuarioId = int.tryParse(userInfo['id'].toString());
      if (usuarioId == null) {
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        _carregado = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    void _abrirModalAdicionar() {
      _nomeController.clear();
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Adicionar Categoria'),
              content: TextField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome da Categoria',
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final nome = _nomeController.text.trim();
                    if (nome.isNotEmpty) {
                      final categoriaController = CategoriaController();
                      categoriaController
                          .createCategoria(
                            context,
                            Categoria(nome: nome, usuarioId: usuarioId!),
                          )
                          .then((cat) {
                            if (cat != null) {
                              setState(() {
                                _categorias.add(cat);
                              });
                              CustomSnackBar.show(
                                context,
                                'Categoria adicionada com sucesso',
                              );
                            }
                            Navigator.pop(context);
                          });
                    }
                  },
                  child: const Text('Adicionar'),
                ),
              ],
            ),
      );
    }

    void _abrirModalEditar(int index) {
      _nomeController.text = _categorias[index].nome;
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Editar Categoria'),
              content: TextField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome da Categoria',
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final nome = _nomeController.text.trim();
                    if (nome.isNotEmpty) {
                      final categoriaController = CategoriaController();
                      categoriaController.updateCategoria(
                        context,
                        Categoria(
                          id: _categorias[index].id,
                          nome: nome,
                          usuarioId: usuarioId!,
                        ),
                      );
                      setState(() {
                        _categorias[index] = Categoria(
                          id: _categorias[index].id,
                          nome: nome,
                          usuarioId: usuarioId!,
                        );
                      });
                      CustomSnackBar.show(
                        context,
                        'Categoria editada com sucesso',
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Salvar'),
                ),
              ],
            ),
      );
    }

    void _abrirModalConfirmarExclusao(int index) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Confirmar Exclusão'),
              content: const Text(
                'Tem certeza que deseja excluir esta categoria?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final categoriaController = CategoriaController();
                    await categoriaController.deleteCategoria(
                      context,
                      _categorias[index].id!,
                      usuarioId!,
                    );
                    _excluirCategoria(index);
                    CustomSnackBar.show(
                      context,
                      'Categoria excluída com sucesso',
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Excluir'),
                ),
              ],
            ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Categorias')),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirModalAdicionar,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 6, right: 6, top: 12, bottom: 12),
        child: Column(
          children: [
            Expanded(
              flex: 8,
              child:
                  _carregado
                      ? FutureBuilder<List<Categoria>>(
                        future: (CategoriaDao.getAllCategoriaByUsuarioId(
                          usuarioId!,
                        )), // Função que retorna a lista de categorias cadastrados
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text('Erro ao carregar categorias'),
                            );
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return Center(
                              child: Text('Nenhuma categoria cadastrada'),
                            );
                          }
                          _categorias = snapshot.data!;
                          return ListView.builder(
                            itemCount: _categorias.length,
                            itemBuilder: (context, index) {
                              final cat = _categorias[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                child: ListTile(
                                  title: Text(cat.nome),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed:
                                            () => _abrirModalEditar(index),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed:
                                            () => _abrirModalConfirmarExclusao(
                                              index,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      )
                      : const Center(child: CircularProgressIndicator()),
            ),
          ],
        ),
      ),
    );
  }
}
