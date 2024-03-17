import 'package:flutter/material.dart';
import 'package:quizapp/screens/registration_forms/registration_form.dart';

import '../../constants.dart';

class EmailCodeSent extends StatelessWidget {
  final String Function() email;
  final Function() onContinue;

  EmailCodeSent({required this.email, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return QuizAppRegistrationForm(body: _form(context), onContinue: onContinue);
  }

  Widget _form(context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "Регистрация",
          style: Theme.of(context)
              .textTheme
              .displayLarge!
              .copyWith(color: Colors.black),
        ),
        SizedBox(height: 32),
        Text("На ваш электронный адрес ${email()} отправлен код подтверждения",
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: kPrimaryColor)),
      ]);
}
