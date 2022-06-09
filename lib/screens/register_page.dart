import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vkr_university/constants/color_constants.dart';
import 'package:vkr_university/screens/not%20use/settings_page.dart';
import 'package:vkr_university/utils/authentication_client.dart';
import 'package:vkr_university/utils/validator.dart';

import '../check_crazy.dart';
import 'not use/home_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();

  final _numStudentController = TextEditingController();

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final _nameFocusNode = FocusNode();

  final _numStudentFocusNode = FocusNode();

  final _emailFocusNode = FocusNode();

  final _passwordFocusNode = FocusNode();

  final _authClient = AuthenticationClient();

  bool _isProgress = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // _numStudentFocusNode.unfocus();
        _nameFocusNode.unfocus();
        _emailFocusNode.unfocus();
        _passwordFocusNode.unfocus();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          title: const Text('Регистрация'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _nameController,
                  focusNode: _nameFocusNode,
                  validator: Validator.name,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Введите свое имя',
                    label: Text('Имя'),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  focusNode: _emailFocusNode,
                  validator: Validator.email,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Введите свой Email',
                    label: Text('Email'),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  focusNode: _passwordFocusNode,
                  validator: Validator.password,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Введите свой пароль',
                    label: Text('Пароль'),
                  ),
                ),
                const SizedBox(height: 24),
                _isProgress
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        width: double.maxFinite,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).accentColor
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _isProgress = true;
                              });
                              final User? user = await _authClient.registerUser(
                                // numStudent: _numStudentController.text,
                                name: _nameController.text,
                                email: _emailController.text,
                                password: _passwordController.text,
                              );
                              setState(() {
                                _isProgress = false;
                              });
                              if (user != null) {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => AddUser(user),
                                  ),
                                  (route) => false,
                                );
                              }
                            }
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'Регистрация',
                              style: TextStyle(fontSize: 22.0),
                            ),
                          ),
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
