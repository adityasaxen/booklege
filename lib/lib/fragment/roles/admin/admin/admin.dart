// ignore_for_file: deprecated_member_use

import 'package:booklege/lib/fragment/roles/admin/admin/admin_dashboard.dart';
import 'package:booklege/lib/fragment/roles/admin/admin/new_admin.dart';
import 'package:booklege/lib/fragment/roles/admin/admin/upload_notes.dart';
import 'package:booklege/lib/fragment/roles/admin/admin/upload_pyq.dart';
import 'package:booklege/lib/fragment/roles/admin/buyers/buyer.dart';
import 'package:booklege/lib/fragment/roles/admin/otherpage/logout_admin.dart';
import 'package:booklege/lib/fragment/roles/admin/sellers/seller.dart';
import 'package:booklege/lib/fragment/roles/admin/users/user.dart';
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
class Admin extends StatelessWidget {
  const Admin({super.key});

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
              title: const Text('Dashboard',
                  style: TextStyle(fontWeight: FontWeight.normal)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminDashboardPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('User',
                  style: TextStyle(fontWeight: FontWeight.normal)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UserPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.note),
              title: const Text('Buyer',
                  style: TextStyle(fontWeight: FontWeight.normal)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Buyer(
                            name: '',
                            mobile: '',
                            email: '',
                            studentId: '',
                            password: '',
                          )),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.question_answer),
              title: const Text(
                'Seller',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Seller()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.question_answer),
              title: const Text(
                'Notes',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UploadNotes()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.question_answer),
              title: const Text(
                'PYQ',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Upload_pyq()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text(
                'Logout',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LogoutPageA()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.question_answer),
              title: const Text(
                'Admin',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddedAdminDataTable()),
                );
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text(
          'Welcome to the Admin',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
