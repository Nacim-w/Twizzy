import 'package:flutter/material.dart';
import 'package:twizzy/screens/edit_profile_screen.dart';
import 'package:twizzy/screens/register_screen.dart';
import 'package:twizzy/screens/blog_screen.dart';
import 'package:twizzy/screens/login_screen.dart';
import 'package:twizzy/screens/profile_screen.dart';

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
        '/edit_profile':(context) => EditProfileScreen(),
      },
    );
  }
}