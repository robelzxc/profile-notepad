import 'package:flutter/material.dart';
import 'screens/home_page.dart';

void main(){
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.cyan,
    ),
    home: const HomePage(),
  ));
}