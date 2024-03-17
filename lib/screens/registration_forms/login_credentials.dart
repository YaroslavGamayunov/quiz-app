import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizapp/blocs/auth/login_bloc.dart';
import 'package:quizapp/constants.dart';
import 'package:quizapp/screens/home.dart';
import 'package:quizapp/util/widgets.dart';

import '../../blocs/auth/validation_state.dart';
import '../registration_flow.dart';

class LoginCredentialsForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginState();
}

class LoginState extends State<LoginCredentialsForm> {
  LoginBloc _loginBloc = LoginBloc(Incorrect(errorMessage: ''));
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _emailController.addListener(() {
      _loginBloc.validateEmail(_emailController.text);
    });

    _passwordController.addListener(() {
      _loginBloc.validatePassword(_passwordController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer<LoginBloc, ValidationState>(
            listener: (context, state) => {
                  if (state is LoggedIn)
                    {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => HomePage()),
                          (route) => false)
                    }
                },
            bloc: _loginBloc,
            builder: (BuildContext context, state) => Container(
                margin: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Spacer(),
                      SizedBox(height: 48),
                      ConstrainedBox(
                          constraints: BoxConstraints(minHeight: 300),
                          child: _form(context, state)),
                      Spacer(),
                      QuizAppButton(
                          title: state is NeedsRegistration
                              ? "Зарегистрироваться"
                              : "Продолжить",
                          onTap: () => {
                                if (state is NeedsRegistration)
                                  {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RegistrationFlowPage(
                                                    initialData: {
                                                      'email':
                                                          _emailController.text
                                                    })))
                                  }
                                else
                                  _loginBloc.logIn()
                              }),
                      SizedBox(height: 80),
                    ]))));
  }

  Widget _form(BuildContext context, ValidationState state) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "Вход",
          style: Theme.of(context)
              .textTheme
              .displayLarge!
              .copyWith(color: Colors.black),
        ),
        SizedBox(height: 32),
        QuizAppFormField(
          controller: _emailController,
          hint: "Введите Email",
        ),
        Visibility(
            visible: (state is! IncorrectEmail && state is! NeedsRegistration),
            child: Container(
              margin: EdgeInsets.only(top: 24),
              child: QuizAppFormField(
                  controller: _passwordController,
                  hint: "Введите пароль",
                  obscureText: true),
            )),
        SizedBox(height: 24),
        Text((state is Incorrect ? state.errorMessage : ""),
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: kPrimaryColor))
      ]);

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
