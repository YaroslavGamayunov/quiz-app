import 'package:flutter/material.dart';
import 'package:quizapp/screens/test_result.dart';
import 'package:quizapp/widgets.dart';

import '../constants.dart';
import '../data/test_result_data.dart';

class TestFinishedMessagePage extends StatelessWidget {
  final NotValidatedTestData data;

  TestFinishedMessagePage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            margin: EdgeInsets.symmetric(horizontal: 24),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(height: 24),
              LinearProgressIndicator(
                color: kPrimaryColor,
                backgroundColor: kInputBackgroundColor,
                minHeight: 5.0,
                value: 1.0,
              ),
              SizedBox(height: 16),
              Text('Вопрос ${data.answers.length}/${data.answers.length}',
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
                            TestResultPage.forNotValidatedData(
                                notValidatedData: data)));
                  }),
              SizedBox(height: 24)
            ])));
  }
}
