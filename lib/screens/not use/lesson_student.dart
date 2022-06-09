import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vkr_university/screens/not%20use/home_page.dart';

class LessonStudent extends StatefulWidget {
  final String documentId;
  final User user;

  LessonStudent(this.documentId,this.user);

  @override
  State<LessonStudent> createState() => _LessonStudentState();
}

class _LessonStudentState extends State<LessonStudent> {
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('lessons').doc('ФМИ').collection('822');
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(widget.documentId).get(),
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
          print(data);
          return Scaffold(
            body:
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Container(
                      padding: EdgeInsets.only(top: 10,bottom: 5),
                      child:
                      Text(widget.documentId),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10,bottom: 5),
                      child:
                      Text("08:30: ${data['08:30']}"),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 5,bottom: 5),
                      child:
                      Text('10:10 : ${data['10:10']}'),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 5,bottom: 5),
                      child:
                      Text('11:50 : ${data['11:50']}'),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 5,bottom: 5),
                      child:
                      Text('13:40 : ${data['13:40']}'),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 5,bottom: 5),
                      child:
                      Text('15:20 : ${data['15:20']}'),
                    ),
                    Padding(padding: EdgeInsets.only(top: 40)),
                    Container(
                      child: Text('Краткая успеваемость'),
                    ),
                  ],
                ),
              ],
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