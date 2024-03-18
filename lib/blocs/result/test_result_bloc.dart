import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizapp/blocs/result/test_result_bloc_state.dart';
import 'package:quizapp/data/test_result_data.dart';

import '../test/test_answers_validation.dart';

class TestResultBloc extends Cubit<TestResultBlocState> {
  TestResultBloc() : super(TestResultLoadingState());

  TestResultBloc.alreadyValidated(TestResultData data)
      : super(TestResultLoadedState(resultData: data));

  void validate(NotValidatedTestData testData) {
    emit(TestResultLoadingState());
    final testResult = getTestResultByAnswers(
        testData.testId, testData.questions, testData.answers, testData.times);
    _uploadTestResult(testResult).then((_) {
      emit(TestResultLoadedState(resultData: testResult));
    });
  }

  Future<void> _uploadTestResult(TestResultData resultData) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final collection =
        FirebaseFirestore.instance.collection("/users/$userId/results");
    return collection.doc(resultData.testId).set(resultData.toJson());
  }
}
