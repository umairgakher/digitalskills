import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalskill/colors/color.dart'; // Ensure this import matches your project structure
import 'package:digitalskill/user/resume/updateresume.dart';
import 'package:digitalskill/widget/appbar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

class AddResumes extends StatefulWidget {
  @override
  _AddResumesState createState() => _AddResumesState();
}

class _AddResumesState extends State<AddResumes> {
  File? _documentFile;
  List<File> _imageFiles = [];
  final ImagePicker _imagePicker = ImagePicker();
  final TextEditingController _cvNameController = TextEditingController();

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
              _buildCvNameField(),
              SizedBox(height: 24.0),
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

  Widget _buildCvNameField() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: AppColors.backgroundColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _cvNameController,
        decoration: InputDecoration(
          labelText: 'CV Name',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.title, color: AppColors.backgroundColor),
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
        border: Border.all(color: AppColors.backgroundColor),
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
                  path.basename(_documentFile!.path),
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
        border: Border.all(color: AppColors.backgroundColor),
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
      });
    }
  }

  Future<void> _submitForm() async {
    if (_cvNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a CV name')),
      );
      return;
    }

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

    try {
      // Upload document to Firebase Storage
      String documentUrl = await _uploadFileToFirebaseStorage(_documentFile!);

      // Upload images to Firebase Storage and get their URLs
      List<String> imageUrls = await Future.wait(
        _imageFiles.map((file) => _uploadFileToFirebaseStorage(file)),
      );

      // Save CV name, document, and image URLs to Firestore
      await FirebaseFirestore.instance.collection('resume').add({
        'cvName': _cvNameController.text,
        'documentUrl': documentUrl,
        'imageUrls': imageUrls,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Resume added successfully!')),
      );

      // Navigate to ResumeListScreen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => ResumeListScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading resume: $e')),
      );
    }
  }

  Future<String> _uploadFileToFirebaseStorage(File file) async {
    String fileName = path.basename(file.path);
    Reference storageReference =
        FirebaseStorage.instance.ref().child('resumes/$fileName');
    UploadTask uploadTask = storageReference.putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }
}
