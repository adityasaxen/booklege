
// ignore_for_file: avoid_print


import 'package:booklege/lib/fragment/user%20roles/both/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const FeedbackForm());
} 

class FeedbackForm extends StatefulWidget {
  const FeedbackForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FeedbackFormState createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  String sellerFeedback = '';
  int sellerRating = 1; // Set the initial value to the minimum value (1)

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Feedback Form',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 18,)),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Please share your feedback about the seller',labelStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 18,),
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
                    // ignore: duplicate_ignore
                    // ignore: avoid_print
                    print('Feedback: $sellerFeedback');
                    print('Rating: $sellerRating');

                    // Navigate to the thank you screen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const ThankYou()),
                    );
                  } else {
                    print('Please fill in both the feedback and rating');
                  }
                },
                child: const Text('Submit Feedback',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 18,)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ThankYou extends StatelessWidget {
  const ThankYou({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thank You',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 18,)),
      ),
      body: const Center(
        child: Text('Thank you for your feedback!',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 18,)),
      ),
      // Provide a way for the user to navigate back to the home page
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Homepage(),
          ),
        ),
        child: const Icon(Icons.home),
      ),
    );
  }
}