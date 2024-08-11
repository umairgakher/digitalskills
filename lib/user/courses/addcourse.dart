// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, library_private_types_in_public_api, avoid_print, sort_child_properties_last

import 'package:digitalskill/colors/color.dart';
import 'package:digitalskill/widget/appbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class AddCourseScreen extends StatefulWidget {
  @override
  _AddCourseScreenState createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  final _urlController = TextEditingController();
  final _textController = TextEditingController();
  String? _selectedType;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  final List<String> _courseTypes = ['Front-End', 'Back-End', 'Other'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Add New Course',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                controller: _urlController,
                hintText: 'Enter course URL',
                labelText: 'Course URL',
              ),
              SizedBox(height: 16.0),
              _buildDropdown(),
              SizedBox(height: 16.0),
              _buildImagePicker(),
              SizedBox(height: 16.0),
              _buildTextField(
                controller: _textController,
                hintText: 'Enter additional text',
                labelText: 'Additional Text',
                maxLines: 4,
              ),
              SizedBox(height: 20.0),
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.backgroundColor,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required String labelText,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        border: OutlineInputBorder(),
      ),
      maxLines: maxLines,
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedType,
      hint: Text('Select course type'),
      items: _courseTypes.map((type) {
        return DropdownMenuItem(
          value: type,
          child: Text(type),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedType = value;
        });
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Course Type',
      ),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Roadmap Image'),
        SizedBox(height: 8.0),
        _selectedImage != null
            ? Image.file(
                _selectedImage!,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              )
            : Placeholder(
                fallbackHeight: 150,
                fallbackWidth: double.infinity,
              ),
        SizedBox(height: 8.0),
        Align(
          alignment: Alignment.center,
          child: IconButton(
            icon: Icon(Icons.add_a_photo, size: 32.0),
            onPressed: _pickImage,
            tooltip: 'Select Image',
          ),
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    final permissionStatus = await Permission.photos.request();

    if (permissionStatus.isGranted) {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } else {
      // Handle the case when permission is not granted
      print('Permission denied');
    }
  }

  void _submitForm() {
    final url = _urlController.text;
    final additionalText = _textController.text;

    print('Course URL: $url');
    print('Course Type: $_selectedType');
    print('Roadmap Image URL: ${_selectedImage?.path}');
    print('Additional Text: $additionalText');

    // Here you can add your logic to save the data or perform other actions
  }
}
