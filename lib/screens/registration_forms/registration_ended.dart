import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pep/util/widgets.dart';

class RegistrationEnded extends StatelessWidget {
  final Function() onContinue;

  RegistrationEnded({required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return PepRegistrationForm(
        body: Column(children: [
          SizedBox(height: 48),
          Text(
            "Регистрация завершена!",
            style: Theme.of(context)
                .textTheme
                .headline1!
                .copyWith(color: Colors.black),
          )
        ], crossAxisAlignment: CrossAxisAlignment.start),
        onContinue: onContinue);
  }
}
