import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizapp/blocs/auth/registration_events.dart';
import 'package:quizapp/screens/registration_forms/registration_form.dart';
import 'package:quizapp/widgets.dart';

import '../../blocs/auth/registration_bloc.dart';

class NameForm extends StatefulWidget {
  final Function() onContinue;

  NameForm({required this.onContinue});

  @override
  State<StatefulWidget> createState() => _NameFormState();
}

class _NameFormState extends State<NameForm> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController secondNameController = TextEditingController();

  late RegistrationFlowBloc _registrationBloc;

  @override
  void initState() {
    super.initState();
    _registrationBloc = BlocProvider.of<RegistrationFlowBloc>(context);
    firstNameController.addListener(() {
      _registrationBloc
          .add(FormUpdateEvent(data: {'name': firstNameController.text}));
      _registrationBloc.add(NameFormSubmitEvent());
    });

    secondNameController.addListener(() {
      _registrationBloc.add(
          FormUpdateEvent(data: {'surname': secondNameController.text}));
      _registrationBloc.add(NameFormSubmitEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return QuizAppRegistrationForm(body: _form(), onContinue: widget.onContinue);
  }

  _form() => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Как вас зовут?",
              style: Theme.of(context)
                  .textTheme
                  .displayLarge!
                  .copyWith(color: Colors.black),
            ),
            SizedBox(height: 32),
            QuizAppFormField(hint: "Имя", controller: firstNameController),
            SizedBox(height: 24),
            QuizAppFormField(hint: "Фамилия", controller: secondNameController),
          ]);

  @override
  void dispose() {
    firstNameController.dispose();
    secondNameController.dispose();
    super.dispose();
  }
}
