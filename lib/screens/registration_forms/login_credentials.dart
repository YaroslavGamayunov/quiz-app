import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pep/blocs/login_bloc.dart';
import 'package:pep/blocs/validation_state.dart';
import 'package:pep/constants.dart';
import 'package:pep/util/widgets.dart';

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
        body: BlocProvider<LoginBloc>(
            create: (BuildContext context) => _loginBloc,
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: 24),
                child: BlocBuilder<LoginBloc, ValidationState>(
                    bloc: _loginBloc,
                    builder: (context, state) {
                      return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Spacer(),
                            SizedBox(height: 48),
                            ConstrainedBox(
                                constraints: BoxConstraints(minHeight: 300),
                                child: _form(context, state)),
                            Spacer(),
                            PepButton(
                                title: state is NeedsRegistration
                                    ? "Зарегистрироваться"
                                    : "Продолжить",
                                onTap: () => {
                                      if (state is NeedsRegistration)
                                        {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      RegistrationFlowPage()))
                                        }
                                      else
                                        {
                                          // TODO: Log in
                                        }
                                    }),
                            SizedBox(height: 80),
                          ]);
                    }))));
  }

  Widget _form(BuildContext context, ValidationState state) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "Вход",
          style: Theme.of(context)
              .textTheme
              .headline1!
              .copyWith(color: Colors.black),
        ),
        SizedBox(height: 32),
        PepFormField(
          controller: _emailController,
          hint: "Введите Email",
        ),
        Visibility(
            visible: (state is! IncorrectEmail && state is! NeedsRegistration),
            child: Container(
              margin: EdgeInsets.only(top: 24),
              child: PepFormField(
                  controller: _passwordController,
                  hint: "Введите пароль",
                  obscureText: true),
            )),
        SizedBox(height: 24),
        Text((state is Incorrect ? state.errorMessage : ""),
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(color: kPrimaryColor))
      ]);

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
