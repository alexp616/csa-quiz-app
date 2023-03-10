import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';

class Question {
  String topic;
  String text;
  String code;
  LinkedHashMap<String, dynamic> answers;

  Question(this.topic, this.text, this.code, this.answers);

  factory Question.fromDoc(QueryDocumentSnapshot doc) {
    return Question(
      doc.get('topic') as String,
      doc.get('text') as String,
      Uri.decodeFull(doc.get('code')),
      doc.get('answers') as LinkedHashMap<String, dynamic>
    );
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      map['topic'] as String,
      map['text'] as String,
      Uri.decodeFull(map['code']),
      map['answers'] as LinkedHashMap<String, dynamic>
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'topic': topic,
      'text': text,
      'code': Uri.encodeFull(code),
      'answers': answers
    };
  }
}