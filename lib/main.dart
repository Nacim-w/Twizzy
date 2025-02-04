import 'package:flutter/material.dart';
import 'package:twizzy/views/Register.dart';
import 'package:twizzy/views/blog.dart';
import 'package:twizzy/views/login.dart';
import 'package:twizzy/views/profile.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.white,
      ),
      home: Login(),
      routes: {
        '/login':(context)  => const Login(),
        '/register':(context) => const Register(),
        '/profile':(context) =>  ProfileScreen(),
        '/blog':(context) => BlogScreen(),
      },
    );
  }
}