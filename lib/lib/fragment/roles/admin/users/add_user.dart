import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: StudentDataTable(),
  ));
}

class StudentDataTable extends StatefulWidget {
  @override
  _StudentDataTableState createState() => _StudentDataTableState();
}

class _StudentDataTableState extends State<StudentDataTable> {
  late Stream<QuerySnapshot> _studentDataStream;

  final TextEditingController userIdController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController userCourseController = TextEditingController();
  final TextEditingController userSemesterController = TextEditingController();
  final TextEditingController userEmailController = TextEditingController();
  final TextEditingController userMobileController = TextEditingController();
  final TextEditingController userPassController = TextEditingController();
  final TextEditingController userCPassController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _studentDataStream = FirebaseFirestore.instance
        .collection('Students')
        .orderBy('Date Added', descending: true)
        .snapshots();
  }

  Future<void> _addStudentData() async {
    final _firestore = FirebaseFirestore.instance;

    // Get the current time
    Timestamp currentTime = Timestamp.now();

    // Add user data to Firestore
    final studentDocRef = await _firestore.collection('Students').add({
      'Student Id': userIdController.text,
      'Name': userNameController.text,
      'Course': userCourseController.text,
      'Semester': userSemesterController.text,
      'Email': userEmailController.text,
      'Mobile Number': userMobileController.text,
      'Password': userPassController.text,
      'Confirm Password': userCPassController.text,
      'Islogin':
          true, // Assuming you want to store boolean value for login status
      'Date Added': currentTime, // Add the current date and time
    });

    print('Student data added with ID: ${studentDocRef.id}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Data Table'),
        actions: [
          IconButton(
            onPressed: _addStudentData,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _studentDataStream,
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
                  DataColumn(label: Text('Student ID')),
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Course')),
                  DataColumn(label: Text('Semester')),
                  DataColumn(label: Text('Email')),
                  DataColumn(label: Text('Mobile Number')),
                  DataColumn(label: Text('Password')),
                  DataColumn(label: Text('Confirm Password')),
                  DataColumn(label: Text('Is Login')),
                  DataColumn(label: Text('Date Added')),
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
                      DataCell(Text(data['Islogin'] != null
                          ? data['Islogin'].toString()
                          : '')),
                      DataCell(Text(data['Date Added'] != null
                          ? (data['Date Added'] as Timestamp)
                              .toDate()
                              .toString()
                          : '')),
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
