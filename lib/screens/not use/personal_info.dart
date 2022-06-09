import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Import the firebase_core and cloud_firestore plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'home_page.dart';

class PersonalUserInformation extends StatefulWidget {
  final User user;

  PersonalUserInformation(this.user);

  @override
  State<PersonalUserInformation> createState() => _PersonalUserInformationState();
}

class _PersonalUserInformationState extends State<PersonalUserInformation> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('users').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: ElevatedButton(
          onPressed: (){
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) =>
                    HomePage(widget.user),
              ),
                  (route) => false,
            );
          },
          child: Text('Назад'),
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

          // checkEngine() {
          //   print('help1');
          //   snapshot.data!.docs.map((DocumentSnapshot document) {
          //     print('heeelp2');
          //     Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
          //     return 'help';
          //     print('${data['company']}');
          //     if(widget.user.uid == data['id']) {
          //       print('${data['company']}');
          //       print('yes');
          //     } else{
          //       print('${data['full_name']}');
          //       print('no');
          //     }
          //     print('check');
          //   });
          // }
          return Column(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  print('check1');
                  Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                  if(widget.user.uid == data['id']) {
                    return ListTile(
                      title: Text(data['full_name']),
                      subtitle: Text(data['company']),
                    );
                  } else{
                    return Text('no');
                  }
                }).toList(),
          );

        },
      ),
    );
  }
}