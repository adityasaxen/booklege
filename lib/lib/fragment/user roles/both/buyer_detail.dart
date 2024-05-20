import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(BuyerPage());
}

class BuyerPage extends StatefulWidget {
  @override
  _BuyerPageState createState() => _BuyerPageState();
}

class _BuyerPageState extends State<BuyerPage> {
  final TextEditingController _bookNameController = TextEditingController();
  final TextEditingController _buyerNameController = TextEditingController();
  final TextEditingController _buyerNumberController = TextEditingController();
  List<SellerDetails> sellersDetails = [];

  Future<void> fetchSellers(
      String bookName, String buyerName, String buyerNumber) async {
    final currentTime = Timestamp.now();

    final sellers = await FirebaseFirestore.instance
        .collection('sellers')
        .where('book_name', isEqualTo: bookName) // Match book name
        .get();

    // Check if any sellers with the specified book name exist
    if (sellers.docs.isEmpty) {
      // Handle case when no sellers with the specified book name are found
      // For example, display an error message to the user
      print('No sellers found for the book: $bookName');
      return;
    }

    await FirebaseFirestore.instance.collection('buyers').add({
      'book_name': bookName,
      'buyer_name': buyerName,
      'buyer_number': buyerNumber,
      'date_added': currentTime,
    });

    setState(() {
      sellersDetails.clear();
      sellers.docs.forEach((seller) {
        sellersDetails.add(SellerDetails.fromMap(seller.id, seller.data()));
      });
    });
  }

  void _showFeedbackForm(BuildContext context, SellerDetails seller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Feedback Form'),
          content: FeedbackForm(
            onFeedbackSubmitted: (feedback, rating) {
              _submitFeedback(seller, feedback, rating);
              Navigator.pop(context); // Close the feedback form dialog
            },
          ),
        );
      },
    );
  }

  Future<void> _submitFeedback(
      SellerDetails seller, String feedback, int rating) async {
    try {
      // Update the seller document in Firestore
      await FirebaseFirestore.instance
          .collection('sellers')
          .doc(seller.id) // Use the seller's document ID to update the feedback
          .update({
        'feedback': feedback,
        'rating': rating,
      });

      // Show a message to indicate that the feedback was submitted successfully
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Feedback submitted successfully'),
      ));

      // Optionally, update the local sellersDetails list if needed
      // For example:
      setState(() {
        // Find the index of the seller in the list
        int index = sellersDetails.indexWhere((s) => s.id == seller.id);
        if (index != -1) {
          // Update the feedback and rating in the local list
          sellersDetails[index] = SellerDetails(
            id: seller.id,
            sellerName: seller.sellerName,
            bookName: seller.bookName,
            authorName: seller.authorName,
            publication: seller.publication,
            sellingCost: seller.sellingCost,
            mobileNumber: seller.mobileNumber,
            semester: seller.semester,
            course: seller.course,
            dateAdded: seller.dateAdded,
            feedback: feedback, // Add feedback to the SellerDetails object
            rating: rating,     // Add rating to the SellerDetails object
          );
        }
      });
    } catch (e) {
      print('Error updating feedback: $e');
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buyer Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _bookNameController,
              decoration: InputDecoration(labelText: 'Book Name'),
            ),
            TextFormField(
              controller: _buyerNameController,
              decoration: InputDecoration(labelText: 'Buyer Name'),
            ),
            TextFormField(
              controller: _buyerNumberController,
              decoration: InputDecoration(labelText: 'Buyer Number'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                await fetchSellers(
                  _bookNameController.text.trim(),
                  _buyerNameController.text.trim(),
                  _buyerNumberController.text.trim(),
                );
              },
              child: Text('Fetch Sellers'),
            ),
            SizedBox(height: 16.0),
            Text(
              'List of Sellers:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Seller Name')),
                      DataColumn(label: Text('Book Name')),
                      DataColumn(label: Text('Author Name')),
                      DataColumn(label: Text('Publication')),
                      DataColumn(label: Text('Selling Cost')),
                      DataColumn(label: Text('Mobile Number')),
                      DataColumn(label: Text('Semester')),
                      DataColumn(label: Text('Course')),
                      DataColumn(label: Text('Date Added')),
                      DataColumn(label: Text('Feedback Form')), // Added feedback button column
                    ],
                    rows: sellersDetails.map((seller) {
                      return DataRow(cells: [
                        DataCell(Text(seller.sellerName)),
                        DataCell(Text(seller.bookName)),
                        DataCell(Text(seller.authorName)),
                        DataCell(Text(seller.publication)),
                        DataCell(Text(seller.sellingCost)),
                        DataCell(Text(seller.mobileNumber)),
                        DataCell(Text(seller.semester)),
                        DataCell(Text(seller.course)),
                        DataCell(Text(seller.dateAdded.toString())),
                        DataCell(
                          ElevatedButton(
                            onPressed: () {
                              _showFeedbackForm(context, seller);
                            },
                            child: Text('Give Feedback'),
                          ),
                        ),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SellerDetails {
  final String id;
  final String sellerName;
  final String bookName;
  final String authorName;
  final String publication;
  final String sellingCost;
  final String mobileNumber;
  final String semester;
  final String course;
  final DateTime dateAdded;
  final String feedback; // New field to store feedback
  final int rating;      // New field to store rating

  SellerDetails({
    required this.id,
    required this.sellerName,
    required this.bookName,
    required this.authorName,
    required this.publication,
    required this.sellingCost,
    required this.mobileNumber,
    required this.semester,
    required this.course,
    required this.dateAdded,
    required this.feedback,
    required this.rating,
  });

  factory SellerDetails.fromMap(String id, Map<String, dynamic> map) {
    return SellerDetails(
      id: id,
      sellerName: map['seller_name'] ?? '',
      bookName: map['book_name'] ?? '',
      authorName: map['author_name'] ?? '',
      publication: map['publication'] ?? '',
      sellingCost: (map['selling_cost'] ?? ''),
      mobileNumber: map['mobile_number'] ?? '',
      semester: map['semester'] ?? '',
      course: map['course'] ?? '',
      dateAdded: (map['date_added'] as Timestamp).toDate(),
      feedback: map['feedback'] ?? '', // Initialize feedback from Firestore
      rating: map['rating'] ?? 0,      // Initialize rating from Firestore
    );
  }
}

class FeedbackForm extends StatefulWidget {
  final Function(String, int) onFeedbackSubmitted;

  const FeedbackForm({Key? key, required this.onFeedbackSubmitted})
      : super(key: key);

  @override
  _FeedbackFormState createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  String sellerFeedback = '';
  int sellerRating = 1; // Set the initial value to the minimum value (1)

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: <Widget>[
          TextFormField(
            maxLines: 5,
            decoration: const InputDecoration(
              labelText: 'Please share your feedback about the seller',
            ),
            onChanged: (value) {
              setState(() {
                sellerFeedback = value;
              });
            },
          ),
          Slider(
            min: 1,
            max: 5,
            divisions: 4,
            value: sellerRating.toDouble(),
            onChanged: (double value) {
              setState(() {
                sellerRating = value.round();
              });
            },
          ),
          Text('Your rating: $sellerRating'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (sellerFeedback.isNotEmpty && sellerRating > 0) {
                widget.onFeedbackSubmitted(sellerFeedback, sellerRating);
              } else {
                print('Please fill in both the feedback and rating');
              }
            },
            child: const Text('Submit Feedback'),
          ),
        ],
      ),
    );
  }
}
