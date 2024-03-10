import 'package:flutter/material.dart';
import 'package:pep/util/widgets.dart';

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            margin: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Spacer(),
                  Text(
                    "Вход",
                    style: Theme.of(context)
                        .textTheme
                        .headline1!
                        .copyWith(color: Colors.black),
                  ),
                  SizedBox(height: 32),
                  PepFormField(
                    hint: "Введите Email",
                    validator: (email) {
                      if (email != "aaa")
                        return "incorrect email";
                      else
                        return null;
                    },
                  ),
                  Spacer(),
                  PepButton(title: "Продолжить", onTap: () => {}),
                  SizedBox(height: 80)
                ])));
  }
}
