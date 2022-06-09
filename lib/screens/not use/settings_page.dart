import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Import the firebase_core and cloud_firestore plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vkr_university/check_crazy.dart';

import '../../constants/firestore_constants.dart';
import 'home_page.dart';

class AddUser extends StatefulWidget {

  final User user;

  AddUser(this.user);

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  late final String id;
  late final String? fullName;
  late final String company;
  late final int age;
  late final String? email;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addUser(id,fullName,company,age,email,group,numStudent,fakultet) {
    return users
        .doc(id)
        .set({
      'full_name': fullName, // John Doe
      'company': company, // Stokes and Sons
      'age': age,
      'id': id,
      'email': email,
      '№ группы': group,
      '№ студента': numStudent,
      'Факультет': fakultet,
      'img': 'https://picsum.photos/300'
    })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    final _nameController = TextEditingController();

    final _companyController = TextEditingController();

    final _ageController = TextEditingController();

    final _groupController = TextEditingController();

    final _numStudentController = TextEditingController();

    final _fakultetController = TextEditingController();
    

    return Scaffold(
      appBar: AppBar(
        title: Text('Информация о себе'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        leading: ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: Theme.of(context).primaryColor
          ),
          onPressed: (){
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) =>
                    NewNavigation(widget.user),
              ),
                  (route) => false,
            );
          },
          child: Icon(Icons.arrow_back,color: Colors.amber,),
        ),
      ),
        body:
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Введи свое имя',
                            label: Text('Name'),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _companyController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Университет',
                            label: Text('Университет'),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _ageController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Введите ваш возраст',
                            label: Text('Возраст'),
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _groupController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Введите номер группы',
                            label: Text('Группа'),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _numStudentController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Номер студента',
                            label: Text('№ студента'),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _fakultetController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Введите ваш факультет',
                            label: Text('Факультет'),
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).accentColor
                            ),
                            onPressed: (){
                            addUser(widget.user.uid, _nameController.text, _companyController.text, _ageController.text, widget.user.email,_groupController.text,_numStudentController.text,_fakultetController.text);
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => NewNavigation(widget.user),
                              ),
                                  (route) => false,
                            );
                        },
                            child: Text('Добавить информацию')
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}



