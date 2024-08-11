// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, prefer_const_constructors

import 'package:digitalskill/profile/profile.dart';
import 'package:flutter/material.dart';

import '../colors/color.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  CustomAppBar({required this.title});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Center(
        child: Text(
          title, // Use the title parameter here
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: AppColors.backgroundColor,
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () =>
            Navigator.pop(context), // Navigates back to the previous screen
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
                radius: 20, // Adjusted radius to fit better
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
    );
  }
}
