import 'package:flutter/material.dart';
import 'package:quizapp/screens/test_result.dart';
import 'package:quizapp/util/widgets.dart';

import '../blocs/test/test_bloc_state.dart';
import '../constants.dart';

class TestFinishedMessagePage extends StatelessWidget {
  final TestFinished testResult;

  TestFinishedMessagePage({required this.testResult});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(height: 24),
          LinearProgressIndicator(
            color: kPrimaryColor,
            backgroundColor: kInputBackgroundColor,
            minHeight: 5.0,
            value: 1.0,
          ),
          SizedBox(height: 16),
          Text(
              'Вопрос ${testResult.answers.length}/${testResult.answers.length}',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: kSecondaryTextColor)),
          SizedBox(height: 32),
          Text("Вы завершили тест!",
              style: Theme.of(context)
                  .textTheme
                  .displayLarge!
                  .copyWith(color: Colors.black)),
          Spacer(),
          QuizAppButton(
              title: "Узнать результат",
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        TestResultPage(testResult: this.testResult)));
              }),
          SizedBox(height: 24)
        ]));
  }
}
