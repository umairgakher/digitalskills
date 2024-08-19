// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, sort_child_properties_last

import 'package:digitalskill/colors/color.dart';
import 'package:flutter/material.dart';
import '../courses/courses.dart';
import '../resume/resumetamplate.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> courses = [
    'Flutter',
    'Python',
    'React JS',
    'Blockchain',
    'Node.js',
  ];

  final List<Map<String, dynamic>> items = [
    {
      'buttonText': 'Button 1',
      'backgroundImage': 'assets/images/cardbackground.jpg',
    },
    {
      'buttonText': 'Button 2',
      'backgroundImage': 'assets/images/cardbackground.jpg',
    },
    {
      'buttonText': 'Button 3',
      'backgroundImage': 'assets/images/background3.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(screenWidth * 0.05), // 5% of screen width
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: screenHeight * 0.06,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Looking for something...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'TOP COURSES',
                    style: TextStyle(
                      fontSize: screenHeight * 0.025,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.01),
              Row(
                children: courses
                    .take(3)
                    .map((course) => Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.01),
                            child: GestureDetector(
                              onTap: () => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CourseGuideScreen(),
                                  ),
                                )
                              },
                              child: Container(
                                padding: EdgeInsets.all(screenWidth * 0.02),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Center(
                                  child: Text(
                                    course,
                                    style: TextStyle(
                                      fontSize: screenHeight * 0.018,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
              SizedBox(height: screenHeight * 0.02),
              Row(
                children: items
                    .take(2)
                    .map((item) => Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.01),
                            child: Container(
                              padding: EdgeInsets.all(screenWidth * 0.05),
                              height: screenHeight * 0.25,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(item['backgroundImage']),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Icon(Icons.favorite_border,
                                        color: Colors.white),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            AppColors.backgroundColor,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CourseGuideScreen(),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        item['buttonText'],
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
              SizedBox(height: screenHeight * 0.02),
              Text(
                'Create your Professional Resume',
                style: TextStyle(
                  fontSize: screenHeight * 0.025,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Container(
                width: screenWidth,
                height: screenHeight * 0.25,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/cardbackground.jpg'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResumeTemplateScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Create',
                        style: TextStyle(
                          fontSize: screenHeight * 0.02,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.backgroundColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
