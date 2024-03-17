import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizapp/blocs/auth/registration_events.dart';
import 'package:quizapp/blocs/auth/validation_state.dart';
import 'package:quizapp/util/validation.dart';

import '../../api/auth.dart';

class RegistrationFlowBloc extends Bloc<RegistrationEvent, ValidationState> {
  RegistrationFlowBloc(
      {Map<String, dynamic>? initialData,
      required ValidationState initialState})
      : userData = initialData ?? Map(),
        super(initialState) {
    on<FormUpdateEvent>(_onFormUpdateEvent);
    on<RegistrationFormSubmitEvent>(_onRegistrationFormSubmitEvent);
    on<NextFormEvent>(_onNextFormEvent);
    on<NameFormSubmitEvent>(_onNameFormSubmitEvent);
    on<EndRegistrationEvent>(_onEndRegistrationEvent);
  }

  Map<String, dynamic> userData;

  void _onFormUpdateEvent(
      FormUpdateEvent event, Emitter<ValidationState> emitter) async {
    userData.addAll(event.data);
  }

  void _onRegistrationFormSubmitEvent(RegistrationFormSubmitEvent event,
      Emitter<ValidationState> emitter) async {
    await _validateUserDataFields(validators: {
      'email': _validateEmail,
      'password': _validatePassword,
    }, emitter: emitter);
  }

  void _onNextFormEvent(
      NextFormEvent event, Emitter<ValidationState> emitter) async {
    emitter.call(FormSubmitted());
  }

  void _onNameFormSubmitEvent(
      NameFormSubmitEvent event, Emitter<ValidationState> emitter) async {
    emitter.call(Correct());
  }

  void _onEndRegistrationEvent(
      EndRegistrationEvent event, Emitter<ValidationState> emitter) async {
    emitter.call(Processing());
    final isSuccess = await registerNewUser(userData);
    if (isSuccess) {
      emitter.call(Correct());
    } else {
      emitter.call(Incorrect(
          errorMessage:
              "Ошибка (не все поля верно заполнены или нет соединения)"));
    }
  }

  Future<void> _validateUserDataFields(
      {required Map<String,
              Future<ValidationState> Function(dynamic fieldValue)>
          validators,
      required Emitter<ValidationState> emitter}) async {
    for (var entry in validators.entries) {
      var fieldValue = userData[entry.key];
      var validator = entry.value;
      var validationResult = await validator(fieldValue);

      if (validationResult is Incorrect) {
        emitter.call(validationResult);
        return;
      }
    }
    if (!emitter.isDone) {
      emitter.call(Correct());
    }
  }

  Future<ValidationState> _validateEmail(dynamic email) async {
    var result = validateEmailFormat(email as String?);
    if (result != null) {
      return Incorrect(errorMessage: result);
    }
    return Correct();
  }

  Future<ValidationState> _validatePassword(dynamic passwordData) async {
    String? password = passwordData?['password'];
    String? confirmation = passwordData?['confirmation'];

    var result = validatePasswordFormat(password);
    if (result != null) {
      return Incorrect(errorMessage: result);
    }

    if (password != confirmation) {
      return Incorrect(errorMessage: 'Пароли не совпадают');
    }

    return Correct();
  }
}
