import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';


class FileCheckRead extends StatefulWidget {
  final User user;

  FileCheckRead(this.user);

  @override
  State<FileCheckRead> createState() => _FileCheckReadState();
}

// class _FileCheckReadState extends State<FileCheckRead> {
//   late List<List<dynamic>> employeeData;
//
//   @override
//   initState(){
//
//     employeeData  = List<List<dynamic>>.empty(growable: true);
//     for (int i = 0; i <5;i++) {
//       List<dynamic> row = List.empty(growable: true);
//       row.add("Employee Name $i");
//       row.add((i%2==0)?"Male":"Female");
//       row.add(" Experience : ${i*5}");
//       employeeData.add(row);
//     }
//   }
//
//   getCsv() async {
//
//     if (await Permission.storage.request().isGranted) {
//
// //store file in documents folder
//
//       String dir = (await getExternalStorageDirectory())!.path + "/mycsv.csv";
//       String file = "$dir";
//       print(file);
//
//       File f = new File(file);
//
// // convert rows to String and write as csv file
//
//       String csv = const ListToCsvConverter().convert(employeeData);
//       f.writeAsString(csv);
//     }else{
//
//       Map<Permission, PermissionStatus> statuses = await [
//         Permission.storage,
//       ].request();
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//
//           children: <Widget>[
//             ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: employeeData.length,
//                 itemBuilder: (context,index){
//                   return Card(
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(employeeData[index][0]),
//                           Text(employeeData[index][1]),
//                           Text(employeeData[index][2]),
//                         ],
//                       ),
//                     ),
//                   );
//                 }),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Container(
//                 color: Colors.green,
//                 height: 30,
//                 child: TextButton(
//                   child: Text("Export to CSV",style: TextStyle(color: Colors.white),),
//                   onPressed: getCsv,
//                 ),
//               ),
//             ),
//
//           ],
//         ),
//       ),
//
//       // This trailing comma makes auto-formatting nicer for build methods.
//     );
//
//   }
//   // late String finalPath;
//   // List<List<dynamic>> _data = [];
//   //
//   // // This function is triggered when the floating button is pressed
//   //
//   //
//   // void _pickFile() async {
//   //   String platformVersion;
//   //   // opens storage to pick files and the picked file or files
//   //   // are assigned into result and if no file is chosen result is null.
//   //   // you can also toggle "allowMultiple" true or false depending on your need
//   //   final result = await FilePicker.platform.pickFiles(allowMultiple: false);
//   //   print('1');
//   //   print('2');
//   //   print(result.toString());
//   //   print(result!.files.first.size);
//   //   print(result.files.first.path);
//   //   print('3');
//   //   setState(() {
//   //     finalPath = '${result.paths.first.toString()}';
//   //   });
//   //   _loadCSV();
//   //   // if no file is picked
//   //   if (result == null) return;
//   //   // var rows = myCSV.rowsCount;
//   //   // var columns = myCSV.columnCount;
//   //
//   // }
//   // void _loadCSV() async {
//   //   final _rawData = await rootBundle.loadString('assets/file.csv');
//   //   List<List<dynamic>> _listData =
//   //   const CsvToListConverter().convert(_rawData);
//   //   setState(() {
//   //     _data = _listData;
//   //   });
//   // }
//   // @override
//   //
//   //
//   //
//   // Widget build(BuildContext context) {
//   //   return Scaffold(
//   //     body:
//   //     ListView.builder(
//   //         itemCount: _data.length,
//   //         itemBuilder: (_, index) {
//   //           return Card(
//   //             margin: const EdgeInsets.all(3),
//   //             color: index == 0 ? Colors.amber : Colors.white,
//   //             child: ListTile(
//   //               leading: Text(_data[index][0].toString()),
//   //               title: Text(_data[index][1]),
//   //               trailing: Text(_data[index][2].toString()),
//   //             ),
//   //           );
//   //         },
//   //       ),
//   //     floatingActionButton:
//   //       FloatingActionButton(
//   //       onPressed: (){
//   //         // _loadCSV();
//   //         // excelToJson();
//   //       },
//   //       child: Text('FileRead'),
//   //     ),
//   //   );
//   // }
//
//
// }
class _FileCheckReadState extends State<FileCheckRead> {
  late List<List<dynamic>> employeeData;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<PlatformFile>? _paths;
  String? _extension = "csv";
  FileType _pickingType = FileType.custom;

  @override
  void initState() {
    super.initState();
    employeeData = List<List<dynamic>>.empty(growable: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: employeeData.isEmpty
            ? Center(
                child: Container(
                  color: Colors.green,
                  height: 30,
                  child: TextButton(
                    child: Text(
                      "CSV To List", style: TextStyle(color: Colors.white),),
                    onPressed: _openFileExplorer,
                  ),
                ),
            )
            : ListView(
          children: [
            Container(
              color: Colors.green,
              height: 30,
              child: TextButton(
                child: Text(
                  "CSV To List", style: TextStyle(color: Colors.white),),
                onPressed: _openFileExplorer,
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child:
            // ),
            Center(
              child: Column(
                children: [
                  Text('${employeeData.length}\n'),
                  Text('${employeeData[0][3]}'),
                  Text('${employeeData[0][7]}  ${employeeData[0][10]},\n'),
                  Text('${employeeData[0][20]} ${employeeData[0][23]},\n'),
                  Text('${employeeData[0][33]}  ${employeeData[0][36]},\n'),
                  Text('${employeeData[0][46]} ${employeeData[0][49]},\n'),
                  Text('${employeeData[0][59]}  ${employeeData[0][62]},\n'),
                  Text('${employeeData[0][72]}  ${employeeData[0][75]},\n'),
                ],
              ),
            ),
            Text("Среда"),
            Center(
              child: Column(
                children: [
                  Text('${employeeData[0].length}\n'),
                  Text('${employeeData[0][4]}'),
                  Text('${employeeData[0][7]}  ${employeeData[0][11]},\n'),
                  Text('${employeeData[0][20]} ${employeeData[0][24]},\n'),
                  Text('${employeeData[0][33]}  ${employeeData[0][37]},\n'),
                  Text('${employeeData[0][46]} ${employeeData[0][50]},\n'),
                  Text('${employeeData[0][59]}  ${employeeData[0][63]},\n'),
                  Text('${employeeData[0][72]}  ${employeeData[0][76]},\n'),
                ],
              ),
            ),
            Text("Четверг"),
            Center(
              child: Column(
                children: [
                  Text('${employeeData[0][5]}'),
                  Text('${employeeData[0][7]}  ${employeeData[0][12]},\n'),
                  Text('${employeeData[0][20]} ${employeeData[0][24]},\n'),
                  Text('${employeeData[0][33]}  ${employeeData[0][38]},\n'),
                  Text('${employeeData[0][46]} ${employeeData[0][51]},\n'),
                  Text('${employeeData[0][59]}  ${employeeData[0][64]},\n'),
                  Text('${employeeData[0][72]}  ${employeeData[0][77]},\n'),
                ],
              ),
            ),
            Text("Пятница"),
            Center(
              child: Column(
                children: [
                  Text('${employeeData[0][6]}'),
                  Text('${employeeData[0][7]}  ${employeeData[0][13]},\n'),
                  Text('${employeeData[0][20]} ${employeeData[0][26]},\n'),
                  Text('${employeeData[0][33]}  ${employeeData[0][39]},\n'),
                  Text('${employeeData[0][46]} ${employeeData[0][52]},\n'),
                  Text('${employeeData[0][59]}  ${employeeData[0][65]},\n'),
                  Text('${employeeData[0][72]}  ${employeeData[0][78]},\n'),
                ],
              ),
            ),
            Text("Суббота"),
            Center(
              child: Column(
                children: [
                  Text('${employeeData[0][7]}'),
                  Text('${employeeData[0][7]}  ${employeeData[0][14]},\n'),
                  Text('${employeeData[0][20]} ${employeeData[0][27]},\n'),
                  Text('${employeeData[0][33]}  ${employeeData[0][40]},\n'),
                  Text('${employeeData[0][46]} ${employeeData[0][53]},\n'),
                  Text('${employeeData[0][59]}  ${employeeData[0][66]},\n'),
                  Text('${employeeData[0][72]}  ${employeeData[0][79]},\n'),
                ],
              ),
            ),
          ],
        )
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