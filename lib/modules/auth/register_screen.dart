import 'package:final_devmobile/models/user_model.dart';
import 'package:final_devmobile/modules/auth/auth_controller.dart';
import 'package:final_devmobile/shared/utils/textformfield_validators.dart';
import 'package:final_devmobile/shared/widgets/custom_snack_bar.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirme a senha';
    } else if (value != _passwordController.text) {
      return 'As senhas não coincidem';
    }
    return null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() {
    if (_formKey.currentState?.validate() ?? false) {
      AuthController authController = AuthController();
      authController.registerUser(
        context,
        _emailController.text,
        _phoneController.text,
        _nameController.text,
        _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    TextFormFieldValidators validators = TextFormFieldValidators();

    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Usuário')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Informe o nome'
                            : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: validators.validateEmail,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Telefone (12) 34567-8912',
                ),
                inputFormatters: [validators.phoneFormatter],
                keyboardType: TextInputType.phone,
                validator: validators.validatePhone,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Senha'),
                obscureText: true,
                validator: validators.validatePassword,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Confirme a Senha',
                ),
                obscureText: true,
                validator: _validateConfirmPassword,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _register,
                child: const Text('Registrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
