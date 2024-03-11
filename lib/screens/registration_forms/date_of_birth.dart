import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pep/blocs/registration_bloc.dart';
import 'package:pep/blocs/registration_events.dart';
import 'package:pep/util/widgets.dart';

class DateOfBirthForm extends StatefulWidget {
  final Function() onContinue;

  DateOfBirthForm({required this.onContinue});

  @override
  State<StatefulWidget> createState() => _DateOfBirthState();
}

class _DateOfBirthState extends State<DateOfBirthForm> {
  final TextEditingController _controller = TextEditingController();
  late RegistrationFlowBloc _registrationBloc;

  @override
  void initState() {
    super.initState();
    _registrationBloc = BlocProvider.of<RegistrationFlowBloc>(context);
    _controller.addListener(() {
      _registrationBloc
          .add(FormUpdateEvent(data: {'birth_date': _controller.text}));
      _registrationBloc.add(DateOfBirthFormSubmitEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return PepRegistrationForm(
        body: Column(children: [
          Text('Укажите дату рождения',
              style: Theme.of(context)
                  .textTheme
                  .headline1!
                  .copyWith(color: Colors.black)),
          SizedBox(height: 32),
          PepFormField(hint: 'ДД.ММ.ГГГГ', controller: _controller)
        ]),
        onContinue: widget.onContinue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
