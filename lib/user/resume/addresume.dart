// ignore_for_file: unnecessary_null_comparison, use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors, sort_child_properties_last, avoid_print, avoid_function_literals_in_foreach_calls, prefer_const_literals_to_create_immutables

import 'package:digitalskill/colors/color.dart';
import 'package:digitalskill/widget/appbar.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddResumes extends StatefulWidget {
  @override
  _AddResumesState createState() => _AddResumesState();
}

class _AddResumesState extends State<AddResumes> {
  File? _documentFile;
  List<File> _imageFiles = [];
  File? _backgroundImageFile;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Add Resume",
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDocumentPicker(),
              SizedBox(height: 24.0),
              _buildImagePicker(),
              SizedBox(height: 24.0),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentPicker() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
            color: AppColors.backgroundColor), // Border for document picker
        image: _documentFile == null
            ? DecorationImage(
                image: AssetImage(
                    'assets/images/document_placeholder.png'), // Document icon
                fit: BoxFit.cover,
              )
            : DecorationImage(
                image: FileImage(_documentFile!),
                fit: BoxFit.cover,
              ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.insert_drive_file,
                size: 24.0,
                color: AppColors.backgroundColor,
              ),
              SizedBox(width: 8.0),
              Text(
                'Upload Resume (Document)',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          _documentFile != null
              ? Text(
                  _documentFile!.path.split('/').last,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black54,
                  ),
                )
              : Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: AppColors.backgroundColor),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.insert_drive_file,
                      size: 50.0,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
          SizedBox(height: 12.0),
          Center(
            child: IconButton(
              icon: Icon(Icons.insert_drive_file,
                  size: 32.0, color: AppColors.backgroundColor),
              onPressed: _pickDocument,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePicker() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
            color: AppColors.backgroundColor), // Border for image picker
        image: _backgroundImageFile != null
            ? DecorationImage(
                image: FileImage(_backgroundImageFile!),
                fit: BoxFit.cover,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upload Images',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8.0),
          _imageFiles.isNotEmpty
              ? Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: _imageFiles.map((file) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.file(
                        file,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    );
                  }).toList(),
                )
              : Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: AppColors.backgroundColor),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.add_photo_alternate,
                      size: 50.0,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
          SizedBox(height: 12.0),
          Center(
            child: IconButton(
              icon: Icon(Icons.add_photo_alternate,
                  size: 32.0, color: AppColors.backgroundColor),
              onPressed: _pickImages,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Center(
      child: ElevatedButton(
        onPressed: _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.backgroundColor,
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Text(
          'Submit',
          style: TextStyle(fontSize: 16.0, color: Colors.white),
        ),
      ),
    );
  }

  Future<void> _pickDocument() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _documentFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _pickImages() async {
    final pickedFiles = await _imagePicker.pickMultiImage();

    if (pickedFiles != null) {
      setState(() {
        _imageFiles =
            pickedFiles.map((pickedFile) => File(pickedFile.path)).toList();
        if (_imageFiles.isNotEmpty) {
          _backgroundImageFile = _imageFiles.first;
        }
      });
    }
  }

  void _submitForm() {
    if (_documentFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a document')),
      );
      return;
    }

    if (_imageFiles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select at least one image')),
      );
      return;
    }

    // Handle form submission here
    print('Document File: ${_documentFile?.path}');
    _imageFiles.forEach((file) => print('Image File: ${file.path}'));

    // You can add logic to handle the selected files here
  }
}
