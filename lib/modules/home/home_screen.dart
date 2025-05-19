import 'package:final_devmobile/modules/home/home_controller.dart';
import 'package:final_devmobile/shared/widgets/custom_app_bar.dart';
import 'package:final_devmobile/shared/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController controller = HomeController();
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: CustomDrawer(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          FutureBuilder<Map<String, String?>>(
            future: controller.getUserInfoFromPrefs(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasError ||
                  snapshot.data == null ||
                  snapshot.data!.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Card(
                    child: ListTile(
                      title: Text('Nenhum dado salvo no SharedPreferences'),
                    ),
                  ),
                );
              }
              final data = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 4,
                  child: ListTile(
                    leading: CircleAvatar(child: Text(data['id'] ?? '')),
                    title: Text('Nome: ${data['name'] ?? ''}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Email: ${data['email'] ?? ''}'),
                        Text('Telefone: ${data['phone'] ?? ''}'),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
