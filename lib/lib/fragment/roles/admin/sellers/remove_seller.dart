import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: RemovedSellerDataTable(),
  ));
}

class RemovedSellerDataTable extends StatefulWidget {
  @override
  _RemovedSellerDataTableState createState() => _RemovedSellerDataTableState();
}

class _RemovedSellerDataTableState extends State<RemovedSellerDataTable> {
  late Stream<QuerySnapshot> _removedSellerDataStream;

  @override
  void initState() {
    super.initState();
    _removedSellerDataStream = FirebaseFirestore.instance.collection('removed_seller_data').orderBy('date_added').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Removed Seller Data Table'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _removedSellerDataStream,
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

          final List<QueryDocumentSnapshot<Object?>> documents = snapshot.data!.docs;

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
                    label: Text('Student Mobile Number'),
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
                    label: Text('Market Cost'),
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
                      DataCell(Text(data['student_mobile_number'] ?? '')),
                      DataCell(Text(data['book_name'] ?? '')),
                      DataCell(Text(data['author_name'] ?? '')),
                      DataCell(Text(data['publication'] ?? '')),
                      DataCell(Text(data['mobile_number'] ?? '')),
                      DataCell(Text(data['selling_cost'] ?? '')),
                      DataCell(Text(data['market_cost'] ?? '')),
                      DataCell(Text(data['date_added'] != null ? (data['date_added'] as Timestamp).toDate().toString() : '')),
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
