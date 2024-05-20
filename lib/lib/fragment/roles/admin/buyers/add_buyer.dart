import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: BuyerDataTable(),
  ));
}

class BuyerDataTable extends StatefulWidget {
  @override
  _BuyerDataTableState createState() => _BuyerDataTableState();
}

class _BuyerDataTableState extends State<BuyerDataTable> {
  late Stream<QuerySnapshot> _BuyerDataStream;

  // Text editing controllers
  final TextEditingController _bookNameController = TextEditingController();
  final TextEditingController _buyerNameController =
      TextEditingController(); // New controller for buyer name
  final TextEditingController _buyerNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _BuyerDataStream = FirebaseFirestore.instance
        .collection('buyers')
        .orderBy('date_added', descending: true)
        .snapshots();
  }

  Future<void> _addBuyerData() async {
    final _firestore = FirebaseFirestore.instance;

    // Get the current time
    Timestamp currentTime = Timestamp.now();

    // Add buyer data to Firestore
    final buyerDocRef = await _firestore.collection('buyers').add({
      'book_name': _bookNameController.text,
      'buyer_name': _buyerNameController.text,
      'buyer_number': _buyerNumberController.text,
      'date_added': currentTime,
    });

    print('Buyer data added with ID: ${buyerDocRef.id}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buyer Data Table'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _BuyerDataStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
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
                    label: Text('Book Name'),
                  ),
                  DataColumn(
                    label: Text('Buyer Name'),
                  ),
                  DataColumn(
                    label: Text('Buyer Number'),
                  ),
                  DataColumn(
                    label: Text('Date Added'),
                  ),
                ],
                rows: documents.map((DocumentSnapshot document) {
                  final data = document.data() as Map<String, dynamic>;
                  return DataRow(
                    cells: [
                      DataCell(Text(data['book_name'] ?? '')),
                      DataCell(Text(data['buyer_name'] ?? '')),
                      DataCell(Text(data['buyer_number'] ?? '')),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _addBuyerData,
        tooltip: 'Add Buyer Data',
        child: Icon(Icons.add),
      ),
    );
  }
}
