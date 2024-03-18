import 'package:quizapp/data/test_result_data.dart';

class TestStatisticsBlocState {}

class StatisticsLoadingState extends TestStatisticsBlocState {}

class StatisticsLoadedState extends TestStatisticsBlocState {
  final List<TestResultData> results;
  final TestResultData? bestResult;

  StatisticsLoadedState({required this.results, required this.bestResult});
}
