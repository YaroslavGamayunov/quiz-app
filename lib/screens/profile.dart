import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quizapp/constants.dart';
import 'package:quizapp/screens/registration_forms/login_credentials.dart';
import 'package:quizapp/widgets.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: [
      SliverFillRemaining(
          hasScrollBody: false,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 48),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        FirebaseAuth.instance.currentUser?.displayName ??
                            "Пользователь",
                        textAlign: TextAlign.justify,
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge!
                            .copyWith(color: Colors.black),
                      ),
                    ),
                    SizedBox(width: 32)
                  ],
                ),
                SizedBox(height: 32),
                Text(
                  'Учетная запись',
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .copyWith(color: Colors.black),
                ),
                SizedBox(height: 16),
                Text(
                  FirebaseAuth.instance.currentUser?.email ?? "",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: kSecondaryTextColor),
                ),
                SizedBox(height: 42),
                QuizAppButton(
                    title: 'Выйти',
                    color: Color(0xffC30000),
                    onTap: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => LoginCredentialsForm()),
                          (route) => false);
                    })
              ],
            ),
          ))
    ]);
  }
}
