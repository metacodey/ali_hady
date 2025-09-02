import 'package:fakhama_amir_app/page/home_screen.dart';
import 'package:fakhama_amir_app/page/login_screen.dart';
import 'package:fakhama_amir_app/page/signup_screen.dart';
import 'package:fakhama_amir_app/page/splash_screen.dart';
import 'package:flutter/material.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'مجمع فخامة الأمير',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashPage(),
        '/signup': (context) => const SignUpPage(),
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}
