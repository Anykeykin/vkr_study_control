import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vkr_university/screens/check_group.dart';
import 'package:vkr_university/screens/estimation_check.dart';
import 'package:vkr_university/screens/get_username.dart';
import 'package:vkr_university/screens/lesson.dart';
import 'package:vkr_university/screens/not%20use/lesson_student.dart';
import 'package:vkr_university/screens/not%20use/settings_page.dart';
import 'screens/lesson_student_info.dart';
import 'screens/read_file.dart';
import 'utils/authentication_client.dart';
import 'screens/estimation.dart';
import 'screens/login_page.dart';
import 'screens/messenger.dart';


class NewNavigation extends StatefulWidget {
  final User user;

  NewNavigation(this.user);

  @override
  State<NewNavigation> createState() => _NewNavigationState();
}

class _NewNavigationState extends State<NewNavigation> {
  int selectedIndex = 0;
  final _authClient = AuthenticationClient();
  bool _isProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Учебный помощник", style: TextStyle(color: Colors.amber)),
        actions: [
          IconButton(
            onPressed: () async {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) =>  AddUser(widget.user),
                ),
                    (route) => false,
              );
            },
            icon: Icon(Icons.settings),
          ),
          IconButton(
            onPressed: () async {
            setState(() {
              _isProgress = true;
            });
            await _authClient.logoutUser();
              setState(() {
                _isProgress = false;
              });
            final directory = await getApplicationDocumentsDirectory();
            final file = File('${directory.path}/my_file.txt').delete();
            print('deleted');
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
                ),
                  (route) => false,
                );
            },
            icon: Icon(Icons.exit_to_app),
          ),

        ],
      ),
      body: this.getBody(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: this.selectedIndex,
        // backgroundColor: Theme.of(context).primaryColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            label: "Главная",
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.upgrade_rounded),
          //   label: "Загрузка Расписания",
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_indent_increase),
            label: "Расписание",
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.add),
          //   label: "Загрузка Оценок",
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: "Успеваемость",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mail),
            label: "Сообщения",
          )
        ],
        onTap: (int index) {
          this.onTapHandler(index);
        },
      ),
    );
  }

  Widget getBody() {
    if (this.selectedIndex == 0) {
      return GetUserName(widget.user.uid, widget.user);
    }
    // else if (this.selectedIndex == 1) {
    //   return Lesson(widget.user);
    // }
    else if (this.selectedIndex == 1) {
      return CheckGroup(widget.user);
    }
    // else if (this.selectedIndex == 3) {
    //   return Estimation(widget.user);
    // }
    else if (this.selectedIndex == 2) {
      return CheckEstimation(widget.user);
    }
    else {
      return Messenger(widget.user);
    }
  }

  void onTapHandler(int index) {
    this.setState(() {
      this.selectedIndex = index;
    });
  }
}
