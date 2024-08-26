// ignore_for_file: file_names, use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:digitalskill/user/courses/courses.dart';

class CoursesScreen extends StatefulWidget {
  @override
  _CoursesScreenState createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  late Future<Map<String, List<Map<String, dynamic>>>> _coursesFuture;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _coursesFuture = fetchAndCategorizeCourses();
  }

  Future<Map<String, List<Map<String, dynamic>>>>
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

    List<Map<String, dynamic>> frontEndCourses = [];
    List<Map<String, dynamic>> backEndCourses = [];

    // Process Front-End courses
    for (var doc in frontEndSnapshot.docs) {
      frontEndCourses.add({
        'name': doc['name'],
        'description': doc['description'],
        'logo_image': doc['logo_image'],
        'roadmap_image': doc['roadmap_image'],
        'url': doc['url'],
        'created_at':
            doc['created_at'].toDate(), // Convert timestamp to DateTime
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
        'created_at':
            doc['created_at'].toDate(), // Convert timestamp to DateTime
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
    final double containerHeight = screenHeight * 0.08;
    final double rowSpacing = screenHeight * 0.02;

    final double fontSize = screenHeight * 0.02;
    final double borderRadius = screenHeight * 0.03;
    final double padding = screenHeight * 0.01;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: FutureBuilder<Map<String, List<Map<String, dynamic>>>>(
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
                  .where((course) => course['name']
                      .toString()
                      .toLowerCase()
                      .contains(_searchQuery.toLowerCase()))
                  .toList();
              final filteredBackEndCourses = backEndCourses
                  .where((course) => course['name']
                      .toString()
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
                      fontSize: fontSize * 1.2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: rowSpacing),
                  _buildCourseList(
                    filteredFrontEndCourses,
                    containerWidth,
                    containerHeight,
                    rowSpacing,
                    fontSize,
                    borderRadius,
                    context,
                  ),
                  SizedBox(height: rowSpacing),
                  Text(
                    'BACK-END',
                    style: TextStyle(
                      fontSize: fontSize * 1.2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: rowSpacing),
                  _buildCourseList(
                    filteredBackEndCourses,
                    containerWidth,
                    containerHeight,
                    rowSpacing,
                    fontSize,
                    borderRadius,
                    context,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCourseList(
    List<Map<String, dynamic>> courses,
    double containerWidth,
    double containerHeight,
    double rowSpacing,
    double fontSize,
    double borderRadius,
    BuildContext context,
  ) {
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
                    padding: EdgeInsets.all(fontSize * 0.5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(borderRadius),
                      border: Border.all(color: Colors.black),
                    ),
                    child: Center(
                      child: Text(
                        course['name']!,
                        style: TextStyle(
                          fontSize: fontSize,
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
