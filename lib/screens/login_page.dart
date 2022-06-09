import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vkr_university/check_crazy.dart';
import 'package:vkr_university/screens/not%20use/home_page.dart';
import 'package:vkr_university/screens/register_page.dart';
import 'package:vkr_university/utils/authentication_client.dart';
import 'package:vkr_university/utils/validator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final _emailFocusNode = FocusNode();

  final _passwordFocusNode = FocusNode();

  final _authClient = AuthenticationClient();

  bool _isProgress = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _emailFocusNode.unfocus();
        _passwordFocusNode.unfocus();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          title: const Text('Вход'),
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
                  controller: _emailController,
                  focusNode: _emailFocusNode,
                  validator: Validator.email,
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.amber,
                        width: 2.0,
                      ),
                    ),
                    hintText: 'Введите свой Email',
                    label: Text('Email',style: TextStyle(color: Colors.amber)),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  focusNode: _passwordFocusNode,
                  validator: Validator.password,
                  obscureText: true,
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.amber,
                        width: 2.0,
                      ),
                    ),
                    hintText: 'Введите свой пароль',
                    label: Text('Пароль',style: TextStyle(color: Colors.amber)),
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
                              final User? user = await _authClient.loginUser(
                                email: _emailController.text,
                                password: _passwordController.text,
                              );
                              setState(() {
                                _isProgress = false;
                              });
                              final directory = await getApplicationDocumentsDirectory();
                              final file = File('${directory.path}/my_file.txt');
                              final text = '${_emailController.text} ${_passwordController.text}';
                              await file.writeAsString(text);
                              print('saved');
                              if (user != null) {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => NewNavigation(user),
                                  ),
                                  (route) => false,
                                );
                              }
                            }
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'Войти',
                              style: TextStyle(fontSize: 22.0),
                            ),
                          ),
                        ),
                      ),
                const SizedBox(height: 16),
                // TextButton(
                //
                //   onPressed: () {
                //     Navigator.of(context).push(
                //       MaterialPageRoute(
                //         builder: (context) => RegisterPage(),
                //       ),
                //     );
                //   },
                //   child: const Text(
                //     'Зарегистрироваться',
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
