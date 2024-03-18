import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quizapp/data/questions.dart';

class TestResultData {
  final DateTime testDate;
  final String testId;
  final int correctAnswers;
  final int percent;
  final int time;
  final List<QuestionAnswerResult> answers;

  TestResultData(
      {required this.testDate,
      required this.testId,
      required this.correctAnswers,
      required this.percent,
      required this.time,
      required this.answers});

  TestResultData.fromDocument(QueryDocumentSnapshot doc)
      : testDate = (doc['testDate'] as Timestamp).toDate(),
        testId = doc.id,
        correctAnswers = doc['correctAnswers'],
        percent = doc['percent'],
        time = doc['time'],
        answers = jsonDecode(doc['answers'])
            .map<QuestionAnswerResult>(
                (answerJson) => QuestionAnswerResult.fromJson(answerJson))
            .toList();

  Map<String, dynamic> toJson() {
    return {
      'testDate': testDate,
      'correctAnswers': correctAnswers,
      'percent': percent,
      'time': time,
      'answers': jsonEncode(answers.map((answer) => answer.toJson()).toList())
    };
  }
}

class QuestionAnswerResult {
  final int time;
  final int percent;

  QuestionAnswerResult({required this.time, required this.percent});

  QuestionAnswerResult.fromJson(Map<String, dynamic> json)
      : time = json['time'],
        percent = json['percent'];

  Map<String, dynamic> toJson() => {'time': time, 'percent': time};
}

class NotValidatedTestData {
  final String testId;
  final List<Question> questions;
  final List<dynamic> answers;
  final List<int> times;

  NotValidatedTestData(
      {required this.testId,
        required this.questions,
        required this.answers,
        required this.times});
}
