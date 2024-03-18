import 'package:equatable/equatable.dart';
import 'package:quizapp/data/test_result_data.dart';

import '../../data/questions.dart';

class TestBlocState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialState extends TestBlocState {}

class TestAvailable extends TestBlocState {}

class TestLoading extends TestBlocState {}

class TestFinished extends TestBlocState {
  final NotValidatedTestData testData;

  TestFinished({required this.testData});

  @override
  List<Object?> get props => [testData.testId];
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
