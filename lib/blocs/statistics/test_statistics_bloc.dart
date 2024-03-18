import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizapp/blocs/statistics/test_statistics_bloc_state.dart';
import 'package:quizapp/data/test_result_data.dart';

class TestStatisticsBloc extends Cubit<TestStatisticsBlocState> {
  TestStatisticsBloc() : super(StatisticsLoadingState());

  Future<void> loadStatistics() async {
    emit(StatisticsLoadingState());
    List<TestResultData> results = await _loadStatisticsFromFirebase();
    TestResultData? bestRes = null;
    results.forEach((res) {
      if (bestRes == null || bestRes!.percent < res.percent) {
        bestRes = res;
      }
    });
    emit(StatisticsLoadedState(results: results, bestResult: bestRes));
  }

  Future<List<TestResultData>> _loadStatisticsFromFirebase() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final results =
    FirebaseFirestore.instance.collection("/users/$userId/results");
    QuerySnapshot snapshot = await results.get();
    return snapshot.docs
        .map((doc) => TestResultData.fromDocument(doc))
        .toList();
  }
}
