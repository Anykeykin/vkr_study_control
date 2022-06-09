import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Import the firebase_core and cloud_firestore plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vkr_university/screens/bot_page.dart';
import 'package:vkr_university/screens/lesson_student_info.dart';

import '../constants/firestore_constants.dart';
import 'not use/home_page.dart';

class CheckGroup extends StatefulWidget {
  final User user;

  CheckGroup( this.user);

  @override
  State<CheckGroup> createState() => _CheckGroupState();
}

class _CheckGroupState extends State<CheckGroup> {
  late final String fakultet;
  late final int group;

  final _formKey = GlobalKey<FormState>();
  final _fakultetController = TextEditingController();
  final _groupController = TextEditingController();
  bool _isProgress = false;
  @override

  Widget build(BuildContext context) {

    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(widget.user.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          return GestureDetector(
            child: Scaffold(
              backgroundColor: Theme.of(context).primaryColor,
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: _fakultetController,
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
                          hintText: 'Введите ваш факультет',
                          label: Text('Факультет',style: TextStyle(color: Colors.amber)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _groupController,
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
                          hintText: 'Введите вашу группу',
                          label: Text('Группа',style: TextStyle(color: Colors.amber)),
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
                            setState(() {
                              _isProgress = true;
                            });
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => LessonStudentInfo(widget.user,_fakultetController.text,_groupController.text),
                              ),
                                  (route) => false,
                            );
                            setState(() {
                              _isProgress = false;
                            });
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'Открыть Расписание',
                              style: TextStyle(fontSize: 22.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              floatingActionButton: FloatingActionButton.extended(
                label: Text('Расписание Преподавателя',
                  style: TextStyle(
                    color: Colors.white
                  )),
                backgroundColor: Colors.blue,
                onPressed: (){
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => Botpage(widget.user),
                    ),
                        (route) => false,
                  );
                },
              ),
            ),
          );
        }

        return Center(
          child: CircularProgressIndicator(
            semanticsLabel: 'Загрузка',
          ),
        );
      },
    );

  }
}



