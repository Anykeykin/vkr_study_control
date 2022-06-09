import 'dart:io';
import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Import the firebase_core and cloud_firestore plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import '../constants/firestore_constants.dart';

class Estimation extends StatefulWidget {
  final User user;

  Estimation(this.user);

  @override
  State<Estimation> createState() => _EstimationState();
}

class _EstimationState extends State<Estimation> {
  late List<List<dynamic>> employeeData;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<PlatformFile>? _paths;
  String? _extension = "csv";
  FileType _pickingType = FileType.custom;

  late final String fakultet;
  late final String group;
  late final String numStudent;
  late final String semestr;
  late final String subject;

  final _formKey = GlobalKey<FormState>();
  final _fakultetController = TextEditingController();
  final _groupController = TextEditingController();
  final _numStudentController = TextEditingController();
  final _semestrController = TextEditingController();
  final _subjectController = TextEditingController();
  final _estimationController = TextEditingController();
  final _timeController = TextEditingController();
  bool _isProgress = false;

  @override
  void initState() {
    super.initState();
    employeeData = List<List<dynamic>>.empty(growable: true);
  }

  @override

  Widget build(BuildContext context) {

    // Create a CollectionReference called users that references the firestore collection
    CollectionReference estimations = FirebaseFirestore.instance.collection('estimations');

    Future<void> addEstimation(fakultet,group,numStudent,semestr,subject,estimation,time,name) {
      return estimations
          .doc(fakultet)
          .collection(group)
          .doc('${numStudent}')
          .collection('${semestr}')
          .doc(subject)
          .set({
        'Предмет': '${subject}', // John Doe
        'Оценка': '${estimation}', // Stokes and Sons
        'Преподаватель': name,
        'Часы': '${time}',
      })
          .then((value) => print("Estimation Added"))
          .catchError((error) => print("Failed to add estimation: $error"));
    }

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
                              hintText: 'Введите факультет',
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
                                for(var i = 1; i != employeeData.length;i++){
                                  addEstimation(_fakultetController.text, _groupController.text, employeeData[i][0], employeeData[i][4], employeeData[i][3], employeeData[i][1], employeeData[i][5], employeeData[i][2]);
                                }
                                // addEstimation(_fakultetController.text,_groupController.text,_numStudentController.text,_semestrController.text,_subjectController.text,_estimationController.text,_timeController.text,data['full_name']);
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

        return Center(
          child: CircularProgressIndicator(
            semanticsLabel: 'Загрузка',
          ),
        );
      },
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
      // print('Элемент 1${employeeData[1][0]}');
      // print('Элемент 1${employeeData[1][1]}');
      // print('Элемент 1${employeeData[1][2]}');
      // print('Элемент 4${employeeData[1][3]}');
      // print('Элемент 4${employeeData[1][4]}');
      // print('Элемент 1${employeeData[1][5]}');
      // print(employeeData.length);
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






