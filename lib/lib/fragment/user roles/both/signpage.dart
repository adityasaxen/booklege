// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api


import 'package:booklege/lib/fragment/user%20roles/both/forgotpassword_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:telephony/telephony.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:booklege/lib/fragment/default%20pages/landing_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final userNameController = TextEditingController();
  final userSemesterController = TextEditingController();
  final userCourseController = TextEditingController();
  final userMobileController = TextEditingController();
  final userEmailController = TextEditingController();
  final userIdController = TextEditingController();
  final userPassController = TextEditingController();
  final userCPassController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AutovalidateMode _autoValidate = AutovalidateMode.disabled;

  late FirebaseFirestore firestore;

  @override
  void initState() {
    super.initState();
    firestore = FirebaseFirestore.instance;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Sign Up',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(15.0),
              child: Form(
                key: _formKey,
                autovalidateMode: _autoValidate,
                child: formUI(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget formUI() {
    return Column(
      children: <Widget>[
        const SizedBox(height: 10), // Added SizedBox for spacing
        TextFormField(
          controller: userIdController,
          decoration: InputDecoration(
            labelText: 'Student Id',
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          keyboardType: TextInputType.text,
          validator: validateId,
        ),
        const SizedBox(height: 10), // Added SizedBox for spacing
        TextFormField(
          controller: userNameController,
          decoration: InputDecoration(
            labelText: 'Name',
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          keyboardType: TextInputType.text,
          validator: validateName,
        ),
        const SizedBox(height: 10), // Added SizedBox for spacing
        TextFormField(
          controller: userSemesterController,
          decoration: InputDecoration(
            labelText: 'Semester',
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          keyboardType: TextInputType.text,
          validator: validateSemester,
        ),
        const SizedBox(height: 10), // Added SizedBox for spacing
        TextFormField(
          controller: userCourseController,
          decoration: InputDecoration(
            labelText: 'Course',
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          keyboardType: TextInputType.text,
          validator: validateCourse,
        ),
        const SizedBox(height: 10), // Added SizedBox for spacing
        TextFormField(
          controller: userMobileController,
          decoration: InputDecoration(
            labelText: 'Mobile Number',
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          keyboardType: TextInputType.phone,
          validator: validateMobileNumber,
        ),
        const SizedBox(height: 10), // Added SizedBox for spacing
        TextFormField(
          controller: userEmailController,
          decoration: InputDecoration(
            labelText: 'Email',
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: validateEmail,
        ),
        const SizedBox(height: 10), // Added SizedBox for spacing
        TextFormField(
          controller: userPassController,
          decoration: InputDecoration(
            labelText: 'Password',
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          keyboardType: TextInputType.text,
          obscureText: true,
          validator: validatePassword,
        ),
        const SizedBox(height: 10), // Added SizedBox for spacing
        TextFormField(
          controller: userCPassController,
          decoration: InputDecoration(
            labelText: 'Confirm Password',
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          keyboardType: TextInputType.text,
          obscureText: true,
          validator: validateConfirmPassword,
        ),
        const SizedBox(height: 20), // Added SizedBox for spacing
        GestureDetector(
          onTap: signUpUser,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 15), // Added padding for better tap detection
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Text(
                'Signup',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20), // Added SizedBox for spacing
      ],
    );
  }

  void signUpUser() {
    if (_formKey.currentState!.validate()) {
      Map<String, String> students = {
        'Student Id': userIdController.text,
        'Name': userNameController.text,
        'Course': userCourseController.text,
        'Semester': userSemesterController.text,
        'Email': userEmailController.text,
        'Mobile Number': userMobileController.text,
        'Password': userPassController.text,
        'Confirm Password': userCPassController.text,
        'Islogin': 'true',
      };

      // Send welcome SMS to the user
      sendWelcomeSMS(userMobileController.text);

      firestore.collection('Students').add(students).then((_) {
        showToast("User added successfully in Firestore");
        // Check if signup is successful
        Navigator.pop(context); // Pop the signup page
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LandingPage())); // Navigate to login page
      }).catchError((error) {
        showToast("Error in adding $error");
        // Go to forgot password page on error
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  ForgotPassword()));
      });
    }
  }

  void sendWelcomeSMS(String mobileNumber) async {
    final Telephony telephony = Telephony.instance;

    bool? permissionsGranted = await telephony.requestPhoneAndSmsPermissions;
    if (!permissionsGranted!) {
      // Handle the case where permissions are not granted
      return;
    }

    telephony.sendSms(
      to: mobileNumber,
      message: "Welcome to Booklege! Thank you for choosing us!",
      statusListener: (SendStatus status) {
        // Handle the status
        switch (status) {
          case SendStatus.SENT:
            showToast("SMS sent successfully");
            break;
          case SendStatus.DELIVERED:
            showToast("SMS delivered successfully");
            break;
          // Handle other status if needed
        }
      },
    );
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: const Color.fromARGB(255, 232, 229, 227),
      fontSize: 16.0,
    );
  }

  String? validateId(String? value) {
    if (value == null || value.isEmpty) {
      return 'Student ID cannot be empty';
    }
    if (value.length > 6) {
      return 'Should be less than 6 digits';
    }
    return null;
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name cannot be empty';
    }
    if (value.length < 3) {
      return 'Name must be more than 2 characters';
    }
    return null;
  }

  String? validateSemester(String? value) {
    if (value == null || value.isEmpty) {
      return 'Semester cannot be empty';
    }
    return null;
  }

  String? validateCourse(String? value) {
    if (value == null || value.isEmpty) {
      return 'Course cannot be empty';
    }
    return null;
  }

  String? validateMobileNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mobile number cannot be empty';
    }
    if (value.length != 10) {
      return 'Mobile number must be 10 digits';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty';
    }
    if (!value.contains('@') || !value.contains('.')) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm Password cannot be empty';
    }
    if (value != userPassController.text) {
      return 'Passwords do not match';
    }
    return null;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SignInPage(),
    );
  }
}
