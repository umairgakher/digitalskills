// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:digitalskill/widget/appbar.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class UserInterviewsPage extends StatefulWidget {
  final Map<String, dynamic> interview;
  final String InterviewId;

  const UserInterviewsPage({
    required this.InterviewId,
    required this.interview,
  });

  @override
  State<UserInterviewsPage> createState() => _UserInterviewsPageState();
}

class _UserInterviewsPageState extends State<UserInterviewsPage> {
  int currentQuestionIndex = 0;
  int correctAnswersCount = 0;
  List<Map<String, dynamic>> questions = [];
  TextEditingController _answerController = TextEditingController();
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _voiceInput = '';

  @override
  void initState() {
    super.initState();

    // Safely initialize questions list
    if (widget.interview['questions_and_answers'] != null) {
      questions = List<Map<String, dynamic>>.from(
          widget.interview['questions_and_answers']);
    } else {
      // Handle the case where questions_and_answers is null
      print("No questions available.");
    }

    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.interview["course_name"] ?? 'Interview'),
        ),
        body: Center(
          child: Text('No questions available for this interview.'),
        ),
      );
    }
    String _capitalizeWords(String input) {
      return input
          .split(' ')
          .map(
              (word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
          .join(' ');
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: _capitalizeWords(widget.interview['course_name']) + " Interview",
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question ${currentQuestionIndex + 1}/${questions.length}',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              questions[currentQuestionIndex]['question'],
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ..._buildAnswerOptions(),
            SizedBox(height: 20),
            TextField(
              controller: _answerController,
              decoration: InputDecoration(
                labelText: 'Your Answer',
                suffixIcon: IconButton(
                  icon: Icon(Icons.mic),
                  onPressed: _listen,
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Conditionally render the "Previous Question" button
                if (questions.length > 1 && currentQuestionIndex > 0)
                  ElevatedButton(
                    onPressed: _prevQuestion,
                    child: Text('Prev'),
                  ),
                ElevatedButton(
                  onPressed: _submitAnswer,
                  child: Text(currentQuestionIndex < questions.length - 1
                      ? 'Next'
                      : 'Finish'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildAnswerOptions() {
    // Safely retrieve the options for the current question
    List<String> options = List<String>.from(
      questions[currentQuestionIndex]['answers'] ?? [],
    );

    // Labels for options (A, B, C)
    List<String> optionLabels = ['A', 'B', 'C'];

    // Combine labels with options
    return options.asMap().entries.map((entry) {
      int idx = entry.key;
      String option = entry.value;
      String label = optionLabels[idx];

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            Text(
              '$label. ', // Display label (A, B, C)
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Text(
                option, // Display the actual option text
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _voiceInput = val.recognizedWords;
            _answerController.text = _voiceInput;
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _submitAnswer() {
    // Check the answer and update the score
    if (_answerController.text.trim().toLowerCase() ==
        questions[currentQuestionIndex]['correct_answer'].toLowerCase()) {
      correctAnswersCount++;
    }

    // Proceed to the next question or finish
    setState(() {
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
        _answerController.clear();
      } else {
        // Show result or end of quiz
        _showResult();
      }
    });
  }

  void _prevQuestion() {
    // Go to the previous question
    setState(() {
      if (currentQuestionIndex > 0) {
        currentQuestionIndex--;
        _answerController.clear();
      }
    });
  }

  void _showResult() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Interview Completed'),
          content: Text(
              'You got $correctAnswersCount out of ${questions.length} correct.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context)
                    .pop(); // Navigate back to the previous screen
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
