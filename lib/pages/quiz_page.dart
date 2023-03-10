import 'package:csa_quiz_app/auth.dart';
import 'package:csa_quiz_app/datastructures/question.dart';
import 'package:csa_quiz_app/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'dart:collection';
import 'package:csa_quiz_app/pages/results_page.dart';

import '../datastructures/topic.dart';

class QuizPage extends StatelessWidget {
  final List<Question> quizQuestions;
  static late List<String?> answers;
  late List<Question> incorrectQuestions;
  QuizPage({
    Key? key,
    required this.quizQuestions
  }) : super(key: key) {
    answers = List.filled(quizQuestions.length, null);
  }

  factory QuizPage.withOptions(int quizLength, bool reuseAnswered, List<Topic> includeTopics) {
    List<Question> allQuestions = [];

    for (Topic topic in includeTopics) {
      for (Question question in topic.questions) {
        if ((reuseAnswered || !topic.completed.contains(question)) && allQuestions.length < quizLength) {
          allQuestions.add(question);
        }
      }
    }

    return QuizPage(quizQuestions: allQuestions);
  }

  void submitQuiz() async {
    List<Question> correctQuestions = [];
    List<Question> incorrectQuestions1 = [];

    for (int i = 0; i < quizQuestions.length; i++) {
      if (quizQuestions[i].answers[answers[i]]?.toString().toLowerCase() == 'true') {
        correctQuestions.add(quizQuestions[i]);
      } else {
        incorrectQuestions1.add(quizQuestions[i]);
      }
    }
    print(correctQuestions);
    print(incorrectQuestions1);

    incorrectQuestions = incorrectQuestions1;
    List<Question> finished = List<Question>.from(correctQuestions)
      ..addAll([for (var doc in (await auth.allUsers.doc(auth.currentUser!.uid).get()).get('finishedQuestions')) Question.fromDoc(doc)]);

    await auth.allUsers.doc(auth.currentUser!.uid).update({'finishedQuestions': [for (Question q in finished) q.toMap()]});
  }

  Widget buildQuiz() {
    List<Widget> widgets = [];

    for (int i = 0; i < quizQuestions.length; i += 1) {
      widgets.add(Text(quizQuestions[i].text));
      widgets.add(const SizedBox(height: 4));
      widgets.add(Text(quizQuestions[i].code));
      widgets.add(const SizedBox(height: 4));
      widgets.add(AnswerList(answerChoices: quizQuestions[i].answers, questionIndex: i));
      widgets.add(const SizedBox(height: 50));
    }

    return SingleChildScrollView(
      physics: const ScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widgets,
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, 
                  MaterialPageRoute(builder: (context) => HomePage())
                );
              },
              child: Text('Back')
            ),
            buildQuiz(),
            ElevatedButton(
              onPressed: () {
                void callback() {
                  submitQuiz();
                  Navigator.push(context, 
                    MaterialPageRoute(builder: (context) => ResultsPage(incorrectQuestions: incorrectQuestions))
                  );
                }
                callback();
              },
              child: Text('Submit')
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom)
          ],
        ),
      ),
    );
  }
}

class AnswerList extends StatefulWidget {
  LinkedHashMap<String, dynamic> answerChoices;
  int questionIndex;

  AnswerList({
    Key? key,
    required this.answerChoices,
    required this.questionIndex
    }) : super(key: key);

  @override
  State<AnswerList> createState() => _AnswerListState();
}

class _AnswerListState extends State<AnswerList> {
  String? _selectedItem;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.answerChoices.length,
      itemBuilder: (BuildContext context, int index) {
        final MapEntry<String, dynamic> entry = widget.answerChoices.entries.elementAt(index);
        return RadioListTile(
          title: Text(entry.key),
          value: entry.key,
          groupValue: _selectedItem,
          onChanged: (String? value) {
            setState(() {
              _selectedItem = value;
              QuizPage.answers[widget.questionIndex] = _selectedItem;
              print(QuizPage.answers);
            });
          },
        );
      }
    );
  }
}