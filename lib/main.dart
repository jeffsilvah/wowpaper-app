import 'package:flutter/material.dart';
import 'package:wowpaper/screens/mainScreen.dart';

import 'constants/colors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wowpaper',
      theme: ThemeData.dark().copyWith(
        primaryColor: primaryColor,
        scaffoldBackgroundColor: scaffoldColor
      ),
      home: MainScreen(),
    );
  }
}
