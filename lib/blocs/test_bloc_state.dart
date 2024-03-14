import 'package:equatable/equatable.dart';

import '../questions.dart';

class TestBlocState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialState extends TestBlocState {}

class TestAvailable extends TestBlocState {
  final DateTime testStartDate;

  TestAvailable({required this.testStartDate});

  @override
  List<Object?> get props => [testStartDate];
}

class TestFinished extends TestBlocState {
  final int correctAnswers;
  final int incorrectAnswers;
  final int time;

  TestFinished(
      {required this.correctAnswers,
      required this.incorrectAnswers,
      required this.time});

  @override
  List<Object?> get props => [correctAnswers, incorrectAnswers, time];
}

class TestNotAvailable extends TestBlocState {}

class OnQuestion extends TestBlocState {
  final int index;
  final int total;
  final int timePassed;
  final Question question;

  OnQuestion(
      {required this.index,
      required this.total,
      required this.question,
      this.timePassed = 0});

  @override
  List<Object?> get props => [index, total, question, timePassed];

  OnQuestion copyWith({
    int? index,
    int? total,
    int? timePassed,
    Question? question,
  }) {
    return OnQuestion(
        index: index ?? this.index,
        total: total ?? this.total,
        timePassed: timePassed ?? this.timePassed,
        question: question ?? this.question);
  }
}
