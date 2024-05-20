import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: RemovedUserDataTable(),
  ));
}

class RemovedUserDataTable extends StatefulWidget {
  @override
  _RemovedUserDataTableState createState() => _RemovedUserDataTableState();
}

class _RemovedUserDataTableState extends State<RemovedUserDataTable> {
  late Stream<QuerySnapshot> _removedUserStream;

  @override
  void initState() {
    super.initState();
    _removedUserStream = FirebaseFirestore.instance
        .collection('removed_users')
        .orderBy('date_removed', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Removed User Data Table'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _removedUserStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 10,
                horizontalMargin: 10,
                columns: const [
                  DataColumn(label: Text('Student Id')),
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Course')),
                  DataColumn(label: Text('Semester')),
                  DataColumn(label: Text('Email')),
                  DataColumn(label: Text('Mobile Number')),
                  DataColumn(label: Text('Password')),
                  DataColumn(label: Text('Confirm Password')),
                  DataColumn(label: Text('Date Removed')),
                ],
                rows: documents.map((DocumentSnapshot document) {
                  final data = document.data() as Map<String, dynamic>;
                  return DataRow(
                    cells: [
                      DataCell(Text(data['Student Id'] ?? '')),
                      DataCell(Text(data['Name'] ?? '')),
                      DataCell(Text(data['Course'] ?? '')),
                      DataCell(Text(data['Semester'] ?? '')),
                      DataCell(Text(data['Email'] ?? '')),
                      DataCell(Text(data['Mobile Number'] ?? '')),
                      DataCell(Text(data['Password'] ?? '')),
                      DataCell(Text(data['Confirm Password'] ?? '')),
                      DataCell(Text(data['date_removed'] != null ? (data['date_removed'] as Timestamp).toDate().toString() : '')),
                    ],
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
