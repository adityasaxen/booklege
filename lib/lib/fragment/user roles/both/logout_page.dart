
// ignore_for_file: use_super_parameters

import 'package:booklege/lib/fragment/login.dart';
import 'package:flutter/material.dart';

class LogoutPageU extends StatelessWidget {
  const LogoutPageU({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Logout for user',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
        ),
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPageU(),
                ),
                (Route<dynamic> route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              // Adjust button styling as needed
            ),
            child: const Text(
              'LogOut',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}
