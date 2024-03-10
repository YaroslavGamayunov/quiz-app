import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
      body: Container(margin: EdgeInsets.symmetric(horizontal: 24), child:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Вход", style: Theme.of(context).textTheme.headline1!.copyWith(color: Colors.black),
            ),
            SizedBox(height: 24),
            PepButton(title: "Войти через Google", onTap: () { print("zxc"); }, icon: SvgPicture.asset("assets/ic_google.svg"),)
          ],
        )
      ),
    );
  }
}