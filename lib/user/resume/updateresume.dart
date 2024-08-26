// ignore_for_file: unused_local_variable, unnecessary_null_comparison, use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors, sort_child_properties_last, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalskill/colors/color.dart';
import 'package:digitalskill/user/resume/addresume.dart';
import 'package:digitalskill/widget/appbar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

class ResumeListScreen extends StatefulWidget {
  @override
  _ResumeListScreenState createState() => _ResumeListScreenState();
}

class _ResumeListScreenState extends State<ResumeListScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  File? _newImageFile;
  File? _newDocumentFile;
  String? _resumeIdToEdit;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final isPortrait = mediaQuery.orientation == Orientation.portrait;

    return Scaffold(
      appBar: CustomAppBar(
        title: "Resumes",
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.02),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('resume').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
              return Center(child: Text("No resumes available"));
            }

            final resumes = snapshot.data!.docs;

            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isPortrait ? 2 : 3,
                crossAxisSpacing: screenWidth * 0.02,
                mainAxisSpacing: screenWidth * 0.02,
              ),
              itemCount: resumes.length,
              itemBuilder: (context, index) {
                final resume = resumes[index].data() as Map<String, dynamic>;
                final imageUrls =
                    List<String>.from(resume['imageUrls'] as List<dynamic>);
                final cvName = resume['cvName'] ?? 'No Name';

                return GestureDetector(
                  onTap: () {
                    _resumeIdToEdit = resumes[index].id;
                    _showEditDialog(resume);
                  },
                  child: Container(
                    padding: EdgeInsets.all(screenWidth * 0.02),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(screenWidth * 0.02),
                      color: Colors.grey[300],
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: imageUrls.isNotEmpty
                              ? ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(screenWidth * 0.02),
                                  child: Image.network(
                                    imageUrls.first,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Container(
                                  color: Colors.grey[500],
                                  child: Center(
                                    child: Icon(
                                      Icons.image,
                                      size: screenWidth * 0.1,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                        ),
                        Positioned(
                          top: screenWidth * 0.02,
                          left: screenWidth * 0.02,
                          right: screenWidth * 0.02,
                          child: Text(
                            cvName,
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Positioned(
                          bottom: screenWidth * 0.02,
                          right: screenWidth * 0.02,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit,
                                    color: AppColors.backgroundColor),
                                onPressed: () {
                                  _resumeIdToEdit = resumes[index].id;
                                  _showEditDialog(resume);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete,
                                    color: AppColors.backgroundColor),
                                onPressed: () async {
                                  await _deleteResume(resumes[index].id);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddResumes()),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: AppColors.backgroundColor,
      ),
    );
  }

  Future<void> _showEditDialog(Map<String, dynamic> resume) async {
    final documentUrl = resume['documentUrl'] as String;
    final imageUrls = List<String>.from(resume['imageUrls'] as List<dynamic>);

    showDialog(
      context: context,
      builder: (context) {
        final mediaQuery = MediaQuery.of(context);
        final screenWidth = mediaQuery.size.width;
        final screenHeight = mediaQuery.size.height;

        return AlertDialog(
          title: Text("Edit Resume"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (imageUrls.isNotEmpty) ...[
                Image.network(
                  imageUrls.first,
                  width: screenWidth * 0.25,
                  height: screenHeight * 0.15,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: screenHeight * 0.02),
              ],
              ElevatedButton(
                onPressed: _pickNewDocument,
                child: Text("Change Document"),
              ),
              ElevatedButton(
                onPressed: _pickNewImages,
                child: Text("Change Images"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                await _updateResume(resume);
                Navigator.pop(context);
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickNewDocument() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _newDocumentFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _pickNewImages() async {
    final pickedFiles = await _imagePicker.pickMultiImage();

    if (pickedFiles != null) {
      setState(() {
        _newImageFile =
            pickedFiles.isNotEmpty ? File(pickedFiles.first.path) : null;
      });
    }
  }

  Future<void> _updateResume(Map<String, dynamic> resume) async {
    if (_resumeIdToEdit == null) return;

    final resumeRef =
        FirebaseFirestore.instance.collection('resume').doc(_resumeIdToEdit!);

    // Upload new document if selected
    String? newDocumentUrl;
    if (_newDocumentFile != null) {
      newDocumentUrl = await _uploadFileToFirebaseStorage(
        _newDocumentFile!,
        'resumes',
      );
    }

    // Upload new image if selected
    List<String>? newImageUrls;
    if (_newImageFile != null) {
      newImageUrls = [
        await _uploadFileToFirebaseStorage(_newImageFile!, 'resumes')
      ];
    }

    // Update Firestore document
    await resumeRef.update({
      if (newDocumentUrl != null) 'documentUrl': newDocumentUrl,
      if (newImageUrls != null) 'imageUrls': newImageUrls,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Resume updated successfully!')),
    );
  }

  Future<void> _deleteResume(String resumeId) async {
    final resumeRef =
        FirebaseFirestore.instance.collection('resume').doc(resumeId);

    // Optionally delete files from Firebase Storage
    final resumeData = (await resumeRef.get()).data() as Map<String, dynamic>;
    final imageUrls =
        List<String>.from(resumeData['imageUrls'] as List<dynamic>);
    final documentUrl = resumeData['documentUrl'] as String;

    for (var url in imageUrls) {
      await FirebaseStorage.instance.refFromURL(url).delete();
    }
    await FirebaseStorage.instance.refFromURL(documentUrl).delete();

    // Delete the Firestore document
    await resumeRef.delete();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Resume deleted successfully!')),
    );
  }

  Future<String> _uploadFileToFirebaseStorage(File file, String folder) async {
    String fileName = path.basename(file.path);
    Reference storageReference =
        FirebaseStorage.instance.ref().child('$folder/$fileName');
    UploadTask uploadTask = storageReference.putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }
}
