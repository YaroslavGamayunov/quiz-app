import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pep/blocs/validation_state.dart';
import 'package:pep/blocs/registration_events.dart';
import 'package:pep/util/validation.dart';

class RegistrationFlowBloc extends Bloc<RegistrationEvent, ValidationState> {
  RegistrationFlowBloc(ValidationState initialState) : super(initialState);

  Map<String, dynamic> userData = Map();

  @override
  Stream<ValidationState> mapEventToState(RegistrationEvent event) async* {
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
}
