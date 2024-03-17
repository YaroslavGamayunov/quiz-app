import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:quizapp/blocs/test/test_bloc_state.dart';
import 'package:quizapp/data/questions.dart';

TestFinished getTestResultByAnswers(
    List<Question> questions, List<dynamic> answers, List<int> times) {
  int correct = Random.secure().nextInt(answers.length);
  int time = 0;
  int percent = 0;
  List<QuestionAnswerResult> res = [];
  for (int i = 0; i < answers.length; i++) {
    time += times[i];
    int p = i < correct ? 100 : Random.secure().nextInt(95);
    res.add(QuestionAnswerResult(time: times[i], percent: p));
    percent += p;
  }
  return TestFinished(
      testId: UniqueKey().toString(),
      testDate: DateTime.now(),
      correctAnswers: correct,
      time: time,
      answers: res,
      percent: ((percent / (answers.length * 100)) * 100).toInt());
}
