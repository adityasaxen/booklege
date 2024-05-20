// ignore_for_file: deprecated_member_use

import 'package:booklege/lib/fragment/roles/admin/admin/admin.dart';
import 'package:booklege/lib/fragment/roles/admin/buyers/add_buyer.dart';
import 'package:booklege/lib/fragment/roles/admin/buyers/remove_buyer.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Buyer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      color: Colors.blueAccent,
      home: const Admin(),
    );
  }
}

class Buyer extends StatelessWidget {
  const Buyer(
      {super.key,
      required String name,
      required String mobile,
      required String studentId,
      required String email,
      required String password});

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
                    builder: (context) => BuyerDataTable(),
                  ),
                );
              },
              child: const Text('Add Buyer'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RemoveBuyer(
                      name: '',
                      mobile: '',
                      studentId: '',
                      email: '',
                      password: '',
                    ),
                  ),
                );
              },
              child: const Text('Remove Buyer'),
            ),
          ],
        ),
      ),
    );
  }
}
