import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalskill/resume/models/education.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EducationSection extends StatefulWidget {
  @override
  _EducationSectionState createState() => _EducationSectionState();
}

class _EducationSectionState extends State<EducationSection> {
  final List<Education> _educations = [];
  final TextEditingController _degreeController = TextEditingController();
  final TextEditingController _institutionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _graduationYearController =
      TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  int? _editingIndex;

  @override
  void initState() {
    super.initState();
    _fetchEducationRecords();
  }

  @override
  void dispose() {
    _degreeController.dispose();
    _institutionController.dispose();
    _locationController.dispose();
    _graduationYearController.dispose();
    super.dispose();
  }

  Future<void> _fetchEducationRecords() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('user_resume').doc(userId).get();
      if (userDoc.exists) {
        List<dynamic> educationList = userDoc['educations'] ?? [];
        setState(() {
          _educations.clear();
          for (var edu in educationList) {
            _educations.add(Education(
              degree: edu['degree'] ?? '',
              institution: edu['institution'] ?? '',
              location: edu['location'] ?? '',
              graduationYear: edu['graduation_year'] ?? '',
            ));
          }
        });
      }
    } catch (e) {
      print('Error fetching education records: $e');
    }
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      controller.text = '${pickedDate.year}'; // Only show the year
    }
  }

  void _addOrUpdateEducation() {
    if (_degreeController.text.isNotEmpty &&
        _institutionController.text.isNotEmpty) {
      setState(() {
        if (_editingIndex != null) {
          // Update the existing education entry
          _educations[_editingIndex!] = Education(
            degree: _degreeController.text,
            institution: _institutionController.text,
            location: _locationController.text,
            graduationYear: _graduationYearController.text,
          );
          _editingIndex = null; // Reset editing index
        } else {
          // Add a new education entry
          _educations.add(Education(
            degree: _degreeController.text,
            institution: _institutionController.text,
            location: _locationController.text,
            graduationYear: _graduationYearController.text,
          ));
        }
        _clearFields();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Please fill in at least degree and institution')),
      );
    }
  }

  void _removeEducation(int index) {
    setState(() {
      _educations.removeAt(index);
    });
  }

  void _editEducation(int index) {
    setState(() {
      _editingIndex = index;
      Education education = _educations[index];
      _degreeController.text = education.degree;
      _institutionController.text = education.institution;
      _locationController.text = education.location;
      _graduationYearController.text = education.graduationYear;
    });
  }

  void _clearFields() {
    _degreeController.clear();
    _institutionController.clear();
    _locationController.clear();
    _graduationYearController.clear();
    _editingIndex = null; // Clear editing index
  }

  Future<void> _saveEducation() async {
    String userId =
        FirebaseAuth.instance.currentUser!.uid; // Get the current user's ID

    // Create a list of maps from the `_educations` list
    List<Map<String, dynamic>> educationData = _educations.map((edu) {
      return {
        'degree': edu.degree ?? "",
        'institution': edu.institution ?? "",
        'location': edu.location ?? "",
        'graduation_year': edu.graduationYear ?? "",
      };
    }).toList();

    try {
      // Update the entire 'educations' field with the new data (replace existing data)
      await _firestore.collection('user_resume').doc(userId).update({
        'educations':
            educationData, // This will replace the existing list with the new one
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Education details saved successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save education details: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Education',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _buildTextField(_degreeController, 'Degree'),
          const SizedBox(height: 10),
          _buildTextField(_institutionController, 'Institution'),
          const SizedBox(height: 10),
          _buildTextField(_locationController, 'Location'),
          const SizedBox(height: 10),
          _buildTextField(_graduationYearController, 'Graduation Year',
              onTap: () => _selectDate(context, _graduationYearController)),
          const SizedBox(height: 10),
          Row(
            children: [
              ElevatedButton(
                onPressed: _addOrUpdateEducation,
                child: Text(
                  _editingIndex != null ? 'Update Education' : 'Add Education',
                ),
              ),
              const SizedBox(width: 10),
              if (_editingIndex == null) // Show Save button only when adding
                ElevatedButton(
                  onPressed: _saveEducation,
                  child: const Text('Save'),
                ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Added Education:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          ..._educations.asMap().entries.map((entry) {
            int index = entry.key;
            Education education = entry.value;
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: ListTile(
                title:
                    Text('${education.degree} from ${education.institution}'),
                subtitle:
                    Text('${education.graduationYear}\n${education.location}'),
                isThreeLine: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _editEducation(index),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _removeEducation(index),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {Function()? onTap, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      maxLines: maxLines,
      onTap: onTap,
    );
  }
}
