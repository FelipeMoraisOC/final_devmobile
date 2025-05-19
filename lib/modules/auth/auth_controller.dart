import 'package:final_devmobile/database/local/user_dao.dart';
import 'package:final_devmobile/models/user_model.dart';
import 'package:final_devmobile/shared/utils/encrypt.dart';
import 'package:final_devmobile/shared/widgets/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  //função para salvar usuário em shared preferences
  Future<void> saveUserInSharedPreferences(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', user.id!);
    await prefs.setString('user_email', user.email!);
    await prefs.setString('user_phone', user.phone!);
    await prefs.setString('user_name', user.name!);
    await prefs.setString('user_password', user.password!);
  }

  //Verificar se com email já existe
  Future<bool> checkEmailExists(String email) async {
    final user = await UserDao.getUserByEmail(email);
    return user != null;
  }

  //Login usuário
  Future<void> loginUser(context, String email, String password) async {
    final user = await UserDao.getUserByEmail(email);
    if (user == null || user.password != Encrypt.encryptPassword(password)) {
      CustomSnackBar.show(context, 'Email ou senha inválidos', fail: true);
      return;
    }
    CustomSnackBar.show(context, 'Login realizado com sucesso');
    await saveUserInSharedPreferences(user);
    Navigator.pushReplacementNamed(context, '/home', arguments: user);
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
      final user = await UserDao.insertUser(
        UserModel(
          id: null,
          email: email,
          phone: phone,
          name: name,
          password: password,
        ),
      );
      CustomSnackBar.show(context, 'Usuário cadastrado com sucesso');
      await saveUserInSharedPreferences(user);
      Navigator.pushReplacementNamed(context, '/home', arguments: user);
    } catch (e) {
      CustomSnackBar.show(
        context,
        e.toString().replaceAll('Exception: ', ''),
        fail: true,
      );
    }
  }
}
