import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vkr_university/model/chart.dart';
import 'package:vkr_university/screens/not%20use/home_page.dart';
import 'package:pie_chart/pie_chart.dart';


class GetUserName extends StatefulWidget {
  final String documentId;
  final User user;

  GetUserName(this.documentId,this.user);

  @override
  State<GetUserName> createState() => _GetUserNameState();
}

class _GetUserNameState extends State<GetUserName> {

  // search(){
  //   var elem = [];
  //   FirebaseFirestore.instance.collection('estimations').doc('ФМИ').collection('822').doc('82210').collection('7')
  //       .get()
  //       .then((QuerySnapshot querySnapshot) {
  //     querySnapshot.docs.forEach((doc) {
  //       elem.add(doc.get('Оценка'));
  //     });
  //     return elem.length;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

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

          var fakultet = data['Факультет'];
          var group = data['№ группы'];
          var student = data['№ студента'];
          List srball = [];

          print(ResultChart(group,student,fakultet).getDocId());



          Map<String, double> dataMap = {
            "Отлично": 42,
            "Хорошо": 55,
            "Удовлетворительно": 3,
          };
          final colorList = <Color> [
            Colors.green,Colors.amber,Colors.red
          ];
          return Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            body:
            ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(20),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                                Radius.circular(20)
                            ),
                            child: Image.network('${data['img']}',
                              width: 200,
                              height: 200,
                              fit:BoxFit.fill,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 50,top: 10,bottom: 5),
                          child:
                          Text("ФИО: ", style: TextStyle(color: Colors.amber)),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 10,bottom: 5),
                          child:
                          Text("${data['full_name']}"),
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 50,top: 5,bottom: 5),
                          child:
                          Text('Факультет: ', style: TextStyle(color: Colors.amber)),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 5,bottom: 5),
                          child:
                          Text('${data['Факультет']}'),
                        ),
                      ],
                    ),
                    Row(

                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 50,top: 5,bottom: 5),
                          child:
                          Text('Курс: ', style: TextStyle(color: Colors.amber)),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 5,bottom: 5),
                          child:
                          Text('${data['Курс']}'),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5,right: 5),
                    ),
                    Row(

                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 50,top: 5,bottom: 5),
                          child:
                          Text('№ группы: ', style: TextStyle(color: Colors.amber)),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 5,bottom: 5),
                          child:
                          Text('${data['№ группы']}'),
                        ),
                      ],
                    ),
                    Row(

                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 50,top: 5,bottom: 5),
                          child:
                          Text('№ зачетной книжки: ', style: TextStyle(color: Colors.amber)),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 5,bottom: 5),
                          child:
                          Text('${data['№ студента']}'),
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Row(

                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 50,top: 5,bottom: 5),
                          child:
                          Text('E-mail: ', style: TextStyle(color: Colors.amber)),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 5,bottom: 5),
                          child:
                          Text('${data['email']}'),
                        ),
                      ],
                    ),
                    Row(

                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 50,top: 5,bottom: 5),
                          child:
                          Text('Возраст: ', style: TextStyle(color: Colors.amber)),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 5,bottom: 5),
                          child:
                          Text('${data['age']}'),
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: 40)),
                    Container(
                      child: Text('Краткая успеваемость'),
                    ),
                    Padding(padding: EdgeInsets.only(top: 20)),
                    PieChart(
                      dataMap: dataMap,
                      animationDuration: Duration(milliseconds: 800),
                      chartLegendSpacing: 32,
                      chartRadius: MediaQuery.of(context).size.width / 3.2,
                      colorList: colorList,
                      initialAngleInDegree: 0,
                      chartType: ChartType.ring,
                      ringStrokeWidth: 32,
                      centerText: "Оценки",
                      legendOptions: LegendOptions(
                        showLegendsInRow: false,
                        legendPosition: LegendPosition.right,
                        showLegends: true,
                        // legendShape: _BoxShape.circle,
                        legendTextStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      chartValuesOptions: ChartValuesOptions(
                        showChartValueBackground: true,
                        showChartValues: true,
                        showChartValuesInPercentage: false,
                        showChartValuesOutside: false,
                        decimalPlaces: 1,
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 20)),
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