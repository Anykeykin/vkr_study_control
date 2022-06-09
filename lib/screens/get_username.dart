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

  GetUserName(this.documentId, this.user);

  @override
  State<GetUserName> createState() => _GetUserNameState();
}

class _GetUserNameState extends State<GetUserName> {
  List<String> docIds = [];
  List<String> numEst = [];

  Future getDocId() async {
    await FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((snapshot) => snapshot.docs.forEach((document) {
              setState(() {
                docIds.add(document.get('Факультет'));
                docIds.add(document.get('№ группы'));
                docIds.add(document.get('№ студента'));
                // getNum();
              });
            }));
  }

  Future getNum() async {
    print('getNum');
    for (var i = 1; i <= 10; i++) {
      await FirebaseFirestore.instance
          .collection('estimations')
          .doc(docIds[0])
          .collection(docIds[1])
          .doc(docIds[2])
          .collection('$i')
          .get()
          .then((snapshot) => snapshot.docs.forEach((document) {
              if (document.exists) {
                setState(() {
                  numEst.add(document.get('Оценка'));
                  // print(document.get('Оценка'));
                });
              }
          }));
    }
  }

  @override
  void initState() {
    // getDocId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(docIds);
    // print(numEst);
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    chart(arrEst,estimation){
      var share = 0.0;
      for(var i = 0;i < arrEst.length;i++) {
        if(estimation == int.parse(arrEst[i])) {
          share++;
        }
      }
      return share/arrEst.length * 100;
    }
    Map<String, double> dataMap = {
      // "Отлично": chart(numEst,5),
      // "Хорошо": chart(numEst,4),
      // "Удовлетворительно": chart(numEst,3),
      "Отлично": 45,
      "Хорошо": 40,
      "Удовлетворительно": 15,
    };
    final colorList = <Color>[Colors.green, Colors.amber, Colors.red];

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: ListView(
        children: [
          FutureBuilder<DocumentSnapshot>(
            future: users.doc(widget.documentId).get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text("Something went wrong");
              }

              if (snapshot.hasData && !snapshot.data!.exists) {
                return Text("Document does not exist");
              }

              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(20),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            child: Image.network(
                              '${data['img']}',
                              width: 200,
                              height: 200,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding:
                              EdgeInsets.only(left: 50, top: 10, bottom: 5),
                          child: Text("ФИО: ",
                              style: TextStyle(color: Colors.amber)),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 10, bottom: 5),
                          child: Text("${data['full_name']}"),
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 50, top: 5, bottom: 5),
                          child: Text('Факультет: ',
                              style: TextStyle(color: Colors.amber)),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 5, bottom: 5),
                          child: Text('${data['Факультет']}'),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 50, top: 5, bottom: 5),
                          child: Text('Курс: ',
                              style: TextStyle(color: Colors.amber)),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 5, bottom: 5),
                          child: Text('${data['Курс']}'),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5, right: 5),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 50, top: 5, bottom: 5),
                          child: Text('№ группы: ',
                              style: TextStyle(color: Colors.amber)),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 5, bottom: 5),
                          child: Text('${data['№ группы']}'),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 50, top: 5, bottom: 5),
                          child: Text('№ зачетной книжки: ',
                              style: TextStyle(color: Colors.amber)),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 5, bottom: 5),
                          child: Text('${data['№ студента']}'),
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 50, top: 5, bottom: 5),
                          child: Text('E-mail: ',
                              style: TextStyle(color: Colors.amber)),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 5, bottom: 5),
                          child: Text('${data['email']}'),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 50, top: 5, bottom: 5),
                          child: Text('Возраст: ',
                              style: TextStyle(color: Colors.amber)),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 5, bottom: 5),
                          child: Text('${data['age']}'),
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: 40)),
                  ],
                );
              }

              return Center(
                child: CircularProgressIndicator(
                  semanticsLabel: 'Загрузка',
                ),
              );
            },
          ),
          Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Text('Краткая успеваемость'),
                ),
                // Container(
                //   child: Text('${numEst}'),
                // ),
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
              )
        ],
      ),
    );
  }
}
