
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../check_crazy.dart';
import '../utils/authentication_client.dart';
import 'login_page.dart';



class SplashPage extends StatefulWidget {
  SplashPage({Key? key}) : super(key: key);

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {

  final _authClient = AuthenticationClient();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      // just delay for showing this slash page clearer because it too fast
      checkSignedIn();
    });
  }

  void checkSignedIn() async {
    List<String> data;
      try {
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/my_file.txt');
        String text = await file.readAsString();
        data = text.split(' ');
        print(data);
        final User? user = await _authClient.loginUser(
          email: data[0],
          password: data[1],
        );
        print(user != null);
        if (user != null) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => NewNavigation(user),
            ),
                (route) => false,
          );
        }
      } catch (e) {
        print("Couldn't read file");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              child: ClipRRect(
                // borderRadius: BorderRadius.all(
                //     Radius.circular(110)
                // ),
                child: Image.asset(
                  "images/app_icon.png",
                  width: 100,
                  height: 100,
                  fit:BoxFit.fill,
                ),
              ),
            ),
            Container(
                padding: EdgeInsets.all(20),
                child: Text('Учебный Помощник',textAlign: TextAlign.center, style: TextStyle(color: Colors.amber,fontSize: 25,fontWeight: FontWeight.bold))
            ),
            SizedBox(height: 20),
            // Container(
            //   width: 20,
            //   height: 20,
            //   child: CircularProgressIndicator(),
            // ),
          ],
        ),
      ),
    );
  }
}
