// ignore_for_file: deprecated_member_use

import 'package:booklege/lib/fragment/login.dart';
import 'package:booklege/lib/fragment/roles/admin/otherpage/login_admin.dart';


import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Landing Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: const Color.fromARGB(255, 163, 52, 52),
        textTheme: const TextTheme(
          headline1: TextStyle(color: Color(0xFF2E86C1), fontSize: 24, fontWeight: FontWeight.bold),
          bodyText1: TextStyle(color: Color(0xFF333333), fontSize: 16),
          button: TextStyle(color: Color(0xFFFF6F00), fontSize: 20),

        ),
      ),
      home: const LandingPage(),
    );
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPageA(),
                  ),
                );
              },
              child: const Text('Login as Admin'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPageU(),
                  ),
                );
              },
              child: const Text('Login as User'),
            ),
          ],
        ),
      ),
    );
  }
}