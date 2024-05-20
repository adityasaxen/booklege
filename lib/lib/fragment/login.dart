// ignore_for_file: unused_local_variable, use_build_context_synchronously, use_key_in_widget_constructors, library_private_types_in_public_api
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:booklege/lib/fragment/user%20roles/both/forgotpassword_page.dart';
import 'package:booklege/lib/fragment/user%20roles/both/home_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Login for user'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: const LoginPageU(),
      ),
    );
  }
}

class LoginPageU extends StatefulWidget {
  const LoginPageU({Key? key});

  @override
  _LoginPageContentState createState() => _LoginPageContentState();
}

class _LoginPageContentState extends State<LoginPageU> {
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
                final userId = userIdController.text.trim();
                final password = userCPassController.text.trim();

                try {
                  final QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
                      .collection('Students')
                      .where('Student Id', isEqualTo: userId)
                      .where('Confirm Password', isEqualTo: password)
                      .get();

                  if (snapshot.docs.isNotEmpty) {
                    final userData = snapshot.docs.first.data();
                    final storedPassword = userData['Confirm Password'];

                    if (storedPassword == password) {
                      // Passwords match, navigate to homepage
                      _showSnackbar(context, 'Login successful', true);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const Homepage()),
                      );
                    } else {
                      // Incorrect password, show snackbar
                      _showSnackbar(context, 'Incorrect Password', false);
                      Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ForgotPassword()),
                  );
                    }
                  } else {
                    // Student ID not found, show snackbar
                    _showSnackbar(context, 'Student ID not found', false);
                    Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ForgotPassword()),
                  );
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

  void _showSnackbar(BuildContext context, String message, bool success) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: success ? Colors.green : Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const LoginPage());
}
