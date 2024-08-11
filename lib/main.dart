// ignore_for_file: unused_import, prefer_const_constructors

import 'package:digitalskill/admin/admindashboard/admin_dashboard.dart';
import 'package:digitalskill/user/Userdashboard/user_dashboard.dart';
import 'package:digitalskill/user/secreens/navigator.dart';
import 'package:flutter/material.dart';

import 'user/secreens/spalchSecreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      // home: UserDashboard(),
      // home: AdminDashboard(),
    );
  }
}
