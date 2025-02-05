import 'package:flutter/material.dart';
import 'package:twizzy/screens/edit_profile_screen.dart';
import 'package:twizzy/screens/register_screen.dart';
import 'package:twizzy/screens/blog_screen.dart';
import 'package:twizzy/screens/login_screen.dart';
import 'package:twizzy/screens/profile_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:twizzy/l10n/l10n.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en');

  void _changeLanguage(String languageCode) {
    setState(() {
      _locale = Locale(languageCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light().copyWith(
            scaffoldBackgroundColor: Colors.white,
          ),
          supportedLocales: L10n.all,
          locale: _locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: Login(changeLanguage: _changeLanguage),
          routes: {
            '/login': (context) => Login(changeLanguage: _changeLanguage),
            '/register': (context) => const Register(),
            '/profile': (context) => ProfileScreen(),
            '/blog': (context) => BlogScreen(),
            '/edit_profile': (context) => EditProfileScreen(),
          },
        );
      },
    );
  }
}
