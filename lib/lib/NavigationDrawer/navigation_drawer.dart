// ignore_for_file: deprecated_member_use

import 'package:booklege/lib/fragment/user%20roles/both/book_page.dart';
import 'package:booklege/lib/fragment/user%20roles/both/home_page.dart';
import 'package:booklege/lib/fragment/user%20roles/both/logout_page.dart';
import 'package:booklege/lib/fragment/user%20roles/both/note_page.dart';
import 'package:booklege/lib/fragment/user%20roles/both/pyq_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Drawer',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(
          headline1: TextStyle(
              color: Color(0xFF2E86C1),
              fontSize: 24,
              fontWeight: FontWeight.bold),
          bodyText1: TextStyle(color: Color(0xFF333333), fontSize: 16),
        ),
        hintColor: const Color(0xFFFF6F00),
      ),
    );
  }
}

// ignore: camel_case_types
class Navigating_page extends StatelessWidget {
  const Navigating_page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF2E86C1),
              ),
              child: Text(
                'Navigation',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home',
                  style: TextStyle(fontWeight: FontWeight.normal)),
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const Homepage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('Book',
                  style: TextStyle(fontWeight: FontWeight.normal)),
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const BookPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.note),
              title: const Text('Notes',
                  style: TextStyle(fontWeight: FontWeight.normal)),
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => NotesPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.question_answer),
              title: const Text(
                'PYQ',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const PyqPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.question_answer),
              title: const Text(
                'Logout',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LogoutPageU()));
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text(
          'Welcome to the Home Page!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
