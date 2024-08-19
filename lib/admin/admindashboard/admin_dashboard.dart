// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, use_key_in_widget_constructors, unused_import

import 'package:digitalskill/colors/color.dart';
import 'package:digitalskill/interview/Interview_questions_screen.dart';
import 'package:digitalskill/profile/profile.dart';
import 'package:digitalskill/user/courses/courseslist.dart';
import 'package:digitalskill/user/resume/addresume.dart';
import 'package:flutter/material.dart';

import '../../user/Userdashboard/interview.dart';
import '../../user/resume/updateresume.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;

    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          "Dashboard",
          style: TextStyle(color: Colors.white),
        )),
        backgroundColor: AppColors.backgroundColor,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.menu),
          color: Colors.white,
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        actions: [
          IconButton(
            icon: Container(
              width: 50,
              alignment: Alignment.topLeft,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 20,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildDashboardItem(
                title: '',
                screenHeight: screenHeight,
                height: screenHeight * 0.25, // 25% of screen height
                backgroundImage: AssetImage('assets/images/onlineCourse.jpg'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CoursesScreenliting()),
                  );
                },
              ),
              SizedBox(height: 16.0), // Spacing between items
              _buildDashboardItem(
                title: 'CV/Resume',
                height: screenHeight * 0.25, // 25% of screen height
                screenHeight: screenHeight,
                backgroundImage: AssetImage('assets/images/resume.jpg'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ResumeListScreen()),
                  );
                },
              ),
              SizedBox(height: 16.0), // Spacing between items
              _buildDashboardItem(
                title: 'Interview Questions & Answers',
                height: screenHeight * 0.25, // 25% of screen height
                screenHeight: screenHeight,
                backgroundImage: AssetImage('assets/images/interveiw.png'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => interviewSecreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardItem({
    required String title,
    required double height,
    required ImageProvider backgroundImage,
    required VoidCallback onTap,
    required double screenHeight,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: backgroundImage,
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: screenHeight * 0.04,
              fontWeight: FontWeight.bold,
              color: AppColors
                  .backgroundColor, // Ensure text is visible on the background
            ),
          ),
        ),
      ),
    );
  }
}

// Placeholder screens for navigation

class InterviewQA extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Interview Questions & Answers')),
      body: Center(child: Text('Interview Questions & Answers Screen')),
    );
  }
}
