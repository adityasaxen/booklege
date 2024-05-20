// ignore_for_file: non_constant_identifier_names, use_key_in_widget_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
 // Assuming LandingPage is imported correctly

void main() {
  runApp(ForgotPassword());
}

class ForgotPassword extends StatelessWidget {
  final TextEditingController userEmailController = TextEditingController();
  forgotpassword(String Email) async{
    if(Email==''){
      return const AlertDialog(title:Text('Error'),content: Text("Please Enter Your Email"));
    }
    else{
      FirebaseAuth.instance.sendPasswordResetEmail(email: Email);

    }
  }
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: userEmailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
           
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Navigate back to previous page
                  },
                  child: const Text('Back'),
                ),
                ElevatedButton(
                  onPressed: () {
                    forgotpassword(userEmailController.text.toString());
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}