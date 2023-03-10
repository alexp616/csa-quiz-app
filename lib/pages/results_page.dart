import 'package:csa_quiz_app/pages/home_page.dart';
import 'package:flutter/material.dart';
import '../datastructures/question.dart';

class ResultsPage extends StatelessWidget {
  final List<Question> incorrectQuestions;

  ResultsPage({
    Key? key,
    required this.incorrectQuestions
  }) : super(key: key);

  Widget buildIncorrectResults() {
    List<Widget> widgets = [];
    for (int i = 0; i < incorrectQuestions.length; i += 1) {
      widgets.add(Text(incorrectQuestions[i].text));
      widgets.add(const SizedBox(height: 4));
      widgets.add(Text(incorrectQuestions[i].code));
      widgets.add(const SizedBox(height: 4));
      widgets.add(answers(incorrectQuestions[i]));
      widgets.add(const SizedBox(height: 50));
    }

    return Column(
      children: widgets
    );
  }

  Widget answers(Question q) {
    List<Widget> widgets = [];
    q.answers.forEach((k, v) => {
      widgets.add(Text(k))
    });
    return Column(
      children: widgets
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text('You had: ${incorrectQuestions.length} incorrect answers.'),
            Text('Review these questions:'),
            buildIncorrectResults(),
            ElevatedButton(
              onPressed: () {
                void callback() {
                  Navigator.push(context, 
                    MaterialPageRoute(builder: (context) => HomePage())
                  );
                }
                callback();
              },
              child: Text('Return to Dashboard')
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom)
          ],
        ),
      ),
    );
  }
}