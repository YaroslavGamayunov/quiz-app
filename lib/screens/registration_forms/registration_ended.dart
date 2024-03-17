import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizapp/blocs/auth/validation_state.dart';
import 'package:quizapp/screens/registration_forms/registration_form.dart';

import '../../blocs/auth/registration_bloc.dart';

class RegistrationEnded extends StatefulWidget {
  final Function() onContinue;

  RegistrationEnded({required this.onContinue});

  @override
  State<RegistrationEnded> createState() => _RegistrationEndedState();
}

class _RegistrationEndedState extends State<RegistrationEnded> {
  late RegistrationFlowBloc _registrationBloc;
  bool _isCorrect = true;

  @override
  void initState() {
    super.initState();
    _registrationBloc = BlocProvider.of<RegistrationFlowBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return QuizAppRegistrationForm(
        body: _buildFormBody(),
        onContinue: () {
          if (_isCorrect) {
            widget.onContinue.call();
          }
        });
  }

  Widget _buildFormBody() {
    return BlocConsumer<RegistrationFlowBloc, ValidationState>(
        bloc: _registrationBloc,
        builder: (context, state) {
          if (state is Correct) {
            return _buildSuccessfulResult(context);
          } else if (state is Incorrect) {
            return _buildFailedResult(context, state.errorMessage);
          }
          return Container(
            padding: EdgeInsets.all(32),
            child: CircularProgressIndicator(),
          );
        },
        listener: (BuildContext context, ValidationState state) {
          _isCorrect = ValidationState is Correct;
        });
  }

  Widget _buildSuccessfulResult(BuildContext context) {
    return Column(children: [
      SizedBox(height: 48),
      Text(
        "Регистрация завершена!",
        style: Theme.of(context)
            .textTheme
            .displayLarge!
            .copyWith(color: Colors.black),
      )
    ], crossAxisAlignment: CrossAxisAlignment.start);
  }

  Widget _buildFailedResult(BuildContext context, String message) {
    return Column(children: [
      SizedBox(height: 48),
      Text(
        message,
        style: Theme.of(context)
            .textTheme
            .displayLarge!
            .copyWith(color: Colors.black),
      )
    ], crossAxisAlignment: CrossAxisAlignment.start);
  }
}
