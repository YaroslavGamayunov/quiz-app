import 'package:flutter/material.dart';
import 'package:quizapp/blocs/test/test_bloc_state.dart';

import '../constants.dart';
import '../util/widgets.dart';
import 'oncoming_test.dart';

class TestResultPage extends StatelessWidget {
  final TestFinished testResult;

  TestResultPage({required this.testResult});

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[buildAppBar(context)];
            },
            body: buildAnswersList()));
  }

  SliverAppBar buildAppBar(BuildContext context) {
    return SliverAppBar(
        pinned: true,
        expandedHeight: 250.0,
        title: Text("Результат"),
        flexibleSpace: FlexibleSpaceBar(
            background: Container(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("${testResult.percent}%",
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge!
                              .copyWith(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.w700)),
                      SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: testResult.percent / 100.0,
                        backgroundColor: kInputBackgroundColor,
                      ),
                      SizedBox(height: 24),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                                child: Text("Правильных ответов:",
                                    textAlign: TextAlign.start,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!)),
                            Flexible(
                                child: Text(
                              "Общее время выполнения:",
                              textAlign: TextAlign.end,
                              style: Theme.of(context).textTheme.bodyLarge!,
                            ))
                          ]),
                      SizedBox(height: 4),
                      Row(children: [
                        Text(
                            "${testResult.correctAnswers}/${testResult.answers.length}",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    color: kPrimaryColor,
                                    fontWeight: FontWeight.w700)),
                        Spacer(),
                        Text("${testResult.time} сек",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    color: kPrimaryColor,
                                    fontWeight: FontWeight.w700))
                      ]),
                    ]))));
  }

  Widget buildAnswersList() {
    return ListView.builder(
        itemCount: testResult.answers.length + 1,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        itemBuilder: (BuildContext context, int index) {
          if (index == testResult.answers.length) {
            return Padding(
                padding: EdgeInsets.only(top: 32),
                child: QuizAppButton(
                    title: "Перейти к тестам",
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => OncomingTestPage()));
                    }));
          }
          return Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: _AnswerItemWidget(
                  context,
                  index,
                  testResult.answers[index].time,
                  testResult.answers[index].percent));
        });
  }
}

Widget _AnswerItemWidget(
    BuildContext context, int questionNumber, int time, int percent) {
  return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Color(0x1a000000),
            blurRadius: 10,
            spreadRadius: 0,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(children: [
          Text("Вопрос $questionNumber",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: kSecondaryTextColor)),
          Spacer(),
          Text("$time сек",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: kPrimaryColor, fontWeight: FontWeight.w700)),
          SizedBox(
              height: 24,
              child: VerticalDivider(
                thickness: 1,
                width: 10,
                color: kSecondaryTextColor,
              )),
          Text("$percent%",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: kPrimaryColor, fontWeight: FontWeight.w700))
        ]),
      ));
}
