import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pep/util/widgets.dart';

import '../constants.dart';

class TestFinishedPage extends StatelessWidget {
  final int countOfQuestions;

  TestFinishedPage({required this.countOfQuestions});

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
          Text('Вопрос $countOfQuestions/$countOfQuestions',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: kSecondaryTextColor)),
          SizedBox(height: 32),
          Text("Вы завершили тест!",
              style: Theme.of(context)
                  .textTheme
                  .headline1!
                  .copyWith(color: Colors.black)),
          Spacer(),
          PepButton(title: "Узнать результат", onTap: () {}),
          SizedBox(height: 24)
        ]));
  }
}
