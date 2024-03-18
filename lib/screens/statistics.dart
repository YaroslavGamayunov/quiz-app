import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:quizapp/blocs/statistics/test_statistics_bloc.dart';
import 'package:quizapp/blocs/statistics/test_statistics_bloc_state.dart';
import 'package:quizapp/constants.dart';
import 'package:quizapp/screens/test_result.dart';
import 'package:quizapp/widgets.dart';

import '../data/test_result_data.dart';

class StatisticsPage extends StatefulWidget {
  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  late TestStatisticsBloc _testStatisticsBloc;

  @override
  void initState() {
    _testStatisticsBloc = TestStatisticsBloc();
    _testStatisticsBloc.loadStatistics();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => _testStatisticsBloc,
        child: BlocConsumer<TestStatisticsBloc, TestStatisticsBlocState>(
          builder: (context, state) => state is StatisticsLoadedState
              ? _buildStatisticsResult(state.results, state.bestResult)
              : _buildLoadingState(),
          listener: (BuildContext context, TestStatisticsBlocState state) {},
        ));
  }

  Widget _buildLoadingState() {
    return Center(child: CircularProgressIndicator());
  }

  Widget _buildStatisticsResult(
      List<TestResultData> results, TestResultData? bestResult) {
    return RefreshIndicator(
        onRefresh: () {
          return _testStatisticsBloc.loadStatistics();
        },
        child: CustomScrollView(slivers: [
          SliverFillRemaining(
              hasScrollBody: false,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        _buildStatisticsList(context, results, bestResult)),
              ))
        ]));
  }

  List<Widget> _buildStatisticsList(BuildContext context,
      List<TestResultData> results, TestResultData? bestResult) {
    if (results.isEmpty) {
      return [
        Text(
          'Результатов пока нет :(',
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: kSecondaryTextColor),
        ),
      ];
    }

    List<Widget> list = [];

    if (bestResult != null) {
      list.add(SizedBox(height: 24));
      list.add(QuizAppTestResultCard(
          onClick: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => TestResultPage.forValidatedData(
                    validatedData: bestResult)));
          },
          resultPercent: bestResult.percent / 100,
          text: Text(
            'Лучший результат за все время: ',
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Colors.black),
          )));
    }

    list.add(SizedBox(height: 24));

    list.add(Text(
      'Последние результаты:',
      style: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(color: kSecondaryTextColor),
    ));

    list.add(SizedBox(height: 24));

    results.forEach((testResult) {
      list.add(QuizAppTestResultCard(
          resultPercent: testResult.percent / 100.0,
          onClick: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => TestResultPage.forValidatedData(
                    validatedData: testResult)));
          },
          text: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Результат',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Colors.black),
              ),
              Text(
                DateFormat.yMMMd().format(testResult.testDate),
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: kSecondaryTextColor),
              )
            ],
          )));
      list.add(SizedBox(height: 24));
    });

    return list;
  }
}
