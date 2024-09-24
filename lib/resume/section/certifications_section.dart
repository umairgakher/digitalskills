import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalskill/resume/models/certification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CertificationSection extends StatefulWidget {
  @override
  _CertificationSectionState createState() => _CertificationSectionState();
}

class _CertificationSectionState extends State<CertificationSection> {
  final List<Certification> _certifications = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _organizationController = TextEditingController();
  final TextEditingController _dateObtainedController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  int? _editingIndex;

  @override
  void initState() {
    super.initState();
    _fetchCertifications();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _organizationController.dispose();
    _dateObtainedController.dispose();
    super.dispose();
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
      controller.text = DateFormat('yyyy-MM-dd')
          .format(pickedDate); // Show date in 'yyyy-MM-dd' format
    }
  }

  Future<void> _fetchCertifications() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('user_resume').doc(userId).get();
      if (snapshot.exists && snapshot['certifications'] != null) {
        List certificationsData = snapshot['certifications'];
        setState(() {
          _certifications.clear();
          _certifications.addAll(certificationsData.map((cert) => Certification(
                name: cert['name'],
                issuingOrganization: cert['issuingOrganization'],
                dateObtained: cert['dateObtained'],
              )));
        });
      }
    } catch (e) {
      _showSnackBar('Failed to fetch certifications: $e');
    }
  }

  void _addOrUpdateCertification() {
    if (_nameController.text.isNotEmpty &&
        _organizationController.text.isNotEmpty &&
        _dateObtainedController.text.isNotEmpty) {
      setState(() {
        if (_editingIndex != null) {
          // Update the existing certification entry
          _certifications[_editingIndex!] = Certification(
            name: _nameController.text,
            issuingOrganization: _organizationController.text,
            dateObtained: _dateObtainedController.text,
          );
          _editingIndex = null; // Reset editing index
        } else {
          // Add a new certification entry
          _certifications.add(Certification(
            name: _nameController.text,
            issuingOrganization: _organizationController.text,
            dateObtained: _dateObtainedController.text,
          ));
        }
        _clearControllers();
      });
    } else {
      _showSnackBar('Please fill in all fields');
    }
  }

  void _removeCertification(int index) {
    setState(() {
      _certifications.removeAt(index);
    });
  }

  void _editCertification(int index) {
    Certification certification = _certifications[index];
    _nameController.text = certification.name;
    _organizationController.text = certification.issuingOrganization;
    _dateObtainedController.text = certification.dateObtained;
    _editingIndex = index;
  }

  void _clearControllers() {
    _nameController.clear();
    _organizationController.clear();
    _dateObtainedController.clear();
    _editingIndex = null; // Clear editing index
  }

  Future<void> _saveCertifications() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    List<Map<String, dynamic>> certificationData = _certifications.map((cert) {
      return {
        'name': cert.name ?? "",
        'issuingOrganization': cert.issuingOrganization ?? "",
        'dateObtained': cert.dateObtained ?? "",
      };
    }).toList();

    try {
      await _firestore.collection('user_resume').doc(userId).update({
        'certifications': certificationData,
      });

      _showSnackBar('Certifications saved successfully!');
    } catch (e) {
      _showSnackBar('Failed to save certifications: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Certifications',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _buildTextField(_nameController, 'Certification Name'),
          const SizedBox(height: 10),
          _buildTextField(_organizationController, 'Issuing Organization'),
          const SizedBox(height: 10),
          _buildTextField(_dateObtainedController, 'Date Obtained',
              onTap: () => _selectDate(context, _dateObtainedController)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: _addOrUpdateCertification,
                child: Text(_editingIndex != null
                    ? 'Update Certification'
                    : 'Add Certification'),
              ),
              const SizedBox(width: 10),
              if (_editingIndex == null) // Show Save button only when adding
                ElevatedButton(
                  onPressed: _saveCertifications,
                  child: const Text('Save'),
                ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Added Certifications:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          ..._certifications.asMap().entries.map((entry) {
            int index = entry.key;
            Certification certification = entry.value;
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: ListTile(
                title: Text(certification.name),
                subtitle: Text(
                    '${certification.issuingOrganization}\nObtained on: ${certification.dateObtained}'),
                isThreeLine: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _editCertification(index);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _removeCertification(index),
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
