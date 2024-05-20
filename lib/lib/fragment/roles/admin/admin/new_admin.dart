import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: AddedAdminDataTable(),
  ));
}

class AddedAdminDataTable extends StatefulWidget {
  @override
  _AddedAdminDataTableState createState() => _AddedAdminDataTableState();
}

class _AddedAdminDataTableState extends State<AddedAdminDataTable> {
  late Stream<QuerySnapshot> _addedAdminDataStream;

  // Define controllers for the text fields
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController userCPassController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _addedAdminDataStream =
        FirebaseFirestore.instance.collection('Admin').snapshots();
  }

  Future<void> _addAdminData() async {
    // Get the values from the controllers
    String id = userIdController.text.trim();
    String password = userCPassController.text.trim();

    // Add admin data to Firestore
    await FirebaseFirestore.instance.collection('Admin').add({
      'studentID': id,
      'password': password,
    });

    // Show a Snackbar to indicate that the admin has been successfully added
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Admin added successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Added Admin'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Add Admin'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: userIdController,
                          decoration: InputDecoration(labelText: 'Student ID'),
                        ),
                        TextField(
                          controller: userCPassController,
                          decoration: InputDecoration(labelText: 'Password'),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          _addAdminData();
                          Navigator.of(context).pop();
                        },
                        child: Text('Add'),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _addedAdminDataStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          return DataTable(
            columns: const [
              DataColumn(label: Text('Student ID')),
              DataColumn(label: Text('Password')),
            ],
            rows: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              return DataRow(cells: [
                DataCell(Text(data['studentID'])),
                DataCell(Text(data['password'])),
              ]);
            }).toList(),
          );
        },
      ),
    );
  }
}
