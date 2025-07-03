import 'package:final_devmobile/modules/admin/admin_screen.dart';
import 'package:final_devmobile/modules/categoria/categoria_screen.dart';
import 'package:final_devmobile/modules/configuration/configuration_screen.dart';
import 'package:final_devmobile/modules/montagem_lista/montagem_lista_screen.dart';
import 'package:final_devmobile/modules/produto/produto_screen.dart';
import 'package:final_devmobile/shared/utils/shared_preferences.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: FutureBuilder<Map<String, String?>>(
              future: SharedPreferencesUtils().getUserInfoFromPrefs(),
              builder: (context, snapshot) {
                final userData = snapshot.data ?? {};
                final email = userData['email'] ?? '';
                final nome = userData['name'] ?? '';
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'FMC List',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Olá, $nome',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      email,
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ],
                );
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.admin_panel_settings),
            title: const Text('Admin'),
            onTap: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const AdminScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.list_alt),
            title: const Text('Montagem de Lista'),
            onTap: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => MontagemListaScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: const Text('Produtos'),
            onTap: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => ProdutoScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_box),
            title: const Text('Categorias'),
            onTap: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => CategoriaScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configurações'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ConfigurationScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sair'),
            onTap: () async {
              await SharedPreferencesUtils.clearLoginData();
              Navigator.of(context).pushReplacementNamed('/onboarding');
            },
          ),
        ],
      ),
    );
  }
}
