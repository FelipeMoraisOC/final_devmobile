// lista_ativa_screen.dart
import 'package:final_devmobile/shared/utils/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'lista_ativa_controller.dart';

class ListaAtivaScreen extends StatefulWidget {
  final int listaId;
  const ListaAtivaScreen({Key? key, required this.listaId}) : super(key: key);

  @override
  State<ListaAtivaScreen> createState() => _ListaAtivaScreenState();
}

class _ListaAtivaScreenState extends State<ListaAtivaScreen> {
  late ListaAtivaController controller;
  bool _loading = true;
  String? _userId;

  @override
  void initState() {
    super.initState();
    SharedPreferencesUtils().getUserInfoFromPrefs().then((prefs) {
      final uid = prefs['id']!;
      controller = ListaAtivaController(
        listaId: widget.listaId,
        usuarioId: uid,
      );
      controller.init().then((_) => setState(() => _loading = false));
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return ChangeNotifierProvider.value(
      value: controller,
      child: Consumer<ListaAtivaController>(
        builder:
            (_, ctrl, __) => Scaffold(
              appBar: AppBar(
                title: Text('${ctrl.listaCompra!.nome} - Ativa'),
                actions: [
                  TextButton(
                    onPressed: () => ctrl.salvarListaAtiva(context),
                    child: const Text(
                      'Salvar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: ctrl.buscaController,
                      decoration: const InputDecoration(
                        labelText: 'Buscar item',
                        suffixIcon: Icon(Icons.search),
                      ),
                      onChanged: ctrl.buscarItem,
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 40,
                      child: ListView(
                        scrollDirection: Axis.horizontal,

                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: ChoiceChip(
                              label: const Text('Todos'),
                              selected: ctrl.selectedCategoriaId == null,
                              onSelected: (_) => ctrl.filtrarCategoria(null),
                            ),
                          ),
                          ...ctrl.categorias.map(
                            (c) => Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              child: ChoiceChip(
                                label: Text(c.nome),
                                selected: ctrl.selectedCategoriaId == c.id,
                                onSelected: (_) => ctrl.filtrarCategoria(c.id),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      flex: 3,
                      child: ListView.builder(
                        itemCount: ctrl.filteredItems.length,
                        itemBuilder: (_, i) {
                          final item = ctrl.filteredItems[i];
                          return Card(
                            child: ListTile(
                              leading: Checkbox(
                                value: item.comprado,
                                onChanged: (_) => ctrl.toggleComprado(item),
                              ),
                              title: Text(ctrl.getNomeProduto(item.produtoId)),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.attach_money,
                                  color: Colors.green,
                                ),
                                onPressed: () => ctrl.editItem(item, context),
                              ),
                              subtitle: Text(
                                '${item.quantidade} ${item.medida} - R\$ ${item.preco ?? '-'}',
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
