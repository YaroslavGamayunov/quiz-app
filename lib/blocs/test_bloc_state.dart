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
  final Question question;

  OnQuestion(
      {required this.index, required this.total, required this.question});

  @override
  List<Object?> get props => [index, total, question];
}
