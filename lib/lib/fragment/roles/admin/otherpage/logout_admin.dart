
// ignore_for_file: use_super_parameters, prefer_const_constructors

import 'package:booklege/lib/fragment/roles/admin/otherpage/login_admin.dart';
import 'package:flutter/material.dart';

class LogoutPageA extends StatelessWidget {
  const LogoutPageA({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Logout for admin',
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
                  builder: (context) => LoginPageA(),
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
