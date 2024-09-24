import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PersonalInformationSection extends StatefulWidget {
  @override
  _PersonalInformationSectionState createState() =>
      _PersonalInformationSectionState();
}

class _PersonalInformationSectionState
    extends State<PersonalInformationSection> {
  final ImagePicker _picker = ImagePicker();
  File? _profileImage;
  String? _profileImageUrl; // To store the profile image URL

  // Controllers for form fields
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _aboutMeController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _nationalityController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _linkedinController = TextEditingController();
  TextEditingController _portfolioController = TextEditingController();
  TextEditingController _instantMessagingController = TextEditingController();
  TextEditingController _websiteController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _postalCodeController = TextEditingController();
  TextEditingController _countryController = TextEditingController();
  DateTime? _dob;

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Fetch existing data on initialization
  }

  Future<void> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('User is not logged in');
      return;
    }

    try {
      // Fetch document for the current user from 'user_resume' collection
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('user_resume')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;

        setState(() {
          _firstNameController.text = data['firstName'] ?? '';
          _lastNameController.text = data['lastName'] ?? '';
          _aboutMeController.text = data['aboutMe'] ?? '';
          _dobController.text = data['dob'] ?? '';
          _genderController.text = data['gender'] ?? '';
          _emailController.text = data['email'] ?? '';
          _phoneController.text = data['phone'] ?? '';
          _linkedinController.text = data['linkedin'] ?? '';
          _instantMessagingController.text = data['instantMessaging'] ?? '';
          _addressController.text = data['address'] ?? '';
          _countryController.text = data['country'] ?? '';

          _profileImageUrl = data['profileImage'];

          if (data['dob'] != null && data['dob'] is String) {
            try {
              _dob = DateTime.parse(data['dob']);
              _dobController.text = _dob.toString().split(' ')[0];
            } catch (e) {
              // Handle invalid date format
            }
          }
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> _selectProfileImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path); // Directly using picked image
      });
    }
  }

  Future<String?> _uploadProfileImage() async {
    if (_profileImage == null) return null;

    try {
      final Reference storageRef = FirebaseStorage.instance.ref().child(
          'profile_images/${FirebaseAuth.instance.currentUser!.uid}.jpg');

      await storageRef.putFile(_profileImage!);
      return await storageRef.getDownloadURL();
    } catch (e) {
      print('Error uploading profile image: $e');
      return null;
    }
  }

  Future<void> _savePersonalInformation() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('User is not logged in');
        return;
      }

      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('user_resume').doc(user.uid);

      String? profileImageUrl = await _uploadProfileImage();

      Map<String, dynamic> updatedData = {
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'dob': _dobController.text,
        'gender': _genderController.text,
        'linkedin': _linkedinController.text,
        'instantMessaging': _instantMessagingController.text,
        'address': _addressController.text,
        'country': _countryController.text,
        'aboutMe': _aboutMeController.text,
        'profileImage':
            profileImageUrl ?? _profileImageUrl, // Save or use existing URL
      };

      await userDocRef.set(updatedData, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Personal information saved successfully!'),
      ));
    } catch (e) {
      print('Error saving personal information: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error saving personal information. Please try again.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Personal Information',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          GestureDetector(
            onTap: _selectProfileImage,
            child: CircleAvatar(
              radius: 50,
              backgroundImage: _profileImage != null
                  ? FileImage(_profileImage!)
                  : (_profileImageUrl != null
                      ? NetworkImage(_profileImageUrl!)
                      : null) as ImageProvider?,
              child: _profileImage == null && _profileImageUrl == null
                  ? Icon(Icons.camera_alt, size: 50)
                  : null,
            ),
          ),
          SizedBox(height: 20),
          _buildTextField(_firstNameController, 'First Name'),
          SizedBox(height: 20),
          _buildTextField(_lastNameController, 'Last Name'),
          SizedBox(height: 20),
          _buildTextField(_emailController, 'Email'),
          SizedBox(height: 20),
          _buildTextField(_phoneController, 'Phone'),
          SizedBox(height: 20),
          _buildTextField(_dobController, 'Date of Birth',
              readOnly: true, onTap: () => _selectDateOfBirth(context)),
          SizedBox(height: 20),
          _buildTextField(_genderController, 'Gender'),
          SizedBox(height: 20),
          _buildTextField(_linkedinController, 'LinkedIn'),
          SizedBox(height: 20),
          _buildTextField(
              _instantMessagingController, 'Instant Messaging Whatsapp'),
          SizedBox(height: 20),
          _buildTextField(_addressController, 'Address'),
          SizedBox(height: 20),
          _buildTextField(_countryController, 'Country'),
          SizedBox(height: 20),
          _buildTextField(_aboutMeController, 'About Me', maxLines: 10),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _savePersonalInformation,
            child: Text('Save Information'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText,
      {bool readOnly = false, VoidCallback? onTap, int maxLines = 1}) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
      ),
    );
  }

  Future<void> _selectDateOfBirth(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dob ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _dob) {
      setState(() {
        _dob = picked;
        _dobController.text = _dob!.toString().split(' ')[0];
      });
    }
  }
}
