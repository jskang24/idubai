import 'package:flutter/material.dart';

import 'Pages/dashboard.dart';
import 'Pages/categories.dart';
import 'Pages/bookmarks.dart';
import 'Pages/details.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      // When navigating to the "/" route, build the FirstScreen widget.
      '/': (context) => const Dashboard(),
      // When navigating to the "/second" route, build the SecondScreen widget.
      '/second': (context) => const Bookmarks(),
      '/third': (context) => const Categories(),
      '/fourth': (context) => DetailPage()
    },
  ));
}
