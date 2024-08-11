// ignore_for_file: file_names, use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_declarations, prefer_const_constructors, sort_child_properties_last, unused_element

import 'package:digitalskill/colors/color.dart';
import 'package:digitalskill/user/courses/addcourse.dart';
import 'package:digitalskill/widget/appbar.dart';
import 'package:flutter/material.dart';

import '../courses/courses.dart';
// Import the detailed course screen

class CoursesScreenliting extends StatefulWidget {
  @override
  _CoursesScreenlitingState createState() => _CoursesScreenlitingState();
}

class _CoursesScreenlitingState extends State<CoursesScreenliting> {
  @override
  Widget build(BuildContext context) {
    // Get screen width
    final screenWidth = MediaQuery.of(context).size.width;

    // Define width and height based on screen width
    final double containerWidth = screenWidth * 0.40; // 40% of screen width
    final double containerHeight = 60.0; // Fixed height for items
    final double rowSpacing = 16.0; // Space between rows

    return Scaffold(
      appBar: CustomAppBar(title: "Courses"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Looking for something...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'FRONT-END',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              ListView.builder(
                itemCount: (getFrontEndCourses().length / 2).ceil(),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(), // Disable scrolling
                itemBuilder: (context, rowIndex) {
                  final startIndex = rowIndex * 2;
                  final endIndex =
                      (startIndex + 2).clamp(0, getFrontEndCourses().length);
                  final courses =
                      getFrontEndCourses().sublist(startIndex, endIndex);

                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: courses.map((course) {
                          return GestureDetector(
                            onTap: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CourseGuideScreen()))
                            },
                            child: Container(
                              width: containerWidth,
                              height: containerHeight,
                              padding: EdgeInsets.all(
                                  8.0), // Padding inside the container
                              decoration: BoxDecoration(
                                color: Colors.white, // Background color
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                    color: Colors.black), // Black border
                              ),
                              child: Center(
                                child: Text(
                                  course,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: rowSpacing), // Space between rows
                    ],
                  );
                },
              ),
              SizedBox(height: 16.0),
              Text(
                'BACK-END',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              ListView.builder(
                itemCount: (getBackEndCourses().length / 2).ceil(),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(), // Disable scrolling
                itemBuilder: (context, rowIndex) {
                  final startIndex = rowIndex * 2;
                  final endIndex =
                      (startIndex + 2).clamp(0, getBackEndCourses().length);
                  final courses =
                      getBackEndCourses().sublist(startIndex, endIndex);

                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: courses.map((course) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CourseGuideScreen(),
                                ),
                              );
                            },
                            child: Container(
                              width: containerWidth,
                              height: containerHeight,
                              padding: EdgeInsets.all(
                                  8.0), // Padding inside the container
                              decoration: BoxDecoration(
                                color: Colors.white, // Background color
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                    color: Colors.black), // Black border
                              ),
                              child: Center(
                                child: Text(
                                  course,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: rowSpacing), // Space between rows
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
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

  void _showAddCourseDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Course'),
          content: TextField(
            decoration: InputDecoration(hintText: 'Enter course name'),
            onChanged: (value) {
              // Handle text input
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                // Handle course addition logic here
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  List<String> getFrontEndCourses() {
    return [
      'Flutter',
      'React',
      'Next',
      'JS',
      'Block',
      'Expo',
      'Angular',
      'Svelte',
      'Vue.js'
    ];
  }

  List<String> getBackEndCourses() {
    return [
      'Node.js',
      'Django',
      'Flask',
      'Ruby on Rails',
      'Laravel',
      'Spring Boot'
    ];
  }
}
