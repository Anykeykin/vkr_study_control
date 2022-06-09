import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Import the firebase_core and cloud_firestore plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vkr_university/check_crazy.dart';

import 'not use/home_page.dart';

class EstimationStudentInfo extends StatefulWidget {
  final String? fakultet;
  final String group;
  final String numStudent;
  final String semestr;
  final User user;

  EstimationStudentInfo(this.fakultet, this.group, this.numStudent, this.semestr, this.user);

  @override
  State<EstimationStudentInfo> createState() => _EstimationStudentInfoState();
}

class _EstimationStudentInfoState extends State<EstimationStudentInfo> {
  List<String> colors = ['Colors.red','Colors.green','Colors.yellow'];

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('estimations').doc(widget.fakultet).collection(widget.group).doc(widget.numStudent).collection(widget.semestr).snapshots();
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('${widget.semestr} Семестр',style: TextStyle(color: Colors.amber)),
        centerTitle: true,
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
      body: StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return ListView(
            children: [
              Column(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                  print(data);
                  String selectColor;
                  //Выбирает определенный цвет
                  //Первый мой комментарий для Андрея)
                  getTheme() {
                    if(data['Оценка'] == '4') return Colors.amber;
                    else if(data['Оценка'] == '5') return Colors.green;
                    else return Colors.red;
                  }
                  return Card(
                    color: Colors.white12,
                    shape: RoundedRectangleBorder(
                        side:  BorderSide(color: getTheme(),width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(5))
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0,left: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(top: 10,bottom: 5),
                                    child:
                                    Text("Предмет: ${data['Предмет']}"),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: 10,bottom: 5),
                                    child:
                                    Text("Оценка: ${data['Оценка']}"),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: 5,bottom: 5),
                                    child:
                                    Text('Преподаватель : ${data['Преподаватель']}'),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: 5,bottom: 25),
                                    child:
                                    Text('Количество часов : ${data['Часы']}'),
                                  ),
                                ],
                              ),
                              Spacer(flex: 2),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(padding: EdgeInsets.only(right: 50)),

                                  Container(
                                    padding: EdgeInsets.only(top: 20,bottom: 5),
                                    child:
                                    Text("${data['Оценка']}", style: TextStyle(color: getTheme(),fontSize: 50)),
                                  ),
                                ],
                              ),
                              Padding(padding: EdgeInsets.only(bottom: 100))
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),
    );
  }
}