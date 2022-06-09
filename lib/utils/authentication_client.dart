import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/constants.dart';

class AuthenticationClient {
  final FirebaseAuth auth = FirebaseAuth.instance;
  late final FirebaseFirestore firebaseFirestore;
  late final SharedPreferences prefs;

  registerUser({
    // required String numStudent,
    required String name,
    required String email,
    required String password,
  }) async {
    User? user;

    try {
      final UserCredential userCendential =
          await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      user = userCendential.user;
      await user!.updateDisplayName(name);
      user = auth.currentUser;
    } catch (e) {
      log(e.toString());
    }

    return user;
  }

  loginUser({
    required String email,
    required String password,
  }) async {
    User? user;

    try {
      final UserCredential userCredential =
          await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      user = userCredential.user;
    } catch (e) {
      log(e.toString());
    }

    return user;
  }

  logoutUser() async {
    await auth.signOut();
  }
}
