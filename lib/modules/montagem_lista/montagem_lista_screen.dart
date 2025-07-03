// montagem_lista_screen.dart
import 'package:final_devmobile/core/constants.dart';
import 'package:final_devmobile/core/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:final_devmobile/shared/utils/shared_preferences.dart';
import 'montagem_lista_controller.dart';
import 'package:final_devmobile/models/item_compra_model.dart';

class MontagemListaScreen extends StatefulWidget {
  const MontagemListaScreen({super.key});

  @override
  State<MontagemListaScreen> createState() => _MontagemListaScreenState();
}

class _MontagemListaScreenState extends State<MontagemListaScreen> {
  late MontagemListaController controller;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    controller = MontagemListaController();
    SharedPreferencesUtils().getUserInfoFromPrefs().then((prefs) {
      final userId = prefs['id'];
      if (userId == null) {
        Navigator.pushReplacementNamed(context, '/login');
        return;
      }
      controller.inicializar(userId);
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return ChangeNotifierProvider.value(
      value: controller,
      child: Consumer<MontagemListaController>(
        builder:
            (_, ctrl, __) => Scaffold(
              appBar: AppBar(
                title: const Text('Montar Lista de Compras'),
                actions: [
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.cyanAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    onPressed: () async {
                      Scrollable.ensureVisible(
                        context,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                      await showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder:
                            (context) => AlertDialog(
                              title: const Text('Digite o nome dessa Lista'),
                              content: TextField(
                                controller: ctrl.nomeListaController,
                                decoration: const InputDecoration(
                                  labelText: 'Nome da Lista',
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Cancelar'),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    Scrollable.ensureVisible(
                                      context,
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      curve: Curves.easeInOut,
                                    );
                                    await ctrl.salvarLista(context);
                                  },
                                  child: const Text('Salvar'),
                                ),
                              ],
                            ),
                      );
                    },
                    child: const Text(
                      'Salvar',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    const Text('Itens Selecionados:'),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.2,
                      child: GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: 6,
                        children:
                            ctrl.itensSelecionados.map((item) {
                              return ListTile(
                                dense: true,
                                minLeadingWidth: 0,
                                leading: SizedBox(
                                  width: 120, // ajuste conforme necessário
                                  child: Text(
                                    '${item.quantidade.toInt()} ${ctrl.getNomeProduto(item.produtoId)}',
                                    style: const TextStyle(fontSize: 12),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                    const Divider(),
                    TextField(
                      onChanged: controller.buscarProduto,
                      decoration: const InputDecoration(
                        labelText: 'Buscar Produto',
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.categorias.length + 1,
                        itemBuilder: (_, idx) {
                          final isAll = idx == 0;
                          final cat =
                              isAll ? null : controller.categorias[idx - 1];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: ChoiceChip(
                              label: Text(isAll ? 'Todos' : cat!.nome),
                              selected:
                                  isAll ||
                                  controller.categoriaSelecionada == cat,
                              onSelected:
                                  (_) => controller.filtrarPorCategoria(cat),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        itemCount: controller.produtosFiltrados.length,
                        itemBuilder: (_, idx) {
                          final p = controller.produtosFiltrados[idx];
                          final inList = controller.estaNaLista(p);
                          final quantidade =
                              controller.itensSelecionados
                                  .firstWhere(
                                    (i) => i.produtoId == p.id,
                                    orElse:
                                        () => ItemCompra(
                                          produtoId: p.id!,
                                          medida: 'Unidade',
                                          quantidade: 0,
                                          comprado: false,
                                          usuarioId: controller.usuarioId,
                                        ),
                                  )
                                  .quantidade;
                          return Card(
                            color:
                                inList
                                    ? AppThemeConstants.primary.withAlpha(200)
                                    : null,
                            child: ListTile(
                              title: Text(p.nome),
                              subtitle: Text(
                                controller.categorias
                                    .firstWhere((c) => c.id == p.categoriaId)
                                    .nome,
                              ),
                              leading: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed:
                                        () =>
                                            controller.decrementarQuantidade(p),
                                  ),
                                  Text('$quantidade'),
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed:
                                        () =>
                                            controller.incrementarQuantidade(p),
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  inList
                                      ? Icons.check_circle
                                      : Icons.add_circle,
                                ),
                                onPressed:
                                    () => controller.adicionarOuRemover(p),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
      ),
    );
  }
}
