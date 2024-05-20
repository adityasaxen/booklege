// ignore_for_file: unnecessary_null_comparison, use_key_in_widget_constructors, library_private_types_in_public_api, use_build_context_synchronously

import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

class UploadNotes extends StatefulWidget {
  const UploadNotes({Key? key});

  @override
  _UploadNotesState createState() => _UploadNotesState();
}

class _UploadNotesState extends State<UploadNotes> {
  String selectedCourse = 'bca'; // Default course
  int selectedSemester = 1; // Default semester
  String selectedSubject = 'C'; // Default subject
  String searchQuery = '';
  List<Map<String, dynamic>> notesData = []; // To store fetched notes
  List<Map<String, dynamic>> filteredNotesData = []; // To store filtered notes

  // Map to store subjects for each semester
  final Map<int, List<String>> semesterSubjects = {
    1: [
      'Information Technology and Application',
      'Discrete Mathematics',
      'Digital Electronics',
      'Element of System Analysis and Design',
      'C'
    ], // Subjects for Semester 1
    2: [
      'Data Structure through C',
      'Communication Skills',
      'Multimedia',
      'C++',
      'Operating System'
    ], // Subjects for Semester 2
    3: [
      'DBMS',
      'Python',
      'Computer Architecture',
      'Designing and Analysis of Algorithms',
      'Organizational Behaviour'
    ], // Subjects for Semester 3
    4: [
      'Computer Network',
      'Java',
      'Software Engineering',
      'Web Designing',
      'Computer Oriented Numerical Methods'
    ], // Subjects for Semester 4
    5: [
      'C#',
      'Flutter',
      'AI',
      'Software testing and Quality Management',
      'Computer Graphics'
    ], // Subjects for Semester 5
    6: ['E-Commerce', 'Linux and Shell Programming ', 'Cryptography and Network Security'], // Subjects for Semester 6
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Upload Notes"),
      ),
      body: Column(
        children: [
          DropdownButton<String>(
            value: selectedCourse,
            onChanged: (value) {
              setState(() {
                selectedCourse = value!;
              });
            },
            items: ['bca', 'bba', 'mba'] // Example list of courses
                .map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          DropdownButton<int>(
            value: selectedSemester,
            onChanged: (value) {
              setState(() {
                selectedSemester = value!;
                // Reset selected subject when changing semester
                selectedSubject = semesterSubjects[selectedSemester]![0];
              });
            },
            items: [1, 2, 3, 4, 5, 6] // Example list of semesters
                .map((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text('Semester $value'),
              );
            }).toList(),
          ),
          DropdownButton<String>(
            value: selectedSubject,
            onChanged: (value) {
              setState(() {
                selectedSubject = value!;
              });
            },
            items: semesterSubjects[selectedSemester]!
                .map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          ElevatedButton(
            onPressed: () async {
              final path = await FlutterDocumentPicker.openDocument();
              if (path != null) {
                File file = File(path);
                await uploadFile(file, selectedCourse, selectedSemester, selectedSubject);
                // Clear selected unit after upload
                setState(() {
                  selectedCourse = 'bca'; // Reset course
                  selectedSemester = 1; // Reset semester
                  selectedSubject = 'C'; // Reset subject
                  searchQuery = ''; // Clear search query
                });
              }
            },
            child: const Text('Upload'),
          ),
          const SizedBox(height: 10),
          TextField(
            onChanged: (value) {
              setState(() {
                searchQuery = value;
                filterNotes();
              });
            },
            decoration: const InputDecoration(
              labelText: 'Search',
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Semester')),
                  DataColumn(label: Text('Course')),
                  DataColumn(label: Text('Subject')),
                  DataColumn(label: Text('Original Name')),
                ],
                rows: filteredNotesData.map((note) {
                  return DataRow(cells: [
                    DataCell(Text(note['semester'])),
                    DataCell(Text(note['course'])),
                    DataCell(Text(note['subject'])),
                    DataCell(Text(note['originalName'])),
                  ]);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> uploadFile(File file, String course, int semester, String subject) async {
    if (file == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No file picked')),
      );
      return;
    }

    firebase_storage.UploadTask uploadTask;

    // Extract filename from the path
    String fileName = file.path.split('/').last;

    // Determine semester name based on semester number
    String semesterName = 'semester$semester';

    // Create a Reference to the file with the specified path
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('notes')
        .child(course)
        .child(semesterName)
        .child(subject) // Include the subject in the path
        .child(fileName);

    final metadata = firebase_storage.SettableMetadata(
        contentType: 'file/pdf',
        customMetadata: {'picked-file-path': file.path});

    uploadTask = ref.putData(await file.readAsBytes(), metadata);

    uploadTask.then((res) async {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('File uploaded successfully')),
      );
      // Add uploaded note to the notesData list
      setState(() {
        notesData.add({
          'semester': 'Semester $semester',
          'course': course,
          'subject': subject,
          'originalName': fileName,
        });
        filterNotes(); // Filter and update the table
      });
    }).catchError((err) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred while uploading')),
      );
    });
  }

  void filterNotes() {
    setState(() {
      filteredNotesData = notesData.where((note) => note['originalName'].toLowerCase().contains(searchQuery.toLowerCase())).toList();
    });
  }

  Future<String> constructDownloadUrl(String course, String semesterName, String subject, String fileName) async {
    final firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('notes')
        .child(course)
        .child(semesterName)
        .child(subject) // Include the subject in the path
        .child(fileName);

    // Get the full path of the file
    final fullPath = await ref.getDownloadURL();

    return fullPath;
  }

  Future<void> downloadNote(String course, String semesterName, String subject, String fileName) async {
    try {
      final downloadUrl = await constructDownloadUrl(course, semesterName, subject, fileName);
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String filePath = '${appDocDir.path}/$fileName'; // Use the provided fileName for saving

      // Download the file using the URL
      await Dio().download(downloadUrl, filePath);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Note downloaded successfully'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to download note'),
        ),
      );
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: UploadNotes(),
  ));
}
