// lista_ativa_screen.dart
import 'package:final_devmobile/models/produto_model.dart';
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
  bool _fabOpen = false;

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

  void _toggleFab() {
    setState(() {
      _fabOpen = !_fabOpen;
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
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.cyanAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () => ctrl.salvarListaAtiva(context),
                    child: const Text(
                      'Salvar',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
              bottomSheet: Container(
                width: double.infinity,
                color: Theme.of(context).cardColor,
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 16,
                ),
                child: Consumer<ListaAtivaController>(
                  builder: (_, ctrl, __) {
                    final total = ctrl.totalComprado.toStringAsFixed(2);
                    return Text(
                      'Total comprado: R\$ $total',
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
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
                    const SizedBox(height: 25),
                  ],
                ),
              ),
              floatingActionButton: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // botão de EXCLUIR (só aparece quando _fabOpen == true)
                  if (_fabOpen) ...[
                    FloatingActionButton(
                      heroTag: 'delete_all',
                      backgroundColor: Colors.red,
                      mini: true,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder:
                              (_) => AlertDialog(
                                title: const Text('Confirmação'),
                                content: const Text('Excluir a Lista?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Não'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      ctrl.deletarLista(context);
                                    },
                                    child: const Text('Sim'),
                                  ),
                                ],
                              ),
                        );
                      },
                      child: const Icon(Icons.delete),
                    ),
                    const SizedBox(height: 8),
                    // botão de ADICIONAR PRODUTO
                    FloatingActionButton(
                      heroTag: 'add_prod',
                      onPressed: () async {
                        // prepara variáveis locais
                        Produto? selected;
                        final qtyCtrl = TextEditingController(text: '1');

                        await showDialog<void>(
                          context: context,
                          builder: (ctx) {
                            return StatefulBuilder(
                              builder: (ctx, setSt) {
                                return AlertDialog(
                                  title: const Text('Adicionar Produto'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Dropdown para escolher o produto
                                      DropdownButtonFormField<Produto>(
                                        decoration: const InputDecoration(
                                          labelText: 'Produto',
                                        ),
                                        items:
                                            ctrl.produtos
                                                .map(
                                                  (e) => DropdownMenuItem(
                                                    value: e,
                                                    child: Text(e.nome),
                                                  ),
                                                )
                                                .toList(),
                                        value: selected,
                                        onChanged:
                                            (p) => setSt(() => selected = p),
                                      ),

                                      const SizedBox(height: 12),

                                      // Campo de quantidade
                                      TextField(
                                        controller: qtyCtrl,
                                        keyboardType:
                                            const TextInputType.numberWithOptions(
                                              decimal: true,
                                            ),
                                        decoration: const InputDecoration(
                                          labelText: 'Quantidade',
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      child: const Text('Cancelar'),
                                      onPressed: () => Navigator.pop(ctx),
                                    ),
                                    ElevatedButton(
                                      child: const Text('Adicionar'),
                                      onPressed: () {
                                        if (selected != null &&
                                            double.tryParse(qtyCtrl.text) !=
                                                null) {
                                          final quantidade = double.parse(
                                            qtyCtrl.text,
                                          );
                                          // chama um método que insere o ItemCompra na lista
                                          ctrl.addItemToLista(
                                            produto: selected!,
                                            quantidade: quantidade,
                                          );
                                          Navigator.pop(ctx);
                                        }
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );

                        // depois que fechar o modal, recarrega a view
                        ctrl.init();
                      },
                      child: Icon(Icons.add),
                    ),
                    const SizedBox(height: 20),
                  ],
                  // botão principal que abre/fecha o menu
                  FloatingActionButton(
                    heroTag: 'main_fab',
                    onPressed: _toggleFab,
                    child: Icon(_fabOpen ? Icons.close : Icons.menu),
                  ),
                ],
              ),
            ),
      ),
    );
  }
}
