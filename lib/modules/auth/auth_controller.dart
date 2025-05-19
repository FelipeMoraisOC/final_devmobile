import 'package:final_devmobile/database/local/user_dao.dart';
import 'package:final_devmobile/models/user_model.dart';
import 'package:final_devmobile/shared/widgets/custom_snack_bar.dart';
import 'package:flutter/material.dart';

class AuthController {
  //Verificar se com email já existe
  Future<bool> checkEmailExists(String email) async {
    final user = await UserDao.getUserByEmail(email);
    return user != null;
  }

  //Cadastrar usuário
  Future registerUser(
    context,
    String email,
    String phone,
    String name,
    String password,
  ) async {
    try {
      await UserDao.insertUser(
        UserModel(
          id: null,
          email: email,
          phone: phone,
          name: name,
          password: password,
        ),
      );
    } catch (e) {
      CustomSnackBar.show(
        context,
        e.toString().replaceAll('Exception: ', ''),
        fail: true,
      );

      return;
    }
    CustomSnackBar.show(context, 'Usuário registrado com sucesso');
    Navigator.pushReplacementNamed(context, '/home');
  }
}
