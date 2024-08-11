// ignore_for_file: prefer_const_declarations, use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';

import '../../widget/appbar.dart';
import 'resumeform.dart';

class ResumeTemplateScreen extends StatefulWidget {
  @override
  State<ResumeTemplateScreen> createState() => _ResumeTemplateScreenState();
}

class _ResumeTemplateScreenState extends State<ResumeTemplateScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final padding = 16.0;
    final fontSizeTitle = 24.0;
    final gridSpacing = 16.0;

    return Scaffold(
      appBar: CustomAppBar(title: 'Resume Create'),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose Template',
                style: TextStyle(
                    fontSize: fontSizeTitle, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: height * 0.02),
              GridView.builder(
                shrinkWrap:
                    true, // Allows GridView to take up only as much space as it needs
                physics:
                    NeverScrollableScrollPhysics(), // Prevents scrolling within GridView
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: gridSpacing,
                  mainAxisSpacing: gridSpacing,
                  childAspectRatio: (width / 4) /
                      (height / 6), // Adjust the ratio for item size
                ),
                itemCount: 6,
                itemBuilder: (context, index) {
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/CVResume.png"),
                            fit: BoxFit.cover, // Adjust the fit as needed
                          ),
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: IconButton(
                          icon: Icon(Icons.edit_outlined, size: height * 0.04),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ResumeFormScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
