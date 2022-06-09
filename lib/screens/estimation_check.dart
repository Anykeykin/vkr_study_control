import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Import the firebase_core and cloud_firestore plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vkr_university/screens/estimation.dart';
import 'package:vkr_university/screens/lesson_student_info.dart';

import '../constants/firestore_constants.dart';
import 'estimation_info.dart';
import 'not use/home_page.dart';

class CheckEstimation extends StatefulWidget {
  final User user;

  CheckEstimation( this.user);

  @override
  State<CheckEstimation> createState() => _CheckEstimationState();
}

class _CheckEstimationState extends State<CheckEstimation> {

  final _formKey = GlobalKey<FormState>();
  final _fakultetController = TextEditingController();
  final _groupController = TextEditingController();
  final _numStudentController = TextEditingController();
  final _semestrController = TextEditingController();
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
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _semestrController,
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
                          hintText: 'Введите семестр',
                          label: Text('Семестр',style: TextStyle(color: Colors.amber)),
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
                                builder: (context) => EstimationStudentInfo(data['Факультет'],data['№ группы'],data['№ студента'],_semestrController.text,widget.user),
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
                              'Открыть Ведомость',
                              style: TextStyle(fontSize: 22.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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



