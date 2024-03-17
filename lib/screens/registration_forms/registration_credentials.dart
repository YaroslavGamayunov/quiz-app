import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizapp/screens/registration_forms/registration_form.dart';
import 'package:quizapp/util/widgets.dart';

import '../../blocs/auth/registration_bloc.dart';
import '../../blocs/auth/registration_events.dart';
import '../../blocs/auth/validation_state.dart';
import '../../constants.dart';

class RegistrationCredentialsForm extends StatefulWidget {
  final Function() onContinue;

  RegistrationCredentialsForm({required this.onContinue});

  @override
  State<StatefulWidget> createState() => _RegistrationCredentialsFormState();
}

class _RegistrationCredentialsFormState
    extends State<RegistrationCredentialsForm> {
  late RegistrationFlowBloc _registrationBloc;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmationController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    _emailController.addListener(() {
      _registrationBloc
          .add(FormUpdateEvent(data: {'email': _emailController.text}));
      _registrationBloc.add(RegistrationFormSubmitEvent());
    });

    _passwordController.addListener(() {
      _registrationBloc.add(FormUpdateEvent(data: {
        'password': {
          'password': _passwordController.text,
          'confirmation': _passwordConfirmationController.text
        },
      }));
      _registrationBloc.add(RegistrationFormSubmitEvent());
    });

    _passwordConfirmationController.addListener(() {
      _registrationBloc.add(FormUpdateEvent(data: {
        'password': {
          'password': _passwordController.text,
          'confirmation': _passwordConfirmationController.text
        },
      }));
      _registrationBloc.add(RegistrationFormSubmitEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    _registrationBloc = BlocProvider.of<RegistrationFlowBloc>(context);
    return BlocBuilder<RegistrationFlowBloc, ValidationState>(
        bloc: _registrationBloc,
        builder: (context, state) {
          _emailController.text = _registrationBloc.userData['email'];
          return QuizAppRegistrationForm(
              body: _form(context, state), onContinue: widget.onContinue);
        });
  }

  Widget _form(BuildContext context, ValidationState state) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "Регистрация",
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
        SizedBox(height: 24),
        QuizAppFormField(
            controller: _passwordController,
            hint: "Введите пароль",
            obscureText: true),
        SizedBox(height: 24),
        QuizAppFormField(
            controller: _passwordConfirmationController,
            hint: "Подтвердите пароль",
            obscureText: true),
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
