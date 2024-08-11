// ignore_for_file: camel_case_types, prefer_const_constructors, duplicate_ignore

import 'package:flutter/material.dart';

class interviewSecreen extends StatefulWidget {
  const interviewSecreen({super.key});

  @override
  State<interviewSecreen> createState() => _interviewSecreenState();
}

class _interviewSecreenState extends State<interviewSecreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 4, // Number of notifications
        itemBuilder: (context, index) {
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
                  // ignore: prefer_const_constructors
                  child: Icon(Icons.image, color: Colors.grey),
                ),
                title: Text('Title'),
                subtitle: Text('Description'),
                trailing: Text('9:41 AM'),
              ),
            ),
          );
        },
      ),
    );
  }
}
