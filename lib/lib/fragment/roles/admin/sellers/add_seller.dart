import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: AddedSellerDataTable(),
  ));
}

class AddedSellerDataTable extends StatefulWidget {
  @override
  _AddedSellerDataTableState createState() => _AddedSellerDataTableState();
}

class _AddedSellerDataTableState extends State<AddedSellerDataTable> {
  late Stream<QuerySnapshot> _addedSellerDataStream;

  @override
  void initState() {
    super.initState();
    _addedSellerDataStream = FirebaseFirestore.instance
        .collection('sellers')
        .orderBy('date_added', descending: true)
        .snapshots();
  }

  Future<void> _addSellerData() async {
    final _firestore = FirebaseFirestore.instance;

    // Add your text editing controllers
    TextEditingController userNameController = TextEditingController();
    TextEditingController userIdController = TextEditingController();
    TextEditingController titleController = TextEditingController();
    TextEditingController authorController = TextEditingController();
    TextEditingController publisherController = TextEditingController();
    TextEditingController userMobileController = TextEditingController();
    TextEditingController sellingCostController = TextEditingController();
    TextEditingController courseController = TextEditingController();

    // Get the current time
    Timestamp currentTime = Timestamp.now();

    // Add seller data to Firestore
    final sellerDocRef = await _firestore.collection('sellers').add({
      'seller_name': userNameController.text,
      'student_id': userIdController.text,
      'book_name': titleController.text,
      'author_name': authorController.text,
      'publication': publisherController.text,
      'mobile_number': userMobileController.text,
      'selling_cost': sellingCostController.text,
      'semester': 'First', // Add semester field
      'course': courseController.text, // Add course field
      'date_added': currentTime, // Add date/time field
    });

    print('Seller data added with ID: ${sellerDocRef.id}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Added Seller Data Table'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            onPressed: _addSellerData,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _addedSellerDataStream,
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

          final List<QueryDocumentSnapshot<Object?>> documents =
              snapshot.data!.docs;

          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 10,
                horizontalMargin: 10,
                columns: const [
                  DataColumn(
                    label: Text('Seller Name'),
                  ),
                  DataColumn(
                    label: Text('Student ID'),
                  ),
                  DataColumn(
                    label: Text('Book Name'),
                  ),
                  DataColumn(
                    label: Text('Author Name'),
                  ),
                  DataColumn(
                    label: Text('Publication'),
                  ),
                  DataColumn(
                    label: Text('Mobile Number'),
                  ),
                  DataColumn(
                    label: Text('Selling Cost'),
                  ),
                  DataColumn(
                    label: Text('Semester'),
                  ),
                  DataColumn(
                    label: Text('Course'),
                  ),
                  DataColumn(
                    label: Text('Date Added'),
                  ),
                ],
                rows: documents.map((DocumentSnapshot document) {
                  final data = document.data() as Map<String, dynamic>;
                  return DataRow(
                    cells: [
                      DataCell(Text(data['seller_name'] ?? '')),
                      DataCell(Text(data['student_id'] ?? '')),
                      DataCell(Text(data['book_name'] ?? '')),
                      DataCell(Text(data['author_name'] ?? '')),
                      DataCell(Text(data['publication'] ?? '')),
                      DataCell(Text(data['mobile_number'] ?? '')),
                      DataCell(Text(data['selling_cost'] ?? '')),
                      DataCell(Text(data['semester'] ?? '')),
                      DataCell(Text(data['course'] ?? '')),
                      DataCell(Text(data['date_added'] != null
                          ? (data['date_added'] as Timestamp)
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
