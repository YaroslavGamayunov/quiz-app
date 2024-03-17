import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizapp/blocs/test/test_answers_validation.dart';
import 'package:quizapp/blocs/test/test_bloc_state.dart';
import 'package:quizapp/blocs/test/test_questions_preloading.dart';
import 'package:quizapp/data/questions.dart';

class TestBloc extends Cubit<TestBlocState> {
  TestBloc() : super(InitialState());

  List<Question> _testQuestions = [];
  List<dynamic> _userTestAnswers = [];
  List<int> _answerTimes = [];

  Timer? _timer;

  void answerCurrentQuestion(dynamic answer) {
    _timer?.cancel();
    if (state is OnQuestion) {
      int currentId = (state as OnQuestion).index;
      _userTestAnswers[currentId] = answer;
      if (currentId + 1 < _userTestAnswers.length) {
        _startQuestion(index: ++currentId);
      } else {
        emit(getTestResultByAnswers(
            _testQuestions, _userTestAnswers, _answerTimes));
      }
    }
  }

  void _startQuestion({required int index}) {
    developer.log("Started question #${index}", name: "TestBloc");
    var testState = OnQuestion(
        total: _testQuestions.length,
        index: index,
        question: _testQuestions[index]);
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      emit(testState.copyWith(timePassed: _answerTimes[index]++));
    });
  }

  void loadCurrentTest() {
    _testQuestions.clear();
    emit(TestLoading());
    final allTests = FirebaseFirestore.instance.collection("/test");
    allTests
        .get()
        .then((snapshot) {
          final doc = snapshot.docs[0];
          developer.log("loaded doc: $doc", name: "TestBloc");
          final questions = parseTestQuestions(doc['data']);
          _testQuestions = questions;
          developer.log("loaded doc: $doc", name: "TestBloc");
          return questions;
        })
        .then(preloadQuestionData)
        .then((_) {
          emit(TestAvailable());
        })
        .onError((error, stackTrace) {
          developer.log("Error while loading test",
              name: "TestBloc", error: error);
          emit(TestNotAvailable());
        });
  }

  List<Question> parseTestQuestions(String testQuestionsString) {
    final testQuestionsJson = jsonDecode(testQuestionsString);
    List<Question> questions = [];
    for (var questionJson in testQuestionsJson) {
      Map<String, dynamic> questionData =
          questionJson['questionData'] as Map<String, dynamic>;

      Question? question;
      switch (questionJson['type']) {
        case 'binary':
          question = BinaryAnswerQuestion.fromJson(questionData);
          break;
        case 'remember':
          question = RememberWordsQuestion.fromJson(questionData);
          break;
        case 'writing_answer':
          question = WritingAnswerQuestion.fromJson(questionData);
          break;
        case 'image_matching':
          question = ImageMatchingQuestion.fromJson(questionData);
          break;
        case 'schulte':
          question = SchulteTableQuestion.fromJson(questionData);
          break;
        case 'number_connection':
          question = NumberConnectionQuestion.fromJson(questionData);
          break;
        case 'point_connection':
          question = PointConnectionQuestion.fromJson(questionData);
          break;
        case 'image_puzzle':
          question = ImagePuzzleQuestion.fromJson(questionData);
          break;
      }

      if (question != null) questions.add(question);
    }

    return questions;
  }

  void startCurrentTest() {
    _timer?.cancel();
    _userTestAnswers =
        List.filled(_testQuestions.length, null, growable: false);
    _answerTimes = List.filled(_testQuestions.length, 0);
    if (_testQuestions.isNotEmpty) {
      _startQuestion(index: 0);
    }
  }
}
