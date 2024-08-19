// ignore_for_file: camel_case_types, prefer_const_constructors, duplicate_ignore, sort_child_properties_last, avoid_print, prefer_final_fields

import 'package:digitalskill/colors/color.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../interview/Interview_questions_screen.dart';
import '../../widget/appbar.dart';

class interviewSecreen extends StatefulWidget {
  const interviewSecreen({super.key});

  @override
  State<interviewSecreen> createState() => _interviewSecreenState();
}

class _interviewSecreenState extends State<interviewSecreen> {
  String? userEmail;
  List<Map<String, dynamic>> interviews = [];

  @override
  void initState() {
    super.initState();
    _fetchCurrentUser();
    _fetchInterviews(); // Fetch the interviews when the screen initializes
  }

  Future<void> _fetchCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    setState(() {
      userEmail = user?.email;
    });
  }

  Future<void> _fetchInterviews() async {
    try {
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('interviews')
          .get(); // Adjust the collection path as needed
      final List<Map<String, dynamic>> fetchedInterviews =
          result.docs.map((doc) {
        return {
          'title': doc['course_name'] ?? 'No Title', // Fetch the course name
          'description':
              doc['description'] ?? 'No Description', // Fetch the description
        };
      }).toList();

      setState(() {
        interviews = fetchedInterviews;
      });
    } catch (e) {
      print('Error fetching interviews: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: userEmail == 'admin@gmail.com'
          ? CustomAppBar(title: "Courses")
          : null,
      body: ListView.builder(
        itemCount: interviews.length, // Use the length of the interviews list
        itemBuilder: (context, index) {
          final interview = interviews[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade300,
                  ),
                  child: Icon(Icons.image, color: Colors.grey),
                ),
                title: Text(interview['title']),
                subtitle: Text(interview['description']),
                trailing: Text(
                    '9:41 AM'), // You can update this with actual timestamp
              ),
            ),
          );
        },
      ),
      floatingActionButton: userEmail == 'admin@gmail.com'
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => InterviewQuestionsScreen()),
                );
              },
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
              backgroundColor: AppColors.backgroundColor,
            )
          : null,
    );
  }
}
