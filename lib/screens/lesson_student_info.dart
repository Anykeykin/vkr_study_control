import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Import the firebase_core and cloud_firestore plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vkr_university/check_crazy.dart';

import 'not use/home_page.dart';

class LessonStudentInfo extends StatefulWidget {
  final String? fakultet;
  final String group;
  final User user;

  LessonStudentInfo(this.user,this.fakultet, this.group);

  @override
  State<LessonStudentInfo> createState() => _LessonStudentInfoState();
}

class _LessonStudentInfoState extends State<LessonStudentInfo> {


  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('lessons').doc(widget.fakultet).collection(widget.group).snapshots();
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text('${widget.group} группа',style: TextStyle(color: Colors.amber),),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        leading:
        IconButton(
          onPressed: (){
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) =>
                    NewNavigation(widget.user),
              ),
                  (route) => false,
            );
          },
          icon: Icon(Icons.arrow_back,color: Theme.of(context).backgroundColor,),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Что-то пошло не так'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: Container(
                    // color: Theme.of(context).primaryColor,
                    child: Text("Загрузка")
                )
            );
          }
          return ListView(
            children: [
              Column(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                  var count = 0;
                  check(elem1) {
                    List<String> arr =  ['08:30','10:10','11:50','13:40','15:20'];
                    for(var elem = 0; elem < arr.length;elem++) {
                      if(data[arr[elem1]] != null) {
                        print(data[arr[elem1]]);
                        return true;
                      }
                    }
                  }

                  return Card(
                    color: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                        side:  BorderSide(color: Theme.of(context).backgroundColor,width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(5))
                    ),
                    child:
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0,left: 20,right: 20,bottom: 8),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  // color: Theme.of(context).primaryColor,
                                  child: Row(
                                    // crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(top: 10,bottom: 5),
                                        child:
                                        Text("День недели: ",style: TextStyle(color: Colors.amber)),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(top: 10,bottom: 5),
                                        child:
                                        Text("${data['weekday']}"),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  color: Theme.of(context).backgroundColor
                                ),
                                Padding(padding: EdgeInsets.only(bottom: 10)),
                                if(data['1 пара 08:30-10:00'] != '')
                                  Container(
                                      padding: EdgeInsets.only(top: 10,bottom: 5),
                                      child:Text('08:30: ${data['1 пара 08:30-10:00']}')
                                    // Text("08:30: ${data['1 пара08:30-10:00']}"),
                                  ),
                                if(data['2 пара 10:10-11:40'] != '')
                                  Container(
                                    padding: EdgeInsets.only(top: 5,bottom: 5),
                                    child:
                                    Text('10:10 : ${data['2 пара 10:10-11:40']}'),
                                  ),
                                if(data['3 пара 11:50-13:20'] != '')
                                  Container(
                                    padding: EdgeInsets.only(top: 5,bottom: 5),
                                    child:
                                    Text('11:50 : ${data['3 пара 11:50-13:20']}'),
                                  ),
                                if(data['4 пара 13:40-15:10'] != '')
                                  Container(
                                    padding: EdgeInsets.only(top: 5,bottom: 5),
                                    child:
                                    Text('13:40 : ${data['4 пара 13:40-15:10']}'),
                                  ),
                                if(data['5 пара 15:20-16:50'] != '')
                                  Container(
                                    padding: EdgeInsets.only(top: 5,bottom: 5),
                                    child:
                                    Text('15:20 : ${data['5 пара 15:20-16:50']}'),
                                  ),
                                if(data['6 пара 17:00-18:30'] != '')
                                  Container(
                                    padding: EdgeInsets.only(top: 5,bottom: 5),
                                    child:
                                    Text('17:00 : ${data['6 пара 17:00-18:30']}'),
                                  ),
                              ],
                            ),
                          ),
                          // Padding(padding: EdgeInsets.only(right: 40))
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