// ignore_for_file: unused_local_variable, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, prefer_const_declarations, avoid_print, prefer_const_constructors, use_build_context_synchronously

import 'package:digitalskill/user/courses/update_course.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widget/appbar.dart';

class CourseGuideScreen extends StatefulWidget {
  final Map<String, dynamic> courseDetails;

  CourseGuideScreen({required this.courseDetails});

  @override
  State<CourseGuideScreen> createState() => _CourseGuideScreenState();
}

class _CourseGuideScreenState extends State<CourseGuideScreen> {
  String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final fontSizeTitle = width * 0.06; // Adjusted font size
    final fontSizeSubtitle = height * 0.024; // Adjusted font size
    final padding = width * 0.04; // Adjusted padding

    final courseDetails = widget.courseDetails;
    final courseName = capitalize(courseDetails['name'] ?? 'Course');
    final courseLogo = courseDetails['logo_image'] ?? '';
    final courseUrl = courseDetails['url'] ?? '';
    final roadmapImage = courseDetails['roadmap_image'] ?? '';
    final courseDescription = courseDetails['description'] ?? '';

    // Extract the video ID
    final videoId = Uri.parse(courseUrl).queryParameters['v'] ??
        Uri.parse(courseUrl).pathSegments.last;
    print('Extracted video ID: $videoId');

    // Construct the thumbnail URL
    final thumbnailUrl = 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';
    print('Thumbnail URL: $thumbnailUrl');

    return Scaffold(
      appBar: CustomAppBar(title: '$courseName Guide'),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    courseName,
                    style: TextStyle(
                        fontSize: fontSizeTitle, fontWeight: FontWeight.bold),
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(Icons.menu_sharp, size: width * 0.08),
                    onSelected: (value) {
                      if (value == 'delete') {
                        _deleteCourse();
                      } else if (value == 'update') {
                        _updateCourse();
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem<String>(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                      PopupMenuItem<String>(
                        value: 'update',
                        child: Text('Update'),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: height * 0.02),
              Stack(
                children: [
                  Container(
                    height: height * 0.25,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(
                          width * 0.07), // Adjusted radius
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          width * 0.07), // Adjusted radius
                      child: Image.network(
                        thumbnailUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: height * 0.25,
                        errorBuilder: (context, error, stackTrace) {
                          print('Error loading image: $error');
                          return Center(
                            child: Icon(Icons.broken_image, size: width * 0.15),
                          );
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    left: width * 0.4,
                    top: height * 0.1,
                    child: IconButton(
                      icon: Icon(Icons.play_circle_fill,
                          size: width * 0.15, color: Colors.white),
                      onPressed: () {
                        _launchURL(courseUrl);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.02),
              Text('Road Map', style: TextStyle(fontSize: fontSizeSubtitle)),
              GestureDetector(
                onTap: () {
                  _showFullScreenImage(context, roadmapImage, width, height);
                },
                child: Container(
                  width: width,
                  height: height * 0.2,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(width * 0.07), // Adjusted radius
                    image: DecorationImage(
                      image: NetworkImage(roadmapImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: height * 0.01),
              Text('Content', style: TextStyle(fontSize: fontSizeSubtitle)),
              Text(
                courseDescription,
                style:
                    TextStyle(fontSize: height * 0.022), // Adjusted font size
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFullScreenImage(
      BuildContext context, String imageUrl, double width, double height) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          child: Stack(
            children: [
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  print('Error loading full-screen image: $error');
                  return Center(
                    child: Icon(Icons.broken_image, size: width * 0.15),
                  );
                },
              ),
              Positioned(
                top: 40,
                left: 20,
                child: IconButton(
                  icon: Icon(Icons.close,
                      color: Colors.white, size: width * 0.08), // Adjusted size
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _launchURL(String url) async {
    print('Attempting to launch URL: $url');
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      print('Could not launch $url');
      throw 'Could not launch $url';
    }
  }

  void _deleteCourse() async {
    final courseId = widget.courseDetails[
        'id']; // Assuming course ID is available in courseDetails

    if (courseId != null) {
      await FirebaseFirestore.instance
          .collection('courses')
          .doc(courseId)
          .delete();
      Navigator.of(context).pop(); // Close the screen after deletion
    } else {
      print('Course ID not found');
    }
  }

  void _updateCourse() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateCourseScreen(
          course: widget.courseDetails,
          courseId: widget.courseDetails['id'], // Corrected courseId
        ),
      ),
    );
  }
}
