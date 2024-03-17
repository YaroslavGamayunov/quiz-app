import 'package:flutter/material.dart';

import '../../util/widgets.dart';

class QuizAppRegistrationForm extends StatelessWidget {
  final Widget body;
  final Function() onContinue;

  QuizAppRegistrationForm({required this.body, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: [
      SliverFillRemaining(
          hasScrollBody: false,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(children: [
              SizedBox(height: 32),
              body,
              SizedBox(height: 32),
              Spacer(),
              QuizAppButton(title: "Продолжить", onTap: onContinue),
              SizedBox(height: 80)
            ]),
          ))
    ]);
  }
}
