import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AdminDashboardPage(),
    );
  }
}

class AdminDashboardPage extends StatefulWidget {
  @override
  _AdminDashboardPageState createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  int? _totalStudents;
  int? _totalBuyers;
  int? _totalSellers;
  int? _totalRemovedStudents;
  int? _totalRemovedBuyers;
  int? _totalRemovedSellers;
  int? _totalAdmins; // To store the total number of admins

  @override
  void initState() {
    super.initState();
    _fetchData();
    _subscribeToChanges();
  }

  Future<void> _fetchData() async {
    QuerySnapshot studentSnapshot =
        await FirebaseFirestore.instance.collection('Students').get();
    QuerySnapshot buyerSnapshot =
        await FirebaseFirestore.instance.collection('buyers').get();
    QuerySnapshot sellerSnapshot =
        await FirebaseFirestore.instance.collection('sellers').get();
    QuerySnapshot removedStudentSnapshot =
        await FirebaseFirestore.instance.collection('removeuser').get();

    QuerySnapshot removedBuyerSnapshot =
        await FirebaseFirestore.instance.collection('removebuyer').get();

    QuerySnapshot removedSellerSnapshot =
        await FirebaseFirestore.instance.collection('removeseller').get();

    QuerySnapshot adminSnapshot = await FirebaseFirestore.instance
        .collection('Admin')
        .get(); // Fetch admin data

    setState(() {
      _totalStudents = studentSnapshot.size;
      _totalBuyers = buyerSnapshot.size;
      _totalSellers = sellerSnapshot.size;
      _totalRemovedStudents = removedStudentSnapshot.size;
      _totalRemovedBuyers = removedBuyerSnapshot.size;
      _totalRemovedSellers = removedSellerSnapshot.size;
      _totalAdmins = adminSnapshot.size; // Assign the total number of admins
    });
  }

  void _subscribeToChanges() {
    FirebaseFirestore.instance
        .collection('Students')
        .snapshots()
        .listen((snapshot) {
      setState(() {
        _totalStudents = snapshot.size;
      });
    });

    FirebaseFirestore.instance
        .collection('buyers')
        .snapshots()
        .listen((snapshot) {
      setState(() {
        _totalBuyers = snapshot.size;
      });
    });

    FirebaseFirestore.instance
        .collection('sellers')
        .snapshots()
        .listen((snapshot) {
      setState(() {
        _totalSellers = snapshot.size;
      });
    });

    FirebaseFirestore.instance
        .collection('removeuser')
        .snapshots()
        .listen((snapshot) {
      setState(() {
        _totalRemovedStudents = snapshot.size;
      });
    });

    FirebaseFirestore.instance
        .collection('removebuyer')
        .snapshots()
        .listen((snapshot) {
      setState(() {
        _totalRemovedBuyers = snapshot.size;
      });
    });

    FirebaseFirestore.instance
        .collection('removeseller')
        .snapshots()
        .listen((snapshot) {
      setState(() {
        _totalRemovedSellers = snapshot.size;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatistic(
                title: 'Total Students Enrolled', count: _totalStudents),
            _buildStatistic(title: 'Total Buyers', count: _totalBuyers),
            _buildStatistic(title: 'Total Sellers', count: _totalSellers),
            _buildStatistic(
                title: 'Total Removed Students', count: _totalRemovedStudents),
            _buildStatistic(
                title: 'Total Removed Buyers', count: _totalRemovedBuyers),
            _buildStatistic(
                title: 'Total Removed Sellers', count: _totalRemovedSellers),
            _buildStatistic(
                title: 'Total Admins',
                count: _totalAdmins), // Display total admins
          ],
        ),
      ),
    );
  }

  Widget _buildStatistic({required String title, required int? count}) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18, // Adjust the font size as needed
          fontWeight: FontWeight.bold, // Make the text bold
        ),
      ),
      trailing: Text(
        count?.toString() ?? 'Loading...',
        style: TextStyle(
          fontSize: 18, // Adjust the font size as needed
          fontWeight: FontWeight.bold, // Make the text bold
        ),
      ),
    );
  }
}
