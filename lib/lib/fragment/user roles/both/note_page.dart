// ignore_for_file: unnecessary_null_comparison, unused_local_variable

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:dio/dio.dart' show Dio, Options, Response, ResponseType;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: NotesPage(),
  ));
}

class FirebaseFile {
  final Reference ref;
  final String name;
  final String url;

  FirebaseFile({
    required this.ref,
    required this.name,
    required this.url,
  });
}

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key});

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  String selectedCourse = 'bca'; // Default course
  int selectedSemester = 1; // Default semester
  String selectedSubject = 'C'; // Default subject
  String searchQuery = '';
  List<Map<String, dynamic>> filteredPyQData = []; // To store filtered PyQ
  Map<String, String> notes = {}; // Map to store notes for each PyQ file

  final dio = Dio();
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    initializeNotifications();
  }

  void initializeNotifications() {
    var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void getPermission() async {
    print("getPermission");
    PermissionStatus status = await Permission.storage.request();
    if (status.isGranted) {
      // Permission granted, proceed with accessing storage
      String path = (await getExternalStorageDirectory())!.path;
      print("Storage directory: $path");
    } else {
      // Permission denied, handle accordingly
      print("Storage permission denied");
    }
  }

  Future<void> downloadPDF(String url, String fileName) async {
    try {
      // Construct the Firebase Storage reference path
      String firebaseStoragePath =
          'notes/$selectedCourse/semester$selectedSemester/$selectedSubject/$fileName.pdf';

      // Download the file using Dio
      Response response = await dio.get(
        url,
        onReceiveProgress: showDownloadProgress,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );

      // Get the downloads directory path
      Directory downloadsDir = Directory('/storage/emulated/0/Download');

      // Construct the full file path
      String fullPath = "${downloadsDir.path}/$fileName.pdf";

      // Write the downloaded data to the file
      File file = File(fullPath);
      await file.writeAsBytes(response.data!, flush: true);

      // Show notification
      showNotification("File Downloaded", "The file $fileName has been downloaded successfully");

      // Show snack bar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('File $fileName downloaded successfully'),
          duration: Duration(seconds: 3), // Adjust duration as needed
        ),
      );

    } catch (error) {
      // Handle exceptions
      print('Error downloading PDF: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error downloading PDF: $error'),
          duration: Duration(seconds: 3), // Adjust duration as needed
        ),
      );
    }
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
    }
  }

  Future<void> showNotification(String title, String body) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'channel_ID', // This should be a unique channel ID
      'channel_name', // This is the name of the notification channel
      // This is the description of the notification channel
      importance: Importance.max, // Importance level of the notification
      priority: Priority.high, // Priority level of the notification
      ticker: 'test', // Ticker text for the notification
    );

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'test',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Notes"),
      ),
      body: Column(
        children: [
          DropdownButton<String>(
            value: selectedCourse,
            onChanged: (value) {
              setState(() {
                selectedCourse = value!;
                fetchNotes(); // Fetch PyQ for the selected course, semester, and subject
              });
            },
            items: ['bca'] // Example list of courses
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
                selectedSubject = semesterSubjects[selectedSemester]![0]; // Reset selected subject
                fetchNotes(); // Fetch PyQ for the selected course, semester, and subject
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
                fetchNotes(); // Fetch PyQ for the selected course, semester, and subject
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
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Semester')),
                  DataColumn(label: Text('Course')),
                  DataColumn(label: Text('Subject')),
                  DataColumn(label: Text('File Name')), // Added column for file name
                  DataColumn(label: Text('Action')),
                ],
                rows: filteredPyQData.map((pyq) {
                  return DataRow(cells: [
                    DataCell(Text(pyq['semester'])),
                    DataCell(Text(pyq['course'])),
                    DataCell(Text(pyq['subject'])),
                    DataCell(Text(pyq['fileName'])), // Display file name
                    DataCell(
                      ElevatedButton(
                        onPressed: () async {
                          String pdfUrl = '${pyq['pdfUrl']}'; // Using the provided URL
                          await downloadPDF(pdfUrl, pyq['fileName']); // Download the PDF
                        },
                        child: const Text('Download PDF'),
                      ),
                    ),
                  ]);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> fetchNotes() async {
    filteredPyQData.clear(); // Clear previous PyQ
    if (selectedCourse == null || selectedSemester == null || selectedSubject == null) {
      return; // Check for null safety
    }
    try {
      final ListResult result = await FirebaseStorage.instance
          .ref('notes/$selectedCourse/semester$selectedSemester/$selectedSubject/')
          .listAll();

      List<Map<String, dynamic>> pyq = [];
      for (final ref in result.items) {
        final metadata = await ref.getMetadata();
        final fileName = metadata.name;
        pyq.add({
          'semester': 'Semester $selectedSemester',
          'course': selectedCourse,
          'subject': selectedSubject,
          'fileName': fileName, // Add the file name to the PyQ data
          'pdfUrl': await ref.getDownloadURL(), // Get download URL directly
        });
      }
      setState(() {
        filteredPyQData.addAll(pyq);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Notes fetched successfully'),
        ),
      );
    } catch (error) {
      print("Error fetching notes: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error fetching notes'),
        ),
      );
    }
  }

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
}
