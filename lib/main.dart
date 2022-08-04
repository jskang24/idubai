import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Pages/dashboard.dart';
import 'Pages/categories.dart';
import 'Pages/bookmarks.dart';
import 'Pages/settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  signInAnon() async {
    bool isAlready = false;
    await FirebaseAuth.instance.signInAnonymously();
    String uname = FirebaseAuth.instance.currentUser!.uid;
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();
    final allData = await querySnapshot.docs.map((doc) => doc.data()).toList();
    for (var i in allData) {
      if ((i as Map<String, dynamic>)['uid'] == uname) {
        isAlready = true;
      }
    }
    if (isAlready == false) {
      await FirebaseFirestore.instance.collection("users").doc(uname).set({
        "uid": uname,
      });
      await FirebaseFirestore.instance
          .collection("users")
          .doc(uname)
          .collection("bookmarks")
          .doc("dummy")
          .set({});
    }
  }

  signInAnon();
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      // When navigating to the "/" route, build the FirstScreen widget.
      '/': (context) => const Dashboard(),
      // When navigating to the "/second" route, build the SecondScreen widget.
      '/second': (context) => const Bookmarks(),
      '/third': (context) => const Categories(),
      '/fourth': (context) => SettingScreen(),
    },
  ));
}
