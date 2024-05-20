// ignore_for_file: deprecated_member_use




import 'package:booklege/lib/fragment/roles/admin/admin/admin.dart';
import 'package:booklege/lib/fragment/roles/admin/sellers/add_seller.dart';
import 'package:booklege/lib/fragment/roles/admin/sellers/remove_seller.dart';
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
      title: 'Seller',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        
      ),
      color: Colors.blueAccent,
      home: const Admin(),
    );
  }
}

class Seller extends StatelessWidget {
  const Seller({super.key});

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
                    builder: (context) => AddedSellerDataTable())
                );
              },
              child: const Text('Add Seller'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RemovedSellerDataTable())
                );
              },
              child: const Text('Remove Seller'),
            ),
          ],
        ),
      ),
    );
  }
}