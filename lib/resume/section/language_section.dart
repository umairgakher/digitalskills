import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LanguageSkill {
  String name;
  String readingProficiency;
  String writingProficiency;
  String speakingProficiency;

  LanguageSkill({
    required this.name,
    required this.readingProficiency,
    required this.writingProficiency,
    required this.speakingProficiency,
  });
}

class LanguageSkillSection extends StatefulWidget {
  @override
  _LanguageSkillSectionState createState() => _LanguageSkillSectionState();
}

class _LanguageSkillSectionState extends State<LanguageSkillSection> {
  final List<LanguageSkill> _languageSkills = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _readingProficiencyController =
      TextEditingController();
  final TextEditingController _writingProficiencyController =
      TextEditingController();
  final TextEditingController _speakingProficiencyController =
      TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  int? _editingIndex;

  @override
  void initState() {
    super.initState();
    _fetchLanguageSkills();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _readingProficiencyController.dispose();
    _writingProficiencyController.dispose();
    _speakingProficiencyController.dispose();
    super.dispose();
  }

  Future<void> _fetchLanguageSkills() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('user_resume').doc(userId).get();
      if (userDoc.exists) {
        List<dynamic> skillsList = userDoc['language_skills'] ?? [];
        setState(() {
          _languageSkills.clear();
          for (var skill in skillsList) {
            _languageSkills.add(LanguageSkill(
              name: skill['name'] ?? '',
              readingProficiency: skill['readingProficiency'] ?? '',
              writingProficiency: skill['writingProficiency'] ?? '',
              speakingProficiency: skill['speakingProficiency'] ?? '',
            ));
          }
        });
      }
    } catch (e) {
      print('Error fetching language skills: $e');
    }
  }

  void _addOrUpdateLanguageSkill() {
    if (_nameController.text.isNotEmpty &&
        _readingProficiencyController.text.isNotEmpty &&
        _writingProficiencyController.text.isNotEmpty &&
        _speakingProficiencyController.text.isNotEmpty) {
      setState(() {
        if (_editingIndex != null) {
          // Update existing skill
          _languageSkills[_editingIndex!] = LanguageSkill(
            name: _nameController.text,
            readingProficiency: _readingProficiencyController.text,
            writingProficiency: _writingProficiencyController.text,
            speakingProficiency: _speakingProficiencyController.text,
          );
          _editingIndex = null; // Reset editing index
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Language skill updated successfully!')),
          );
        } else {
          // Add new skill
          _languageSkills.add(LanguageSkill(
            name: _nameController.text,
            readingProficiency: _readingProficiencyController.text,
            writingProficiency: _writingProficiencyController.text,
            speakingProficiency: _speakingProficiencyController.text,
          ));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Language skill added successfully!')),
          );
        }
        _clearFields();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
    }
  }

  void _removeLanguageSkill(int index) {
    setState(() {
      _languageSkills.removeAt(index);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Language skill removed successfully!')),
      );
    });
  }

  void _editLanguageSkill(LanguageSkill lang, int index) {
    setState(() {
      _editingIndex = index;
      _nameController.text = lang.name;
      _readingProficiencyController.text = lang.readingProficiency;
      _writingProficiencyController.text = lang.writingProficiency;
      _speakingProficiencyController.text = lang.speakingProficiency;
    });
  }

  void _clearFields() {
    _nameController.clear();
    _readingProficiencyController.clear();
    _writingProficiencyController.clear();
    _speakingProficiencyController.clear();
    _editingIndex = null; // Clear editing index
  }

  Future<void> _saveLanguageSkills() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    List<Map<String, dynamic>> languageSkillsData = _languageSkills.map((lang) {
      return {
        'name': lang.name,
        'readingProficiency': lang.readingProficiency ?? "",
        'writingProficiency': lang.writingProficiency ?? "",
        'speakingProficiency': lang.speakingProficiency ?? "",
      };
    }).toList();

    try {
      // Update the 'language_skills' array in the user's document in 'user_resume'
      await _firestore.collection('user_resume').doc(userId).update({
        'language_skills': languageSkillsData,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Language skills saved successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save language skills: $e')),
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
            'Language Skills',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _buildTextField(_nameController, 'Language'),
          const SizedBox(height: 10),
          _buildTextField(_readingProficiencyController, 'Reading Proficiency'),
          const SizedBox(height: 10),
          _buildTextField(_writingProficiencyController, 'Writing Proficiency'),
          const SizedBox(height: 10),
          _buildTextField(
              _speakingProficiencyController, 'Speaking Proficiency'),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () => _addOrUpdateLanguageSkill(),
                child: Text(_editingIndex == null
                    ? 'Add Language Skill'
                    : 'Update Language Skill'),
              ),
              ElevatedButton(
                onPressed: () => _saveLanguageSkills(),
                child: const Text('Save'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Added Language Skills:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          ..._languageSkills.asMap().entries.map((entry) {
            int index = entry.key;
            LanguageSkill langSkill = entry.value;
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: ListTile(
                title: Text(langSkill.name),
                subtitle: Text(
                    'Reading: ${langSkill.readingProficiency}\nWriting: ${langSkill.writingProficiency}\nSpeaking: ${langSkill.speakingProficiency}'),
                isThreeLine: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _editLanguageSkill(langSkill, index),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _removeLanguageSkill(index),
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

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }
}
