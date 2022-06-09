import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vkr_university/utils/verify_instance.dart';

import '../check_crazy.dart';

class Chatpage extends StatefulWidget {
  final User user;
  final String idPeople;
  final String namePeople;

  Chatpage(this.user, this.idPeople, this.namePeople);
  @override
  State<Chatpage> createState() => _ChatpageState();
}

class _ChatpageState extends State<Chatpage> {

  final _formKey = GlobalKey<FormState>();
  final _contentController = TextEditingController();
  bool _isProgress = false;
  bool cher = false;



  @override
  void initState() {
    super.initState();
    getalldata();
  }

  getalldata() async {
    var documents = await FirebaseFirestore.instance
        .collection('messages')
        .where('uid', isEqualTo: '${widget.user.uid}-${widget.idPeople}')
        .get();
    if(documents.docs.isNotEmpty){
      setState(() {
        cher = true;
      });
    } else{
      setState(() {
        cher = false;
      });
    }
  }

  checker(content) {
    var contentFinish = '';
    if(content.length > 36) {
      for(var i = 0; i < 100000000000000000;i++) {
        if(content.length < 36) {
          contentFinish = '${contentFinish}${content}';
          break;
        } else {
          var copyBegin = content.substring(0,36);
          var endIndex;
          for(var i = 0; i < copyBegin.length; i++){
            if (copyBegin[i] == ' ') {
              endIndex = i;
            }
          }
          contentFinish = '${contentFinish}${content.substring(0,endIndex)}\n';
          content = content.substring(endIndex);
        }
      }
      return contentFinish;
    }
    return  content;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          appBar: AppBar(
              title: Text('${widget.namePeople}'),
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
                // List of messages
                buildListMessage(),

                // Input content
                buildInput(),
              ],
            ),
          ],
        ),
      );
  }

  Widget buildListMessage() {
    checktrue1(){
      if (widget.user.uid.compareTo(widget.idPeople) > 0) {
        return '${widget.user.uid}-${widget.idPeople}';
      } else {
        return '${widget.idPeople}-${widget.user.uid}';
      }
    }
    final Stream<QuerySnapshot> _messageStream = FirebaseFirestore.instance.collection('messages').doc(checktrue1()).collection(checktrue1()).snapshots();
    final Stream<QuerySnapshot> _streamMessage = FirebaseFirestore.instance.collection('messages').doc('${widget.idPeople}-${widget.user.uid}').collection('${widget.idPeople}-${widget.user.uid}').snapshots();

    return Flexible(
      child: StreamBuilder<QuerySnapshot>(
                      stream: _messageStream,
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        return ListView(
                          children: [
                            Padding(padding: EdgeInsets.only(top: 20)),
                            Column(
                              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

                                if(widget.user.uid == data['idFrom']){
                                  return Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.amber,
                                              // border: Border.all( color: Colors.black, width: 8),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                                            // margin: EdgeInsets.only(bottom: 5,left: 10,right: 10),
                                            margin: EdgeInsets.only(bottom: 10, right: 10),
                                            child:
                                            Text("${checker(data['Content'])}"),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 5, top: 5, bottom: 20),
                                            child:
                                            Text(
                                                "${
                                                    DateFormat('dd MMM kk:mm')
                                                        .format(DateTime.fromMillisecondsSinceEpoch(int.parse(data['timestamp'])))
                                                }",
                                              style: TextStyle(color: Colors.grey, fontSize: 12, fontStyle: FontStyle.italic),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );

                                } else{
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Column(
                                        // mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.cyan,
                                              // border: Border.all( color: Colors.black, width: 8),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            padding: EdgeInsets.all(10),
                                            margin: EdgeInsets.only(bottom: 5,left: 10,right: 10),
                                            child:
                                            Text("${checker(data['Content'])}"),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 50, top: 5, bottom: 5),
                                            child:
                                            Text(
                                                "${
                                                    DateFormat('dd MMM kk:mm')
                                                        .format(DateTime.fromMillisecondsSinceEpoch(int.parse(data['timestamp'])))
                                                }",
                                              style: TextStyle(color: Colors.grey, fontSize: 12, fontStyle: FontStyle.italic),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                }
                              }).toList(),
                            ),
                          ],
                        );
                      },
                    ),
    );
  }

  Widget buildInput() {
    CollectionReference messages = FirebaseFirestore.instance.collection('messages');
    Future<void> addMessage(idFrom,idTo,Content) {
      final Stream<QuerySnapshot> _messageStream = FirebaseFirestore.instance.collection('messages').doc('${widget.user.uid}-${widget.idPeople}').collection('${widget.user.uid}-${widget.idPeople}').snapshots();
      checktrue(){
        if (widget.user.uid.compareTo(widget.idPeople) > 0) {
          return '${widget.user.uid}-${widget.idPeople}';
        } else {
          return '${widget.idPeople}-${widget.user.uid}';
        }
      }
      return messages
          .doc(checktrue())
          .collection(checktrue())
          .doc(DateTime.now().millisecondsSinceEpoch.toString())
          .set({
        'Content': '${Content}', // John Doe
        'idTo': '${idTo}', // Stokes and Sons
        'idFrom': '${idFrom}',
        'timestamp': DateTime.now().millisecondsSinceEpoch.toString()
      })
          .then((value) => print("Message Added"))
          .catchError((error) => print("Failed to add Message: $error"));
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
                  hintText: 'Введите сообщение',
                ),
              ),
            ),
          ),

          // Button send message
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
                    addMessage(widget.user.uid,widget.idPeople, _contentController.text);
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
