import 'package:csa_quiz_app/datastructures/question.dart';
import 'package:csa_quiz_app/datastructures/student.dart';

class Topic {
  final String name;
  List<Question> questions = [];
  List<Question> completed = [];
  
  double get percent => (questions.isNotEmpty) ? completed.length / questions.length : 0;
  Topic(this.name);

  addQuestion(Question q) {
    questions.add(q);
  }

  addCompleted(Question q) {
    completed.add(q);
  }
}