
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';


final CollectionReference estimations = FirebaseFirestore.instance.collection('estimations');

class ResultChart {
  final String fakultet;
  final String group;
  final String student;


  ResultChart(this.group, this.student, this.fakultet);

  List<String> docIds = [];
  // Future getDocId() async {
  //   await FirebaseFirestore.instance.collection('estimations').doc(fakultet).collection(group).doc(student).collection('${i}')
  //         .get()
  //         .then(
  //           (snapshot) => snapshot.docs.forEach((document) {
  //             print(document.reference);
  //             docIds.add(document.reference.id);
  //           }));
  // }

  Future getDocId() async {
    var semestrs = [1,2,3,4,5,6,7,8,9,10];
      for(var i = 1;i <= semestrs.length;i++) {
        await FirebaseFirestore.instance.collection('estimations').doc(fakultet)
            .collection(group).doc(student).collection('${i}')
            .get()
            .then(
                (snapshot) =>
                snapshot.docs.forEach((document) {
                  // print(document.reference);
                  docIds.add(document.reference.id);
                }));
      }
      return docIds;
  }
  // search() {
  //   var elem = [];
  //   var semestrs = [1,2,3,4,5,6,7,8,9,10];
  //   for(var i = 1;i <= semestrs.length;i++) {
  //     FirebaseFirestore.instance.collection('estimations').doc(fakultet).collection(group).doc(student).collection('${i}')
  //         .get()
  //         .then((QuerySnapshot querySnapshot) {
  //       querySnapshot.docs.forEach((doc) {
  //         // print(doc.get('Оценка'));
  //         elem.add(doc.get('Оценка'));
  //       });
  //       print(elem);
  //     });
  //   }
  //   // return arr;
  // }


  control(){
    var elem;
    final docRef = FirebaseFirestore.instance.collection('estimations').doc(fakultet).collection(group).doc(student).collection('7').doc('Биология');
    elem = docRef.snapshots().listen(
          (event) => event.get('Оценка'),
      onError: (error) => print("Listen failed: $error"),
    );
    return elem;
  }
}

