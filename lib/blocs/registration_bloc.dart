import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pep/blocs/validation_state.dart';
import 'package:pep/blocs/registration_events.dart';
import 'package:pep/util/validation.dart';
import 'dart:developer' as developer;

class RegistrationFlowBloc extends Bloc<RegistrationEvent, ValidationState> {
  RegistrationFlowBloc(ValidationState initialState) : super(initialState);

  Map<String, dynamic> userData = Map();

  @override
  Stream<ValidationState> mapEventToState(RegistrationEvent event) async* {
    developer.log('received event: $event', name: 'my.app.category');
    switch (event.runtimeType) {
      case FormUpdateEvent:
        userData.addAll((event as FormUpdateEvent).data);
        break;
      case RegistrationFormSubmitEvent:
        yield* _validateUserDataFields(validators: {
          'email': _validateEmail,
          'password': _validatePassword,
        });
        break;
      case NextFormEvent:
        yield FormSubmitted();
        break;
      case SendEmailCodeRequestEvent:
        _generateEmailCode();
        break;
      case EmailCodeFormSubmitEvent:
        yield* _validateEmailCode((event as EmailCodeFormSubmitEvent).code);
        break;
      case NameFormSubmitEvent:
        // TODO: Check name correctness
        yield Correct();
        break;
      case GenderFormSubmitEvent:
        yield Correct();
        break;
      case DateOfBirthFormSubmitEvent:
        // TODO: Check date of birth correctness
        yield Correct();
        break;
      case SendPhoneCodeRequestEvent:
        _generatePhoneCode();
        break;
      case PhoneFormSubmitEvent:
        yield* _validatePhoneFormat(userData['phone']);
        break;
      case PhoneCodeFormSubmitEvent:
        yield* _validatePhoneCode((event as PhoneCodeFormSubmitEvent).code);
    }
  }

  Stream<ValidationState> _validateUserDataFields(
      {required Map<String, ValidationState Function(String? fieldValue)>
          validators}) async* {
    for (var entry in validators.entries) {
      var fieldValue = userData[entry.key];
      var validator = entry.value;
      var validationResult = validator(fieldValue);

      if (validationResult is Incorrect) {
        yield validationResult;
        return;
      }
    }
    yield Correct();
  }

  ValidationState _validateEmail(String? email) {
    var result = validateEmailFormat(email);
    if (result != null) {
      return Incorrect(errorMessage: result);
    }

    if (isEmailRegistered(email)) {
      return Incorrect(
          errorMessage: 'Пользователь с указанным email уже существует');
    }
    return Correct();
  }

  ValidationState _validatePassword(String? password) {
    var result = validatePasswordFormat(password);
    if (result != null) {
      return Incorrect(errorMessage: result);
    }
    return Correct();
  }

  Stream<ValidationState> _validateEmailCode(String code) async* {
    yield Processing();
    // TODO: Check the code
    if (code == '111111') {
      yield Correct();
    } else {
      yield Incorrect(errorMessage: "Неправильный код");
    }
  }

  Stream<ValidationState> _validatePhoneCode(String code) async* {
    yield Processing();
    // TODO: Check the code
    if (code == '111111') {
      yield CorrectStep(step: 2);
    } else {
      yield IncorrectStep(step: 2, errorMessage: "Неправильный код");
    }
  }

  Stream<ValidationState> _validatePhoneFormat(String phoneNumber) async* {
    final String phoneRegex =
        r'^(\+7|7|8)?[\s\-]?\(?[489][0-9]{2}\)?[\s\-]?[0-9]{3}[\s\-]?[0-9]{2}[\s\-]?[0-9]{2}$';
    var exp = RegExp(phoneRegex);
    if (exp.hasMatch(phoneNumber)) {
      yield CorrectStep(step: 1);
    } else
      yield IncorrectStep(step: 1, errorMessage: 'Некорректный номер телефона');
  }

  _generateEmailCode() {
    // TODO: Send code generation request to server
  }

  _generatePhoneCode() {
    // TODO: Send code generation request to server
  }
}
