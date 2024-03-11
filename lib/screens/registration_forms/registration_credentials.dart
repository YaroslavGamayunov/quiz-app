import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pep/blocs/validation_state.dart';
import 'package:pep/util/widgets.dart';

import '../../constants.dart';
import '../../blocs/registration_bloc.dart';
import '../../blocs/registration_events.dart';

class RegistrationCredentialsForm extends StatefulWidget {
  final Function() onContinue;

  RegistrationCredentialsForm({required this.onContinue});

  @override
  State<StatefulWidget> createState() =>
      _RegistrationCredentialsFormState(onContinue: onContinue);
}

class _RegistrationCredentialsFormState
    extends State<RegistrationCredentialsForm> {
  late RegistrationFlowBloc _registrationBloc;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmationController =
      TextEditingController();

  Function() onContinue;

  _RegistrationCredentialsFormState({required this.onContinue});

  @override
  void initState() {
    super.initState();

    _emailController.addListener(() {
      _registrationBloc
          .add(FormUpdateEvent(data: {'email': _emailController.text}));
      _registrationBloc.add(RegistrationFormSubmitEvent());
    });

    _passwordController.addListener(() {
      _registrationBloc
          .add(FormUpdateEvent(data: {'password': _passwordController.text}));
      _registrationBloc.add(RegistrationFormSubmitEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    _registrationBloc = BlocProvider.of<RegistrationFlowBloc>(context);
    return Scaffold(
        body: Container(
            margin: EdgeInsets.symmetric(horizontal: 24),
            child: BlocBuilder<RegistrationFlowBloc, ValidationState>(
                bloc: _registrationBloc,
                builder: (context, state) {
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 48),
                        Text(
                          "Регистрация",
                          style: Theme.of(context)
                              .textTheme
                              .headline1!
                              .copyWith(color: Colors.black),
                        ),
                        Spacer(),
                        PepFormField(
                          controller: _emailController,
                          hint: "Введите Email",
                        ),
                        SizedBox(height: 24),
                        PepFormField(
                            controller: _passwordController,
                            hint: "Введите пароль",
                            obscureText: true),
                        SizedBox(height: 24),
                        PepFormField(
                            controller: _passwordConfirmationController,
                            hint: "Подтвердите пароль",
                            obscureText: true),
                        SizedBox(height: 24),
                        Text((state is Incorrect ? state.errorMessage : ""),
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(color: kPrimaryColor)),
                        Spacer(),
                        PepButton(
                          onTap: onContinue,
                          title: 'Продолжить',
                        ),
                        SizedBox(height: 32)
                      ]);
                })));
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
