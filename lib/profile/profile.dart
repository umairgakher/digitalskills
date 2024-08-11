// ignore_for_file: prefer_const_constructors, deprecated_member_use, use_key_in_widget_constructors, sort_child_properties_last, library_private_types_in_public_api, no_leading_underscores_for_local_identifiers

import 'package:digitalskill/colors/color.dart';
import 'package:digitalskill/loginsignup/login.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  String? profileImage;
  String name = "Test Test";
  String phone = "(208) 206-5039";
  String email = "test.test@gmail.com";
  String about =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final textScaleFactor = mediaQuery.textScaleFactor;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () =>
              Navigator.pop(context), // Navigates back to the previous screen
        ),
        title: Center(
            child: Text(
          "Edit Profile",
          style: TextStyle(color: Colors.white),
        )),
        backgroundColor: AppColors.backgroundColor,
        // 10% of the screen height
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04), // 4% of the screen width
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileAvatar(screenWidth),
              SizedBox(height: screenHeight * 0.03), // 3% of the screen height
              _buildProfileInfo(
                  "Name",
                  name,
                  () => _showEditDialog(context, "Name", name, (newValue) {
                        setState(() {
                          name = newValue;
                        });
                      }),
                  textScaleFactor),
              _buildProfileInfo(
                  "Phone",
                  phone,
                  () => _showEditDialog(context, "Phone", phone, (newValue) {
                        setState(() {
                          phone = newValue;
                        });
                      }),
                  textScaleFactor),
              _buildProfileInfo(
                  "Email", email, () {}, textScaleFactor), // No edit for email
              _buildProfileInfo(
                  "Tell Us About Yourself",
                  about,
                  () => _showEditDialog(context, "About", about, (newValue) {
                        setState(() {
                          about = newValue;
                        });
                      }),
                  textScaleFactor),
              SizedBox(
                  height: screenHeight *
                      0.02), // Added spacing for better visibility
              Center(
                child: ElevatedButton(
                  onPressed: _logOut,
                  child: Text(
                    "Log Out",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.backgroundColor,
                    minimumSize: Size(screenWidth * 0.5,
                        screenHeight * 0.07), // 50% width and 7% height
                    textStyle: TextStyle(
                        fontSize: textScaleFactor * 16), // Scaled text size
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileAvatar(double screenWidth) {
    return Center(
      child: Stack(
        clipBehavior: Clip
            .none, // Allows the Positioned widget to extend outside the stack
        children: [
          Container(
            width: screenWidth * 0.4, // Adjust size based on your requirements
            height: screenWidth * 0.4, // Adjust size based on your requirements
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: AppColors.backgroundColor, width: 6.0), // Blue border
            ),
            child: CircleAvatar(
              radius: screenWidth * 0.25, // 15% of screen width
              backgroundImage: profileImage != null
                  ? NetworkImage(profileImage!)
                  : AssetImage('assets/images/profilepic.png') as ImageProvider,
            ),
          ),
          Positioned(
            bottom: -9, // Adjust positioning based on your preference
            right: -10, // Adjust positioning based on your preference
            child: Container(
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: AppColors.backgroundColor,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(Icons.camera_alt, color: Colors.white),
                onPressed: _pickImage,
                iconSize: screenWidth * 0.08, // 8% of screen width
                color: AppColors.backgroundColor, // Color for the icon
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo(
      String title, String value, VoidCallback onEdit, double textScaleFactor) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical:
              MediaQuery.of(context).size.height * 0.02), // 2% of screen height
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.backgroundColor,
                    fontSize: textScaleFactor * 18, // Scaled text size
                  ),
                ),
                SizedBox(
                    height: MediaQuery.of(context).size.height *
                        0.01), // 1% of screen height
                Text(
                  value,
                  overflow: TextOverflow.visible,
                  softWrap: true,
                  style: TextStyle(
                    fontSize: textScaleFactor * 16, // Scaled text size
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
              width: MediaQuery.of(context).size.width *
                  0.02), // 2% of screen width
          if (title != "Email") // Only show edit icon for editable fields
            IconButton(
              icon: Icon(Icons.arrow_forward_ios, color: Colors.grey),
              onPressed: onEdit,
            ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, String field, String currentValue,
      ValueChanged<String> onSave) {
    TextEditingController _controller =
        TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit $field"),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(labelText: field),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text("Save"),
              onPressed: () {
                onSave(_controller.text); // Pass the new value back
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        profileImage = pickedFile.path;
      });
    }
  }

  void _logOut() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
}
