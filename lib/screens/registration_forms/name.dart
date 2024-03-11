import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pep/blocs/registration_bloc.dart';
import 'package:pep/blocs/registration_events.dart';
import 'package:pep/util/widgets.dart';

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
          .add(FormUpdateEvent(data: {'firstName': firstNameController.text}));
      _registrationBloc.add(NameFormSubmitEvent());
    });

    secondNameController.addListener(() {
      _registrationBloc.add(
          FormUpdateEvent(data: {'secondName': secondNameController.text}));
      _registrationBloc.add(NameFormSubmitEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return PepRegistrationForm(body: _form(), onContinue: widget.onContinue);
  }

  _form() => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Как вас зовут?",
              style: Theme.of(context)
                  .textTheme
                  .headline1!
                  .copyWith(color: Colors.black),
            ),
            SizedBox(height: 32),
            PepFormField(hint: "Имя", controller: firstNameController),
            SizedBox(height: 24),
            PepFormField(hint: "Фамилия", controller: secondNameController),
          ]);

  @override
  void dispose() {
    firstNameController.dispose();
    secondNameController.dispose();
    super.dispose();
  }
}
