// ignore_for_file: prefer_const_constructors, sort_child_properties_last, use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_declarations

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalskill/colors/color.dart';
import 'package:digitalskill/user/courses/addcourse.dart';
import 'package:digitalskill/widget/appbar.dart';
import 'package:flutter/material.dart';
import '../courses/courses.dart';

class CoursesScreenliting extends StatefulWidget {
  @override
  _CoursesScreenlitingState createState() => _CoursesScreenlitingState();
}

class _CoursesScreenlitingState extends State<CoursesScreenliting> {
  late Future<Map<String, List<Map<String, String>>>> _coursesFuture;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _coursesFuture = fetchAndCategorizeCourses();
  }

  Future<Map<String, List<Map<String, String>>>>
      fetchAndCategorizeCourses() async {
    // Query for Front-End courses
    QuerySnapshot frontEndSnapshot = await FirebaseFirestore.instance
        .collection('courses')
        .where('type', isEqualTo: 'Front-End')
        .get();

    // Query for Back-End courses
    QuerySnapshot backEndSnapshot = await FirebaseFirestore.instance
        .collection('courses')
        .where('type', isEqualTo: 'Back-End')
        .get();

    List<Map<String, String>> frontEndCourses = [];
    List<Map<String, String>> backEndCourses = [];

    // Process Front-End courses
    for (var doc in frontEndSnapshot.docs) {
      frontEndCourses.add({
        'name': doc['name'],
        'description': doc['description'],
        'logo_image': doc['logo_image'],
        'roadmap_image': doc['roadmap_image'],
        'url': doc['url'],
        'created_at': (doc['created_at'] as Timestamp)
            .toDate()
            .toString(), // Convert to String
      });
    }

    // Process Back-End courses
    for (var doc in backEndSnapshot.docs) {
      backEndCourses.add({
        'name': doc['name'],
        'description': doc['description'],
        'logo_image': doc['logo_image'],
        'roadmap_image': doc['roadmap_image'],
        'url': doc['url'],
        'created_at': (doc['created_at'] as Timestamp)
            .toDate()
            .toString(), // Convert to String
      });
    }

    // Return the categorized courses
    return {
      'front-end': frontEndCourses,
      'back-end': backEndCourses,
    };
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final double containerWidth = screenWidth * 0.40;
    final double containerHeight =
        screenHeight * 0.12; // Adjust based on screen height
    final double rowSpacing =
        screenHeight * 0.02; // Adjust based on screen height
    final double fontSizeTitle =
        screenWidth * 0.05; // Adjust font size based on screen width
    final double fontSizeCourse =
        screenWidth * 0.04; // Adjust font size based on screen width
    final double borderRadius =
        screenWidth * 0.05; // Adjust border radius based on screen width

    return Scaffold(
      appBar: CustomAppBar(title: "Courses"),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(
              screenWidth * 0.04), // Adjust padding based on screen width
          child: FutureBuilder<Map<String, List<Map<String, String>>>>(
            future: _coursesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No courses available.'));
              }

              final frontEndCourses = snapshot.data!['front-end']!;
              final backEndCourses = snapshot.data!['back-end']!;

              // Filter courses based on the search query
              final filteredFrontEndCourses = frontEndCourses
                  .where((course) => course['name']!
                      .toLowerCase()
                      .contains(_searchQuery.toLowerCase()))
                  .toList();
              final filteredBackEndCourses = backEndCourses
                  .where((course) => course['name']!
                      .toLowerCase()
                      .contains(_searchQuery.toLowerCase()))
                  .toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Looking for something...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(borderRadius),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: rowSpacing),
                  Text(
                    'FRONT-END',
                    style: TextStyle(
                      fontSize: fontSizeTitle,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: rowSpacing),
                  _buildCourseList(
                      filteredFrontEndCourses,
                      containerWidth,
                      containerHeight,
                      rowSpacing,
                      fontSizeCourse,
                      borderRadius),
                  SizedBox(height: rowSpacing),
                  Text(
                    'BACK-END',
                    style: TextStyle(
                      fontSize: fontSizeTitle,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: rowSpacing),
                  _buildCourseList(
                      filteredBackEndCourses,
                      containerWidth,
                      containerHeight,
                      rowSpacing,
                      fontSizeCourse,
                      borderRadius),
                ],
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AddCourseScreen(),
            ),
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: AppColors.backgroundColor,
      ),
    );
  }

  String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  Widget _buildCourseList(
      List<Map<String, String>> courses,
      double containerWidth,
      double containerHeight,
      double rowSpacing,
      double fontSizeCourse,
      double borderRadius) {
    return ListView.builder(
      itemCount: (courses.length / 2).ceil(),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, rowIndex) {
        final startIndex = rowIndex * 2;
        final endIndex = (startIndex + 2).clamp(0, courses.length);
        final rowCourses = courses.sublist(startIndex, endIndex);

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: rowCourses.map((course) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CourseGuideScreen(
                          courseDetails: course,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: containerWidth,
                    height: containerHeight,
                    padding: EdgeInsets.all(containerWidth *
                        0.02), // Adjust padding based on container width
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(borderRadius),
                      border: Border.all(color: Colors.black),
                    ),
                    child: Center(
                      child: Text(
                        capitalize(course['name']!),
                        style: TextStyle(
                          fontSize: fontSizeCourse,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: rowSpacing),
          ],
        );
      },
    );
  }
}
