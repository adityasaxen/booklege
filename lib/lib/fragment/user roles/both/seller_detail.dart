// ignore_for_file: unused_import, unused_field, equal_keys_in_map

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: SafeArea(
      child: SellerPage(),
    ),
  ));
}

class SellerPage extends StatefulWidget {
  @override
  _SellerPageState createState() => _SellerPageState();
}

class _SellerPageState extends State<SellerPage> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController publisherController = TextEditingController();
  final TextEditingController userMobileController = TextEditingController();
  final TextEditingController realCostController = TextEditingController();
  final TextEditingController sellingCostController = TextEditingController();
  final TextEditingController courseController = TextEditingController();
  String selectedCourse = 'bca';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final firebase_storage.FirebaseStorage _storage =
      firebase_storage.FirebaseStorage.instance;

  // Options for semester dropdown
  final List<String> semesters = [
    'Semester 1',
    'Semester 2',
    'Semester 3',
    'Semester 4',
    'Semester 5',
    'Semester 6'
  ];

  // Subjects for each semester
  final Map<String, List<String>> semesterSubjects = {
    'Semester 1': [
      'Information Technology and Application',
      'Discrete Mathematics',
      'Digital Electronics',
      'Element of System Analysis and Design',
      'C'
    ],
    'Semester 2': [
      'Data Structure through C',
      'Communication Skills',
      'Multimedia',
      'C++',
      'Operating System'
    ],
    'Semester 3': [
      'DBMS',
      'Python',
      'Computer Architecture',
      'Designing and Analysis of Algorithms',
      'Organizational Behaviour'
    ],
    'Semester 4': [
      'Computer Network',
      'Java',
      'Software Engineering',
      'Web Designing',
      'Computer Oriented Numerical Methods'
    ],
    'Semester 5': [
      'C#',
      'Flutter',
      'AI',
      'Software testing and Quality Management',
      'Computer Graphics'
    ],
    'Semester 6': [
      'E-Commerce',
      'Linux and Shell Programming ',
      'Cryptography and Network Security'
    ],
  };

  Map<String, String> selectedFilePaths = {};
  String? imageUrl;
  final _formKey = GlobalKey<FormState>();

  String selectedSemester =
      'Semester 1'; // Add this line to track selected semester

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seller Page'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: userNameController,
                  decoration: const InputDecoration(labelText: 'Seller Name'),
                  validator: validateName,
                ),
                TextFormField(
                  controller: userIdController,
                  decoration: const InputDecoration(labelText: 'Student ID'),
                  validator: validateId,
                ),
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Book Name'),
                  validator: (value) =>
                      value!.isEmpty ? 'Book name cannot be empty' : null,
                ),
                TextFormField(
                  controller: authorController,
                  decoration: const InputDecoration(labelText: 'Author Name'),
                  validator: (value) =>
                      value!.isEmpty ? 'Author name cannot be empty' : null,
                ),
                TextFormField(
                  controller: publisherController,
                  decoration: const InputDecoration(labelText: 'Publication'),
                  validator: (value) =>
                      value!.isEmpty ? 'Publication cannot be empty' : null,
                ),
                TextFormField(
                  controller: userMobileController,
                  decoration: const InputDecoration(labelText: 'Mobile Number'),
                  validator: validateMobileNumber,
                ),
                TextFormField(
                  controller: sellingCostController,
                  decoration: const InputDecoration(labelText: 'Selling Cost'),
                  validator: (value) =>
                      value!.isEmpty ? 'Selling cost cannot be empty' : null,
                ),
                TextFormField(
                  controller: realCostController,
                  decoration: const InputDecoration(labelText: 'Original Cost'),
                  validator: (value) =>
                      value!.isEmpty ? 'Original cost cannot be empty' : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField(
                  value: selectedSemester, // Use selectedSemester here
                  items: semesters.map((semester) {
                    return DropdownMenuItem(
                      value: semester,
                      child: Text(semester),
                    );
                  }).toList(),
                  onChanged: (selectedSemester) {
                    setState(() {
                      this.selectedSemester = selectedSemester
                          .toString(); // Update selected semester
                    });
                  },
                  decoration: InputDecoration(labelText: 'Select Semester'),
                  validator: validateSemester,
                ),
                const SizedBox(height: 16),
                // Dropdown for subjects
                DropdownButtonFormField(
                  value: semesterSubjects[selectedSemester]!.first,
                  items: semesterSubjects[selectedSemester]!.map((subject) {
                    return DropdownMenuItem(
                      value: subject,
                      child: Text(subject),
                    );
                  }).toList(),
                  onChanged: (selectedSubject) {
                    // Do something with selected subject
                  },
                  decoration:
                      InputDecoration(labelText: 'Select Subject for Semester'),
                ),
                const SizedBox(height: 16),
                // Dropdown for courses
                DropdownButtonFormField<String>(
                  value: selectedCourse,
                  onChanged: (value) {
                    setState(() {
                      selectedCourse = value!;
                    });
                  },
                  items: ['bca', 'bba'] // Example list of courses
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: InputDecoration(labelText: 'Select Course'),
                  validator: validateCourse,
                ),
                const SizedBox(height: 16),
                // Text field to display selected file
                TextFormField(
                  controller: TextEditingController(
                      text: selectedFilePaths.isNotEmpty
                          ? selectedFilePaths.values.first ?? ''
                          : ''),
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Selected File',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          selectedFilePaths.clear();
                        });
                      },
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_validateForm()) {
                      _submitForm(context);
                    }
                  },
                  child: const Text('Submit'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _openFileExplorer();
                  },
                  child: const Text('Upload Book Pages'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _captureImage();
                  },
                  child: const Text('Capture Image'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _validateForm() {
    final FormState? form = _formKey.currentState;
    if (form!.validate()) {
      return true;
    } else {
      return false;
    }
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

  void _submitForm(BuildContext context) async {
    try {
      // Get current date/time
      final currentTime = DateTime.now();

      // Save seller form data to Firestore with date/time
      final sellerDocRef = await _firestore.collection('sellers').add({
        'seller_name': userNameController.text,
        'student_id': userIdController.text,
        'book_name': titleController.text,
        'author_name': authorController.text,
        'publication': publisherController.text,
        'mobile_number': userMobileController.text,
        'selling_cost': sellingCostController.text,
        'course': selectedCourse,
        'semester': selectedSemester, // Add semester field
        'subject':
            semesterSubjects[selectedSemester]!.first, // Add subject field
        'date_added': currentTime, // Add date/time field
      });

      // Upload image to Firebase Storage if selected
      if (imageUrl != null) {
        final firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('books')
            .child(selectedCourse)
            .child(selectedSemester)
            .child(semesterSubjects[selectedSemester]!.first)
            .child(DateTime.now().millisecondsSinceEpoch.toString() + '.jpg');

        // No need to upload the image again, as we already have its URL
        // Get download URL of the uploaded photo
        final imageUrl = await ref.getDownloadURL();

        // Update Firestore document with photo URL
        await sellerDocRef.update({'photo_url': imageUrl});
      }

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Form submitted successfully!')),
      );

      // Clear form fields after submission
      _clearFormFields();
    } catch (error) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting form: $error')),
      );
    }
  }

  void _clearFormFields() {
    userNameController.clear();
    userIdController.clear();
    titleController.clear();
    authorController.clear();
    publisherController.clear();
    userMobileController.clear();
    sellingCostController.clear();
    realCostController.clear();
    courseController.clear();
    setState(() {
      selectedFilePaths.clear();
    });
  }

  void _openFileExplorer() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'png',
          'jpeg'
        ], // Add any additional extensions you want to allow
      );
      if (result != null) {
        PlatformFile file = result.files.first;
        String fileName =
            DateTime.now().millisecondsSinceEpoch.toString() + '_' + file.name!;
        Reference ref = FirebaseStorage.instance
            .ref()
            .child('books')
            .child(selectedCourse)
            .child(selectedSemester)
            .child(semesterSubjects[selectedSemester]!.first)
            .child(fileName);
        await ref.putFile(File(file.path!));
        String imageUrl = await ref.getDownloadURL();
        setState(() {
          selectedFilePaths[file.path!] = file.name;
          imageUrl = imageUrl;
        });
      }
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
  }

  void _captureImage() async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? file = await imagePicker.pickImage(source: ImageSource.camera);
    print('${file?.path}');

    if (file == null) return;

    String uniqueFileName =
        DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('books')
        .child(selectedCourse)
        .child(selectedSemester)
        .child(semesterSubjects[selectedSemester]!.first)
        .child(uniqueFileName);

    try {
      await ref.putFile(File(file.path));
      String imageUrl = await ref.getDownloadURL();
      setState(() {
        selectedFilePaths.clear();
        selectedFilePaths['name'] = uniqueFileName;
        imageUrl = imageUrl; // Update the imageUrl variable
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image captured successfully!')),
      );
    } catch (error) {
      print('Error uploading image: $error');
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error capturing image: $error')),
      );
    }
  }
}
