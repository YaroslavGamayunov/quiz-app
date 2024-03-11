import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pep/blocs/registration_bloc.dart';
import 'package:pep/blocs/registration_events.dart';
import 'package:pep/blocs/validation_state.dart';
import 'package:pep/constants.dart';
import 'package:pep/util/widgets.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class EnterEmailCodeForm extends StatefulWidget {
  final Function() onContinue;

  EnterEmailCodeForm({required this.onContinue});

  @override
  _EnterEmailCodeFormState createState() => _EnterEmailCodeFormState();
}

class _EnterEmailCodeFormState extends State<EnterEmailCodeForm> {
  late RegistrationFlowBloc _registrationBloc;

  String? errorMessage;
  String emailCode = '';

  @override
  Widget build(BuildContext context) {
    _registrationBloc = BlocProvider.of<RegistrationFlowBloc>(context);
    return BlocConsumer<RegistrationFlowBloc, ValidationState>(
        bloc: _registrationBloc,
        listener: (context, state) {
          if (state is Incorrect) {
            errorMessage = state.errorMessage;
          } else {
            errorMessage = null;
          }
        },
        builder: (context, state) => PepRegistrationForm(
            body: _form(context), onContinue: widget.onContinue));
  }

  Widget _form(BuildContext context) => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Введите код из письма",
              style: Theme.of(context)
                  .textTheme
                  .headline1!
                  .copyWith(color: Colors.black),
            ),
            SizedBox(height: 32),
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
                  emailCode = code;
                  _registrationBloc.add(EmailCodeFormSubmitEvent(code: code));
                }),
            SizedBox(height: 16),
            (emailCode.isNotEmpty && errorMessage != null
                ? Text(errorMessage!,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Color(0xffc30000)))
                : _helpingText)
          ]);

  Widget get _helpingText => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Совет: проверьте папку «Спам»',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: kPrimaryColor)),
          SizedBox(height: 16),
          GestureDetector(
              onTap: () {
                _registrationBloc.add(SendEmailCodeRequestEvent());
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
}
