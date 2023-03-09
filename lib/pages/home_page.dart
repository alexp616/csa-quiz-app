import 'package:firebase_auth/firebase_auth.dart';
import 'package:csa_quiz_app/auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csa_quiz_app/datastructures/question.dart';
import 'package:percent_indicator/percent_indicator.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _signOutButton() {
    return ElevatedButton(
      onPressed: signOut,
      child: const Text('Sign Out')
    );
  }

  CollectionReference _collectionRef = FirebaseFirestore.instance.collection('questions');

  List<Question> allQuestions = [];

  Future<String> getData() async {
    QuerySnapshot querySnapshot = await _collectionRef.get();

    for (var doc in querySnapshot.docs) {
      allQuestions.add(
        Question(
          doc.id,
          doc.get('topic'),
          doc.get('code'),
          doc.get('answers'),
          doc.get('numAnswered'),
          doc.get('numCorrect'),
          doc.get('averageTime')
        )
      );
    }
    return 'bob';
  }

  Widget buildTopicsList() {
    print('this ran');
    List<Widget> topicsList = [
      Text('temptopic1'),
      Text('temptopic2')
    ];
    
    return Column(
      children: topicsList
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: Text('quiz app')
            ),
            body: ListView(
              children: [
                CircularPercentIndicator(

                  radius: 60.0,
                  lineWidth: 5.0,
                  percent: 0.34,
                  center: Text('change me'),
                  progressColor: Colors.green,
                ),
                Text('topics'),
                buildTopicsList()
              ]
            )
          );
        } else {
          return Column(
            children: const [
              Text('Fetching Problems...'),
              CircularProgressIndicator()
            ],
          );
        }
      }
    );
  }
}
