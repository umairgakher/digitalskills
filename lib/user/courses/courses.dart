// ignore_for_file: use_key_in_widget_constructors, prefer_const_declarations, prefer_const_constructors, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // For URL launching

import '../../widget/appbar.dart';

class CourseGuideScreen extends StatefulWidget {
  @override
  State<CourseGuideScreen> createState() => _CourseGuideScreenState();
}

class _CourseGuideScreenState extends State<CourseGuideScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final fontSizeTitle = 24.0;
    final fontSizeSubtitle = height * 0.024;
    final padding = 16.0;

    return Scaffold(
      appBar: CustomAppBar(title: 'Flutter Guide'),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Flutter ',
                style: TextStyle(
                    fontSize: fontSizeTitle, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: height * 0.02),
              Stack(
                children: [
                  Container(
                    height: height * 0.25, // Placeholder height
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                              'https://img.youtube.com/vi/jqxz7QvdWk8/maxresdefault.jpg'), // Replace with your thumbnail URL
                          fit: BoxFit.cover,
                        ),
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  Positioned(
                    left: width * 0.4, // Center horizontally
                    top: height * 0.1, // Center vertically
                    child: IconButton(
                      icon: Icon(Icons.play_circle_fill,
                          size: 60, color: Colors.white),
                      onPressed: () {
                        _launchURL(
                            'https://youtu.be/jqxz7QvdWk8?si=QyfHbAiw9poJRlE3');
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.02),
              Text('Road Map', style: TextStyle(fontSize: fontSizeSubtitle)),
              GestureDetector(
                onTap: () {
                  _showFullScreenImage(context, 'assets/images/flutter.png');
                },
                child: Container(
                  width: width, // Full width of the screen
                  height: height * 0.2, // Adjust the height as needed
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(30), // Add border radius
                    image: DecorationImage(
                      image: AssetImage('assets/images/flutter.png'),
                      fit:
                          BoxFit.cover, // Ensure the image covers the container
                    ),
                  ),
                ),
              ),
              SizedBox(height: height * 0.01),
              Text('How to install',
                  style: TextStyle(fontSize: fontSizeSubtitle)),
              ListTile(
                title: Text(
                  "Toyou'll need to use a video thumbnail image or a network image that represents:",
                  style: TextStyle(fontSize: 16),
                ),
                subtitle: Text(
                    "Here's additional information about handling video thumbnails and play actions."),
                isThreeLine: true,
                trailing: Icon(Icons.info_outline),
              ),
              SizedBox(height: height * 0.01),
              Text('First Program',
                  style: TextStyle(fontSize: fontSizeSubtitle)),
              ListTile(
                title: Text(
                  "To display a video thumbnail or preview directly in the video placeholder, you'll :",
                  style: TextStyle(fontSize: 16),
                ),
                subtitle: Text(
                    "Here's additional information about handling video thumbnails and play actions."),
                isThreeLine: true,
              ),
              SizedBox(height: height * 0.01),
              Text('Run App on VS',
                  style: TextStyle(fontSize: fontSizeSubtitle)),
              ListTile(
                title: Text(
                  "To display a video thumbnail or preview directly in the video placeholder, you'll :",
                  style: TextStyle(fontSize: 16),
                ),
                subtitle: Text(
                    "Here's additional information about handling video thumbnails and play actions."),
                isThreeLine: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFullScreenImage(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          child: Stack(
            children: [
              Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
              Positioned(
                top: 40,
                left: 20,
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.white, size: 30),
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
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
