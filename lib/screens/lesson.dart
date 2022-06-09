import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Import the firebase_core and cloud_firestore plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import '../constants/firestore_constants.dart';
import 'not use/home_page.dart';

class Lesson extends StatefulWidget {
  final User user;

  Lesson(this.user);

  @override
  State<Lesson> createState() => _LessonState();
}

class _LessonState extends State<Lesson> {
  late List<List<dynamic>> employeeData;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<PlatformFile>? _paths;
  String? _extension = "csv";
  FileType _pickingType = FileType.custom;


  late final String fakultet;
  late final int group;
  late final String weekDay;
  late final String lesson;


  final _formKey = GlobalKey<FormState>();
  final _fakultetController = TextEditingController();
  final _groupController = TextEditingController();
  final _weekDayController = TextEditingController();
  bool _isProgress = false;


  @override
  void initState() {
    super.initState();
    employeeData = List<List<dynamic>>.empty(growable: true);
  }

  @override

  Widget build(BuildContext context) {

    // Create a CollectionReference called users that references the firestore collection
    CollectionReference lessons = FirebaseFirestore.instance.collection('lessons');

    Future<void> addLesson(fakultet,group,weekday,week,time,lesson) {
      return lessons
          .doc(fakultet)
          .collection(group)
          .doc(weekday)
          .set({
        '1 пара 08:30-10:00':  '${employeeData[0][8 + int.parse(weekday) + 1]}',
        '2 пара 10:10-11:40': '${employeeData[0][24 + int.parse(weekday) + 1]}',
        '3 пара 11:50-13:20': '${employeeData[0][40 + int.parse(weekday) + 1]}',
        '4 пара 13:40-15:10': '${employeeData[0][56 + int.parse(weekday) + 1]}',
        '5 пара 15:20-16:50': '${employeeData[0][72 + int.parse(weekday) + 1]}',
        '6 пара 17:00-18:30': '${employeeData[0][88 + int.parse(weekday) + 1]}',
        'weekday': week,
      })
          .then((value) => print("Lesson Added"))
          .catchError((error) => print("Failed to add lesson: $error"));
    }

    sendDocWeek(elem) {
      if(elem == 'Пн' || elem == 'Понедельник') {
        return 'Понедельник';
      }
      if(elem == 'Вт' || elem == 'Вторник') {
        return 'Вторник';
      }
      if(elem == 'Ср' || elem == 'Среда') {
        return 'Среда';
      }
      if(elem == 'Чт' || elem == 'Четверг') {
        return 'Четверг';
      }
      if(elem == 'Пт' || elem == 'Пятница') {
        return 'Пятница';
      }
      if(elem == 'Сб' || elem == 'Суббота') {
        return 'Суббота';
      }
    }
    
    sendWeek(elem) {
      if(elem == 'Пн' || elem == 'Понедельник') {
        return '1';
      }
      if(elem == 'Вт' || elem == 'Вторник') {
        return '2';
      }
      if(elem == 'Ср' || elem == 'Среда') {
        return '3';
      }
      if(elem == 'Чт' || elem == 'Четверг') {
        return '4';
      }
      if(elem == 'Пт' || elem == 'Пятница') {
        return '5';
      }
      if(elem == 'Сб' || elem == 'Суббота') {
        return '6';
      }
    }

    return GestureDetector(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body:
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _scaffoldKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: _fakultetController,
                      decoration: InputDecoration(
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
                        hintText: 'Введите факультет',
                        label: Text('Факультет',style: TextStyle(color: Colors.amber)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _groupController,
                      decoration: InputDecoration(
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
                        hintText: 'Введите группу',
                        label: Text('Группа',style: TextStyle(color: Colors.amber)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      color: Colors.blue,
                      height: 30,
                      child: TextButton(
                        child: Text(
                          "Выбрать файл", style: TextStyle(color: Colors.white),),
                        onPressed: _openFileExplorer,
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
                          if(employeeData.isNotEmpty) {
                            addLesson(_fakultetController.text,_groupController.text,sendWeek(employeeData[0][2]),sendDocWeek(employeeData[0][2]),employeeData[0][56],employeeData[0][61]);
                            addLesson(_fakultetController.text,_groupController.text,sendWeek(employeeData[0][3]),sendDocWeek(employeeData[0][3]),employeeData[0][56],employeeData[0][61]);
                            addLesson(_fakultetController.text,_groupController.text,sendWeek(employeeData[0][4]),sendDocWeek(employeeData[0][4]),employeeData[0][56],employeeData[0][61]);
                            addLesson(_fakultetController.text,_groupController.text,sendWeek(employeeData[0][5]),sendDocWeek(employeeData[0][5]),employeeData[0][56],employeeData[0][61]);
                            addLesson(_fakultetController.text,_groupController.text,sendWeek(employeeData[0][6]),sendDocWeek(employeeData[0][6]),employeeData[0][56],employeeData[0][61]);
                            addLesson(_fakultetController.text,_groupController.text,sendWeek(employeeData[0][7]),sendDocWeek(employeeData[0][7]),employeeData[0][56],employeeData[0][61]);
                          }
                          setState(() {
                            _isProgress = false;
                          });
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            'Добавить',
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

  openFile(filepath) async
  {
    File f = new File(filepath);
    print("CSV to List");
    final input = f.openRead();
    final fields = await input.transform(utf8.decoder).transform(
        new CsvToListConverter()).toList();
    print(fields);
    setState(() {
      employeeData = fields;
    });
  }

  void _openFileExplorer() async {
    try {
      _paths = (await FilePicker.platform.pickFiles(
        type: _pickingType,
        allowMultiple: false,
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '').split(',')
            : null,
      ))
          ?.files;
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    } catch (ex) {
      print(ex);
    }
    if (!mounted) return;
    setState(() {
      openFile(_paths![0].path);
      print(_paths);
      print("File path ${_paths![0]}");
      print(_paths!.first.extension);
    });
  }
}



