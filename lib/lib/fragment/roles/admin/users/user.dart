// ignore_for_file: deprecated_member_use

import 'package:booklege/lib/fragment/roles/admin/admin/admin.dart';
import 'package:booklege/lib/fragment/roles/admin/users/add_user.dart';
import 'package:booklege/lib/fragment/roles/admin/users/remove_user.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MaterialApp(
    home: UserPage(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'User',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      color: Colors.blueAccent,
      home: const Admin(),
    );
  }
}

class UserPage extends StatelessWidget {
  const UserPage({super.key});

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
                    builder: (context) => StudentDataTable(),
                  ),
                );
              },
              child: const Text('Add User'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RemovedUserDataTable(),
                  ),
                );
              },
              child: const Text('Remove User'),
            ),
          ],
        ),
      ),
    );
  }
}
