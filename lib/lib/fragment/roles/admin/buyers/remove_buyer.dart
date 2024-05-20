


import 'package:booklege/lib/fragment/roles/admin/admin/admin.dart';
import 'package:flutter/material.dart';

void main() => runApp(const RemoveBuyer(name: '', mobile: '', studentId: '', email: '', password: '',));



class RemoveBuyer extends StatefulWidget {
  final String name;
  final String mobile;
  final String studentId;
  final String email;
  final String password;

  const RemoveBuyer({super.key, 
    required this.name,
    required this.mobile,
    required this.studentId,
    required this.email,
    required this.password,
  });

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Remove Buyer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      color: Colors.blueAccent,
      home: const Admin(),
    );
  }
  // ignore: library_private_types_in_public_api, annotate_overrides
  _RemoveBuyer createState() => _RemoveBuyer();
  
}

class _RemoveBuyer extends State<RemoveBuyer> {
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
       appBar: AppBar(
        title: const Text('Buyer details',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue,fontSize: 18,)),
         leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, const Admin());
            },
          ),

      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${widget.name}'),
            Text('Mobile: ${widget.mobile}'),
            Text('Student ID: ${widget.studentId}'),
            Text('Email: ${widget.email}'),
            Text('Password: ${widget.password}'),
          ],
        ),
      ),
    );
  }
}