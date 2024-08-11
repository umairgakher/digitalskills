// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_declarations, use_key_in_widget_constructors, unused_local_variable

import 'package:digitalskill/colors/color.dart';
import 'package:flutter/material.dart';

import '../../widget/appbar.dart';

class ResumeFormScreen extends StatefulWidget {
  @override
  State<ResumeFormScreen> createState() => _ResumeFormScreenState();
}

class _ResumeFormScreenState extends State<ResumeFormScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final padding = 16.0;
    final fontSizeTitle = 24.0;

    return Scaffold(
      appBar: CustomAppBar(title: 'Resume Create'),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height * 0.02),
              _buildInputField(label: 'Name'),
              SizedBox(height: height * 0.01),
              _buildInputField(label: 'Email'),
              SizedBox(height: height * 0.01),
              _buildInputField(label: 'Cover Letter', maxLines: 3),
              SizedBox(height: height * 0.01),
              _buildInputField(label: 'About', maxLines: 5),
              SizedBox(height: height * 0.02),
              Center(
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    'Download',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.backgroundColor,
                    minimumSize: Size(
                        width * 0.8, height * 0.07), // Responsive button size
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({required String label, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.black, // Black color for the title
            fontSize: 16, // Font size for the title
            fontWeight: FontWeight.bold, // Bold title
          ),
        ),
        SizedBox(height: 8), // Space between title and input field
        TextField(
          maxLines: maxLines,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[200], // Background color for the input field
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30), // Rounded corners
              borderSide: BorderSide.none, // No border line
            ),
            contentPadding: EdgeInsets.symmetric(
                vertical: 15, horizontal: 20), // Padding inside the field
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                  color: AppColors.backgroundColor), // Color when focused
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                  color: Colors.transparent), // Transparent when not focused
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide:
                  BorderSide(color: Colors.red), // Color for error state
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide:
                  BorderSide(color: Colors.red), // Color when error and focused
            ),
          ),
        ),
      ],
    );
  }
}
