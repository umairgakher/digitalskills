// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, unused_element, prefer_const_literals_to_create_immutables, unused_local_variable, unused_field

import 'package:digitalskill/user/Userdashboard/home.dart';
import 'package:digitalskill/user/Userdashboard/interview.dart';
import 'package:digitalskill/colors/color.dart';
import 'package:digitalskill/profile/profile.dart';
import 'package:flutter/material.dart';

import 'coursesSecreen.dart';

class UserDashboard extends StatefulWidget {
  UserDashboard({super.key});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openEndDrawer() {
    _scaffoldKey.currentState!.openEndDrawer();
  }

  void _closeEndDrawer(context) {
    Navigator.of(context).pop();
  }

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  int _selectedIndex = 0;
  String? text = "Courses";
  double _appBarHeight = 60;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        text = "Courses";
      }
      if (index == 1) {
        text = "Interview";
      }
      if (index == 2) {
        text = "Courses";
      }
      if (index == 3) {
        text = "Profile";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    _appBarHeight = screenHeight * 0.07;

    return Scaffold(
      key: widget._scaffoldKey,
      appBar: AppBar(
        title: Center(
          child: Text(
            text!,
            style: TextStyle(
              color: Colors.white,
              fontSize: screenHeight * 0.03,
            ),
          ),
        ),
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
                  radius: 20,
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
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.list),
              title: Text(
                "Item 1",
                style: TextStyle(fontSize: screenHeight * 0.025),
              ),
              trailing: Icon(Icons.done),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: _onItemTapped,
        items: [
          _buildBottomNavigationBarItem(Icons.home, 0),
          _buildBottomNavigationBarItem(Icons.access_time, 1),
          _buildBottomNavigationBarItem(Icons.favorite, 2),
          _buildBottomNavigationBarItem(Icons.person, 3),
        ],
      ),
      body: Container(
        child: _getPage(_selectedIndex),
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(
      IconData icon, int index) {
    return BottomNavigationBarItem(
      icon: Column(
        children: [
          Icon(icon),
          if (_selectedIndex == index)
            Container(
              margin: EdgeInsets.only(top: 4),
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
      label: '',
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        text = "Courses";
        return HomeScreen();
      case 1:
        text = "Interview";
        return InterviewScreen();
      case 2:
        text = "Courses";
        return CoursesScreen();
      case 3:
        text = "Profile";
        return Container(
          child: Text(
            "profile",
            style: TextStyle(fontSize: 20),
          ),
        );
      default:
        return Container();
    }
  }
}
