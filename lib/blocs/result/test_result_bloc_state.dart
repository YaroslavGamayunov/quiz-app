import 'package:quizapp/data/test_result_data.dart';

class TestResultBlocState {}

class TestResultLoadingState extends TestResultBlocState {}

class TestResultLoadedState extends TestResultBlocState {
  TestResultData resultData;

  TestResultLoadedState({required this.resultData});
}
