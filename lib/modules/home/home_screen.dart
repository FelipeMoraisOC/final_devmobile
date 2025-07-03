// home_screen.dart
import 'package:final_devmobile/core/routes.dart';
import 'package:final_devmobile/modules/lista_ativa/lista_ativa_screen.dart';
import 'package:final_devmobile/shared/widgets/animated_circle_progress.dart';
import 'package:final_devmobile/shared/widgets/custom_app_bar.dart';
import 'package:final_devmobile/shared/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:final_devmobile/shared/utils/shared_preferences.dart';
import 'package:flutter/widgets.dart' show RouteAware;

import 'home_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with RouteAware {
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route != null) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    super.didPopNext(); // bom chamar o super
    if (_userId != null) {
      controller.loadData(_userId!);
    }
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
                                  trailing: AnimatedProgressCircle(
                                    progress: resumo.progress,
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
