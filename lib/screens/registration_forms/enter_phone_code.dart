import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pep/blocs/registration_bloc.dart';
import 'package:pep/blocs/registration_events.dart';
import 'package:pep/blocs/validation_state.dart';
import 'package:pep/util/widgets.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../constants.dart';

class EnterPhoneCodeForm extends StatefulWidget {
  final Function() onContinue;

  EnterPhoneCodeForm({required this.onContinue});

  @override
  State<StatefulWidget> createState() => _EnterPhoneCodeFormState();
}

class _EnterPhoneCodeFormState extends State<EnterPhoneCodeForm> {
  late RegistrationFlowBloc _registrationBloc;
  final TextEditingController _phoneNumberController =
      TextEditingController(text: '');

  String? message = '';
  String _phoneCode = '';

  @override
  void initState() {
    super.initState();
    _registrationBloc = BlocProvider.of<RegistrationFlowBloc>(context);
    _phoneNumberController.addListener(() {
      _registrationBloc
          .add(FormUpdateEvent(data: {'phone': _phoneNumberController.text}));
      _registrationBloc.add(PhoneFormSubmitEvent());
    });
  }

  _canShowCodeInput() {
    var state = _registrationBloc.state;
    return (state is CorrectStep && state.step >= 1) ||
        (state is IncorrectStep && state.step > 1);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegistrationFlowBloc, ValidationState>(
        bloc: _registrationBloc,
        listener: (context, state) {
          if (state is Correct) {
            message = null;
          } else if (state is Incorrect) {
            message = state.errorMessage;
          }
        },
        builder: (context, state) => PepRegistrationForm(
            body:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Укажите телефон",
                  style: Theme.of(context)
                      .textTheme
                      .headline1!
                      .copyWith(color: Colors.black)),
              SizedBox(height: 32),
              PepFormField(hint: '+7', controller: _phoneNumberController),
              (_canShowCodeInput()
                  ? _phoneCodeValidation(context)
                  : Container(
                      child: Text(
                          message ?? 'Мы отправим на него код подтверждения',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: kPrimaryColor)),
                      margin: EdgeInsets.only(top: 16))),
            ]),
            onContinue: widget.onContinue));
  }

  Widget _phoneCodeValidation(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(height: 32),
      Text('Введите код из SMS',
          style: Theme.of(context)
              .textTheme
              .button!
              .copyWith(color: Colors.black)),
      SizedBox(height: 24),
      PinCodeTextField(
          pinTheme: PinTheme(
              inactiveColor: kSecondaryTextColor,
              selectedColor: Colors.black,
              activeColor: Colors.black),
          cursorColor: Colors.black,
          textStyle: Theme.of(context)
              .textTheme
              .headline1!
              .copyWith(color: Colors.black),
          appContext: context,
          length: 6,
          onChanged: (code) {
            _phoneCode = code;
            _registrationBloc.add(PhoneCodeFormSubmitEvent(code: code));
          }),
      SizedBox(height: 16),
      (_phoneCode.isNotEmpty && message != null
          ? Text(message!,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Color(0xffc30000)))
          : _helpingText)
    ]);
  }

  Widget get _helpingText => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
              onTap: () {
                _registrationBloc.add(SendPhoneCodeRequestEvent());
              },
              child: RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                      text: 'Не пришел код?\n',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(color: kPrimaryColor),
                      children: [
                        TextSpan(
                            text: "Отправить новый",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(
                                    color: kPrimaryColor,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.w700))
                      ]))),
        ],
      );

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }
}
