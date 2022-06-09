import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../check_crazy.dart';

class Botpage extends StatefulWidget {
  final User user;

  Botpage(this.user);
  @override
  State<Botpage> createState() => _BotpageState();
}

class _BotpageState extends State<Botpage> {
  final _contentController = TextEditingController();
  bool cher = false;
  List fakulData = [];
  List groupData = [];
  List timeData = [];
  List DayData = [];
  List teacher = [];

  @override
  Future getFakultet() async {
    await FirebaseFirestore.instance
        .collection('lessons')
        .get()
        .then((snapshot) => snapshot.docs.forEach((document) {
      print(document.id);
      setState((){
        fakulData.add(document.id);
      });
    }));
  }

  Future getGroup() async {
    await FirebaseFirestore.instance
        .collection('lessons')
        .get()
        .then((snapshot) => snapshot.docs.forEach((document) {
      setState((){
        if(document.data().keys.isNotEmpty) {
          // print(document.data().keys);
          var trimmedString = document.data().keys.toString().substring(1,document.data().keys.toString().length-1);
          print(trimmedString);
          groupData.add(trimmedString);
        }
      });
    }));
  }

  void initState() {
    getGroup();
    getFakultet();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text('Расписание Преподавателя'),
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
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              buildInput(),
              buildListMessage(),
            ],
          ),
        ],
      ),
    );
  }


  Widget buildListMessage() {

    return Column(
      children: [
          if(fakulData != '')
          Text('${fakulData}'),
          if(groupData != '')
          Text('${groupData}'),
          if(timeData != '')
              for(var j = 0; j < timeData.length;j++)
                Column(
                  children: [
                    Text('${DayData[j]}'),
                    Row(
                      children: [
                        Text('${timeData[j]}'),
                        Text(' - '),
                        Text('${teacher[j]}'),
                      ],
                    )
                  ],
                ),
      ],
    );

  }

  Widget buildInput() {
    Work(text) {
      print('Проверка программы');
      var strSt1 = text.split(',');
      var strSt2 = strSt1[1].toString();
      var strSt3 = strSt2.substring(0,strSt2.length-4);
      var strSt4 = strSt3.split('.');
      if(strSt4.length == 2) strSt4.removeAt(0);
      var strSt5 = strSt4[0];
      var strSt6 = strSt5.split(' ');
      print(strSt1);
      if(strSt6.length == 2) return strSt6[0].toString();
      else return strSt6[1].toString();
    }

    Future<void> collector(idFrom,Content) async{
      print(fakulData);
      print(groupData);
      for(var i = 0; i < fakulData.length;i++){
        print('help');
        for(var j = 0; j < groupData.length;j++){

          await FirebaseFirestore.instance
              .collection('lessons')
              .doc('${fakulData[i]}')
              .collection('${groupData[j]}')
              .get()
              .then((snapshot) => snapshot.docs.forEach((document) {
                print('helloOne');
                if(document.get('1 пара 08:30-10:00') != '') {
                  var surname = Work(document.get('1 пара 08:30-10:00'));
                  if(Content == surname) {
                    print('Совпадение! - ${surname.toString()}');
                    setState((){
                      timeData.add('1 пара 08:30-10:00');
                      teacher.add(surname);
                      DayData.add(document.get('weekday'));
                    });
                  }
                }
                if(document.get('2 пара 10:10-11:40') != '') {
                  var surname = Work(document.get('2 пара 10:10-11:40'));
                  if(Content == surname) {
                    print('Совпадение! - ${surname.toString()}');
                    setState((){
                      timeData.add('2 пара 10:10-11:40');
                      teacher.add(surname);
                      DayData.add(document.get('weekday'));
                    });
                  }
                }
                if(document.get('3 пара 11:50-13:20') != '') {
                  var surname = Work(document.get('3 пара 11:50-13:20'));
                  if(Content == surname) {
                    print('Совпадение! - ${surname.toString()}');
                    setState((){
                      timeData.add('3 пара 11:50-13:20');
                      teacher.add(surname);
                      DayData.add(document.get('weekday'));
                    });
                  }
                }
                if(document.get('4 пара 13:40-15:10') != '') {
                  var surname = Work(document.get('4 пара 13:40-15:10'));
                  if(Content == surname) {
                    setState((){
                      timeData.add('4 пара 13:40-15:10');
                      teacher.add(surname);
                      DayData.add(document.get('weekday'));
                    });

                    print('Совпадение! - ${surname.toString()}');
                  }

                }
                if(document.get('5 пара 15:20-16:50') != '') {
                  var surname = Work(document.get('5 пара 15:20-16:50'));
                  if(Content == surname) {
                    setState((){
                      timeData.add('5 пара 15:20-16:50');
                      teacher.add(surname);
                      DayData.add(document.get('weekday'));
                    });
                    print('Совпадение! - ${surname.toString()}');
                  }
                }
                if(document.get('6 пара 17:00-18:30') != '') {
                  var surname = Work(document.get('6 пара 17:00-18:30'));
                  if(Content == surname) {
                    setState((){
                      timeData.add('6 пара 17:00-18:30');
                      teacher.add(surname);
                      DayData.add(document.get('weekday'));
                    });
                    print('Совпадение! - ${surname.toString()}');
                  }
                }
              }));
        }
      }


    }
    return Container(
      child: Row(
        children: <Widget>[
          // Edit text
          Flexible(
            child: Container(
              padding: EdgeInsets.all(15),
              child: TextField(
                style: TextStyle(fontSize: 15),
                maxLines: 2,
                minLines: 1,
                controller: _contentController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Введите Фамилию',
                ),
              ),
            ),
          ),


          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8),
              child: IconButton(
                  color: Colors.amber,
                  icon: Icon(Icons.send),
                  onPressed: () {
                    bool signal = false;
                    if(_contentController.text.length == 0 || _contentController.text[0] == '\n') {
                      signal = true;
                      for(var i = 0; i <_contentController.text.length; i++){
                        if(_contentController.text[i] == '' || _contentController.text[i] == '\n' ) signal = true;
                        else signal = false;
                        break;
                      }
                    }
                    if(signal == true){

                    } else {
                      timeData.clear();
                      teacher.clear();
                      DayData.clear();
                      collector(widget.user.uid, _contentController.text);
                      _contentController.clear();
                    }
                  }
              ),
            ),
            // color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50,
    );
  }
}
