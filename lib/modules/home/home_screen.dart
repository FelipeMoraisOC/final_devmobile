// home_screen.dart
import 'package:final_devmobile/modules/lista_ativa/lista_ativa_screen.dart';
import 'package:final_devmobile/shared/widgets/custom_app_bar.dart';
import 'package:final_devmobile/shared/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:final_devmobile/shared/utils/shared_preferences.dart';
import 'home_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeController controller;
  bool _loadingUser = true;
  String? _userId;

  @override
  void initState() {
    super.initState();
    controller = HomeController();
    SharedPreferencesUtils().getUserInfoFromPrefs().then((prefs) {
      final uid = prefs['id'];
      if (uid == null) {
        Navigator.pushReplacementNamed(context, '/login');
        return;
      }
      _userId = uid;
      controller.loadData(uid);
      setState(() {
        _loadingUser = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingUser) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return ChangeNotifierProvider.value(
      value: controller,
      child: Consumer<HomeController>(
        builder:
            (_, ctrl, __) => Scaffold(
              appBar: CustomAppBar(),
              drawer: CustomDrawer(),
              floatingActionButton: FloatingActionButton(
                onPressed: () => Navigator.pushNamed(context, 'montagem_lista'),
                child: const Icon(Icons.add),
              ),
              body: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Listas de Compras',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (ctrl.loading)
                      const Expanded(
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (ctrl.listaResumos.isEmpty)
                      const Expanded(
                        child: Center(child: Text('Nenhuma lista criada')),
                      )
                    else
                      Expanded(
                        child: ListView.builder(
                          itemCount: ctrl.listaResumos.length,
                          itemBuilder: (_, idx) {
                            final resumo = ctrl.listaResumos[idx];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: InkWell(
                                onTap:
                                    () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) => ListaAtivaScreen(
                                              listaId: resumo.id,
                                            ),
                                      ),
                                    ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 16,
                                  ),
                                  title: Text(
                                    resumo.nome,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${resumo.quantidadeItens} produtos',
                                      ),
                                      Text(resumo.categorias),
                                    ],
                                  ),
                                  trailing: Container(
                                    width: 60,
                                    height: 75,
                                    padding: const EdgeInsets.all(4),
                                    decoration:
                                        resumo.progress == 1
                                            ? BoxDecoration(
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary
                                                      .withOpacity(0.7),
                                                  blurRadius: 10,
                                                  spreadRadius: 2,
                                                ),
                                              ],
                                            )
                                            : null,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 45,
                                          height: 45,
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              CircularProgressIndicator(
                                                value: resumo.progress,
                                                backgroundColor: Theme.of(
                                                      context,
                                                    ).colorScheme.primary
                                                    .withOpacity(0.2),
                                                strokeWidth: 5,
                                                color:
                                                    resumo.progress == 1
                                                        ? Theme.of(
                                                          context,
                                                        ).colorScheme.primary
                                                        : Theme.of(
                                                          context,
                                                        ).colorScheme.secondary,
                                              ),
                                              Text(
                                                '${(resumo.progress * 100).toInt()}%',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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
