import 'package:booklege/lib/fragment/roles/admin/admin/admin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:booklege/lib/fragment/user%20roles/both/forgotpassword_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Login for admin'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: const LoginPageA(),
      ),
    );
  }
}

class LoginPageA extends StatefulWidget {
  const LoginPageA({Key? key});

  @override
  _LoginPageContentState createState() => _LoginPageContentState();
}

class _LoginPageContentState extends State<LoginPageA> {
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController userCPassController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: userIdController,
              decoration: const InputDecoration(labelText: 'Student ID'),
            ),
            TextField(
              controller: userCPassController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                final studentId = userIdController.text.trim();
                final password = userCPassController.text.trim();

                try {
                  final QuerySnapshot<Map<String, dynamic>> snapshot =
                      await _firestore
                          .collection('Admin')
                          .where('Student Id', isEqualTo: studentId)
                          .where('Password', isEqualTo: password)
                          .get();

                  if (snapshot.docs.isNotEmpty) {
                    final userData = snapshot.docs.first.data();
                    final storedPassword = userData['Password'];

                    if (storedPassword == password) {
                      // Navigate to main page (Admin page)
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const Admin()),
                      );
                    } else {
                      // Incorrect password, show snackbar
                      _showSnackbar(context, 'Incorrect Password');
                    }
                  }
                } catch (e) {
                  // Error occurred, navigate to forgot password page
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ForgotPassword()),
                  );
                }
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(LoginPage());
}
