import 'dart:collection';

class Question {
  String id;
  String topic;
  String code;
  LinkedHashMap<String, dynamic> answers;
  int numAnswered;
  int numCorrect;
  int averageTime;

  Question(this.id, this.topic, this.code, this.answers, this.numAnswered, this.numCorrect, this.averageTime);

}