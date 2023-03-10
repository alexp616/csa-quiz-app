import 'package:csa_quiz_app/datastructures/topic.dart';
import 'package:csa_quiz_app/auth.dart';
import 'package:csa_quiz_app/pages/quiz_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csa_quiz_app/datastructures/question.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:csa_quiz_app/pages/checkbox.dart';
import 'package:csa_quiz_app/pages/counter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  // final Auth auth = Auth();
  List<Topic> topics = [
    Topic('Primitive Types'),
    Topic('Using Objects'),
    Topic('Control Flow'),
    Topic('Iteration'),
    Topic('Writing Classes'),
    Topic('Array'),
    Topic('ArrayList'),
    Topic('2D Array'),
    Topic('Inheritance'),
    Topic('Recursion')
  ];

  final CollectionReference _questionsCollection = FirebaseFirestore.instance.collection('questions');
  
  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _signOutButton() {
    return ElevatedButton(
      onPressed: signOut,
      child: const Text('Sign Out')
    );
  }

  Future<List<double>> getData() async {
    QuerySnapshot querySnapshot = await _questionsCollection.get();
    for (var doc in querySnapshot.docs) {
      Question q = Question.fromDoc(doc);
      topics.firstWhere((t) => t.name == q.topic)
        .addQuestion(q);
    }

    List<Question> finished = [];

    try {
      DocumentSnapshot user = await auth.allUsers.doc(auth.currentUser!.uid).get();
      for (var map in user.get('finishedQuestions')) {
        Question fq = Question.fromMap(map);
        
        finished.add(fq);
        topics.firstWhere((t) => t.name == fq.topic)
          .addCompleted(fq);
      }
    } catch (e) { /* */ }

    var snapshot = await auth.allUsers.get();
    return [for (var doc in snapshot.docs) doc.get('progress')];
  }

  Widget buildTopic(Topic topic) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(topic.name),
          ),
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: CircularPercentIndicator(
              radius: 30.0,
              lineWidth: 5.0,
              percent: topic.percent,
              center: Text('${(topic.percent * 100).toStringAsFixed(1)}%'),
              backgroundColor: Colors.red,
              progressColor: Colors.green,
            ),
          )
        ],
      )
    );
  }

  Widget buildTopicsList() {
    List<Widget> widgets = [];

    for (Topic topic in topics) {
      widgets.add(buildTopic(topic));
    }
    
    return Column(
      children: widgets
    );
  }

  Widget quizButton() {
    CounterController lengthController = CounterController();
    List<CheckboxController> topicControllers = [for (Topic t in topics) CheckboxController()];
    CheckboxController reuseController = CheckboxController();

    return ElevatedButton(
      child: const Text('Start Quiz'),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              scrollable: true,
              title: const Text('Quiz Options'),
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  child: Column(
                    children: [
                      const Text('Include Topics:'),
                      Column(
                        children: [
                          for (int i = 0; i < topics.length; i++)
                          CustomCheckbox(
                            title: topics[i].name,
                            controller: topicControllers[i],
                          )
                        ],
                      ),
                      CustomCounter(
                        title: 'Quiz Length:',
                        controller: lengthController,
                      ),
                      CustomCheckbox(
                        title: 'Answered Questions?',
                        controller: reuseController,
                      )
                    ],
                  ),
                )
              ),
              actions: [
                ElevatedButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.pop(context)
                ),
                ElevatedButton(
                  child: const Text('Begin'),
                  onPressed: () {
                    int length = lengthController.length;
                    bool reuse = reuseController.isChecked;
                    List<Topic> include = [];
                    
                    for (int i = 0; i < topics.length; i++) {
                      if (topicControllers[i].isChecked) {
                        include.add(topics[i]);
                      }
                    }
                    
                    Navigator.push(context, 
                      MaterialPageRoute(builder: (context) => QuizPage.withOptions(length, reuse, include))
                    );
                  },
                )
              ],
            );
          }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          double progress = [for (Topic t in topics) t.percent].fold(0.0, (a, b) => a + b) / 10;
          List<double> values = snapshot.data ?? [];
          values.sort();
          values = values.reversed.toList();

          int rank = 1;
          for (int i = 0; i < values.length; i++) {
            if (values[i] <= progress) {
              rank = i + 1;
              break;
            }
          }

          auth.allUsers.doc(auth.currentUser!.uid).update({ 'progress': progress });

          return Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(8),
              child: AppBar(),
            ),
            body: ListView(
              children: [
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Rank: $rank'),
                    CircularPercentIndicator(
                      radius: 80.0,
                      lineWidth: 5.0,
                      percent: progress,
                      center: Text('${(progress * 100).toStringAsFixed(2)}%'),
                      progressColor: Colors.green,
                    ),
                    Column(
                      children: [
                        quizButton(),
                        SizedBox(height: 5),
                        _signOutButton()
                      ]
                    )
                  ],
                ),
                buildTopicsList()
              ]
            )
          );
        } else {
          return Scaffold(
            body: Column(
              children: const [
                Text('Fetching Problems...', textScaleFactor: 5),
                CircularProgressIndicator()
              ],
            )
          );
        }
      }
    );
  }
}
