import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pep/blocs/registration_bloc.dart';
import 'package:pep/blocs/registration_events.dart';
import 'package:pep/util/widgets.dart';

enum Gender { male, female }

class GenderForm extends StatefulWidget {
  final Function() onContinue;

  GenderForm({required this.onContinue});

  @override
  State createState() => GenderFormState();
}

class GenderFormState extends State<GenderForm> {
  late RegistrationFlowBloc _registrationBloc;
  Gender? _gender = Gender.male;

  @override
  void initState() {
    super.initState();
    _registrationBloc = BlocProvider.of<RegistrationFlowBloc>(context);
    _setGender(Gender.male);
  }

  @override
  Widget build(BuildContext context) {
    return PepRegistrationForm(
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "Укажите ваш пол",
            style: Theme.of(context)
                .textTheme
                .headline1!
                .copyWith(color: Colors.black),
          ),
          SizedBox(height: 24),
          Row(
            children: <Widget>[
              _horizontalRadioTile(gender: Gender.male, title: "Мужской"),
              _horizontalRadioTile(gender: Gender.female, title: "Женский")
            ],
          )
        ]),
        onContinue: widget.onContinue);
  }

  Widget _horizontalRadioTile({required Gender gender, required String title}) {
    return Row(children: [
      PepRadioButton<Gender>(
          value: gender, groupValue: _gender, onChanged: _setGender),
      Text(
        title,
        style: Theme.of(context)
            .textTheme
            .bodyText1!
            .copyWith(color: Colors.black),
      )
    ]);
  }

  _setGender(Gender? gender) {
    _registrationBloc.add(FormUpdateEvent(
        data: {'gender': (gender == Gender.male ? 'male' : 'female')}));
    _registrationBloc.add(GenderFormSubmitEvent());
    setState(() {
      _gender = gender;
    });
  }
}
