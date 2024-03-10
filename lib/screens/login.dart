import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pep/constants.dart';
import 'package:pep/screens/privacy_policy.dart';
import 'package:pep/screens/login_form.dart';
import 'package:pep/util/widgets.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          margin: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Spacer(),
              Text(
                "Вход",
                style: Theme.of(context)
                    .textTheme
                    .headline1!
                    .copyWith(color: Colors.black),
              ),
              SizedBox(height: 24),
              PepButton(
                title: "Войти через Google",
                onTap: () {
                  print("zxc");
                },
                icon: SvgPicture.asset("assets/ic_google.svg"),
              ),
              SizedBox(height: 16),
              PepButton(
                title: "Войти через Email",
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LoginForm()));
                },
                icon: null,
              ),
              Spacer(),
              Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(bottom: 32),
                  child: _PrivacyPolicy())
            ],
          )),
    );
  }
}

class _PrivacyPolicy extends StatelessWidget {
  const _PrivacyPolicy({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => PrivacyPolicy()));
        },
        child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: "Регистрируясь в сервисе, я соглашаюсь с\n",
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(color: kSecondaryTextColor),
                children: [
                  TextSpan(
                      text: "Политикой конфиденциальности",
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                          color: kSecondaryTextColor,
                          fontWeight: FontWeight.w700))
                ])));
  }
}
