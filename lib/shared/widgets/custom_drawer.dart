import 'package:final_devmobile/modules/admin/admin_screen.dart';
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
            child: Text(
              'Katalon Test',
              style: TextStyle(color: Colors.white, fontSize: 24),
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
        ],
      ),
    );
  }
}
