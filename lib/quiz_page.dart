import 'package:flutter/material.dart';
import 'package:untitled/ques_database';
import 'result_page.dart';

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}
final db =DBHelper();
bool _isLoading = true;
class _QuizPageState extends State<QuizPage> {
   List<Map<String, dynamic>> _questions = [];
   @override
  void initState() {
    super.initState();
    _loadQuestions();
  }
void _loadQuestions()async {

  final questions=await db.getQuestions();
  setState(() {
   _questions=questions;
   _isLoading = false;
  });
}
  int _currentIndex = 0;
  int _score = 0;
  String? _selectedOption;

  void _nextQuestion() {
    if (_selectedOption == _questions[_currentIndex]['answer']) {
      _score++;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Correct!"),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Wrong!"),
          backgroundColor: Colors.red,
        ),
      );
    }
    setState(() {
      _currentIndex++;
      _selectedOption = null;
      
    });

    if (_currentIndex >= _questions.length) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultPage(score: _score, total: _questions.length),
        ),
      );
    }
  }

  void _prevQuestion() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _selectedOption = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.tealAccent),
        ),
      );
    }
     if (_currentIndex >= _questions.length) {
    return Scaffold(
      body: Center(
        child: Text(
          "No more questions available.",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }

  final question = _questions[_currentIndex];


    final options = [
  question['option1'],
  question['option2'],
  question['option3'],
  question['option4'],
];

  
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quiz App"),
        backgroundColor: Color(0xFF1E1E1E),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Color.fromARGB(255, 5, 0, 0),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Q${_currentIndex + 1}. ${question['question']}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ...options.map((opt) => InkWell(
                      onTap: () {
                        setState(() {
                          _selectedOption = opt;
                        });
                      },
                      child: Card(
                        child: ListTile(
                              title: Text(
                                opt,
                                style: const TextStyle(color: Colors.white),
                              ),
                              leading: Radio<String>(
                                value: opt,
                                groupValue: _selectedOption,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedOption = value;
                                  });
                                },
                                activeColor: const Color.fromARGB(255, 151, 151, 151),
                              ),
                            ),
                      ),
                    )),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _prevQuestion,
                  child: const Text("Previous"),
                ),
                ElevatedButton(
                  onPressed: _selectedOption != null ? _nextQuestion : null,
                  child: Text(
                      _currentIndex == _questions.length - 1 ? "Finish" : "Next"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}


