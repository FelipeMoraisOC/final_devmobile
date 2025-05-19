import 'package:final_devmobile/database/local/user_dao.dart';
import 'package:final_devmobile/models/user_model.dart';
import 'package:final_devmobile/modules/home/home_controller.dart';
import 'package:final_devmobile/shared/widgets/custom_app_bar.dart';
import 'package:final_devmobile/shared/widgets/custom_snack_bar.dart';
import 'package:flutter/material.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController controller = HomeController();

    final deleteIdController = TextEditingController();
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
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
          Expanded(
            flex: 8,
            child: FutureBuilder<List<UserModel>>(
              future:
                  (UserDao.getAllUsers()), // Função que retorna a lista de usuários cadastrados
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro ao carregar usuários'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Nenhum usuário cadastrado'));
                }
                final users = snapshot.data!;
                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(user.id?.toString() ?? ''),
                        ),
                        title: Text(user.name ?? ''),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Email: ${user.email ?? ''}'),
                            Text('Telefone: ${user.phone ?? ''}'),
                            Text('Senha: ${user.password ?? ''}'),
                          ],
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Expanded(
            flex: 4,

            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextField(
                            controller: deleteIdController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'ID do usuário',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 12,
                          ),
                        ),
                        onPressed: () async {
                          final idText = deleteIdController.text.trim();
                          if (idText.isEmpty) {
                            CustomSnackBar.show(context, 'Informe um ID');
                            return;
                          }
                          final id = int.tryParse(idText);
                          if (id == null) {
                            CustomSnackBar.show(context, 'ID inválido');
                            return;
                          }
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  title: const Text('Confirmação'),
                                  content: Text(
                                    'Deseja excluir o usuário de ID $id?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () =>
                                              Navigator.of(context).pop(false),
                                      child: const Text('Cancelar'),
                                    ),
                                    TextButton(
                                      onPressed:
                                          () => Navigator.of(context).pop(true),
                                      child: const Text(
                                        'Excluir',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                          );
                          if (confirm == true) {
                            final deleted = await UserDao.deleteUserById(id);
                            if (deleted > 0) {
                              (context as Element).markNeedsBuild();
                              CustomSnackBar.show(
                                context,
                                'Usuário excluído com sucesso',
                              );
                            } else {
                              CustomSnackBar.show(
                                context,
                                'Usuário não encontrado',
                              );
                            }
                          }
                        },
                        child: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.all(16),
                      ),
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/register');
                      },
                      child: const Text('Register -> /register'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.all(16),
                        ),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  title: const Text('Confirmação'),
                                  content: const Text(
                                    'Tem certeza que deseja excluir todos os usuários?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () =>
                                              Navigator.of(context).pop(false),
                                      child: const Text('Cancelar'),
                                    ),
                                    TextButton(
                                      onPressed:
                                          () => Navigator.of(context).pop(true),
                                      child: const Text(
                                        'Excluir',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                          );
                          if (confirm == true) {
                            await UserDao.deleteAllUsers();
                            (context as Element).markNeedsBuild();
                            CustomSnackBar.show(
                              context,
                              'Todos usuários excluídos com sucesso',
                            );
                          }
                        },
                        child: const Text('Excluir Todos Usuários'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
