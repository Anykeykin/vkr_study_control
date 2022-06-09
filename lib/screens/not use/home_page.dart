import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vkr_university/check_crazy.dart';
import 'package:vkr_university/constants/constants.dart';
import 'package:vkr_university/screens/login_page.dart';
import 'package:vkr_university/utils/authentication_client.dart';

import '../get_username.dart';
import 'personal_info.dart';
import 'settings_page.dart';
import 'user_info.dart';

class HomePage extends StatefulWidget {
  final User user;
  HomePage(this.user);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _authClient = AuthenticationClient();
  bool _isProgress = false;

  String uni = 'NGPU';
  int num = 22;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      drawer: Drawer(

      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Authenticated User\n\n UID: ${widget.user.uid}\nName: ${widget.user.displayName}\nEmail: ${widget.user.email}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 24.0),
            _isProgress
                ? const CircularProgressIndicator()
                : SizedBox(
                    width: double.maxFinite,
                    child: ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          _isProgress = true;
                        });
                        await _authClient.logoutUser();
                        setState(() {
                          _isProgress = false;
                        });
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                          (route) => false,
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Sign Out',
                          style: TextStyle(fontSize: 22.0),
                        ),
                      ),
                    ),
                  ),
            ElevatedButton(
                onPressed: (){
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) =>
                          GetUserName(widget.user.uid,widget.user)
                          // AddUser(widget.user.displayName, uni ,num,widget.user.uid),
                    ),
                        (route) => false,
                  );
                },
                child: Text('Контактная информация')
            ),
            // ElevatedButton(
            //     onPressed: (){
            //       Navigator.of(context).pushAndRemoveUntil(
            //         MaterialPageRoute(
            //             builder: (context) =>
            //           AddUser(widget.user.displayName, uni ,num,widget.user.uid,widget.user.email,widget.user),
            //         ),
            //             (route) => false,
            //       );
            //     },
            //     child: Text('Добавить пользователя')
            // ),
            ElevatedButton(
                onPressed: (){
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) =>
                          UserInformation(widget.user),
                    ),
                        (route) => false,
                  );
                },
                child: Text('Список пользователей')
            ),
            ElevatedButton(
                onPressed: (){
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) =>
                          PersonalUserInformation(widget.user),
                    ),
                        (route) => false,
                  );
                },
                child: Text('В разработке')
            ),
          ],
        ),
      ),
    );
  }
}
