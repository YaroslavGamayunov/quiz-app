import 'package:equatable/equatable.dart';

abstract class RegistrationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FormUpdateEvent extends RegistrationEvent {
  final Map<String, dynamic> data;

  FormUpdateEvent({required this.data});

  @override
  List<Object?> get props => [data];
}

class NextFormEvent extends RegistrationEvent {}

class SendEmailCodeRequestEvent extends RegistrationEvent {}

class EmailCodeFormSubmitEvent extends RegistrationEvent {
  final String code;

  EmailCodeFormSubmitEvent({required this.code});

  @override
  List<Object?> get props => [code];
}

class RegistrationFormSubmitEvent extends RegistrationEvent {}

class NameFormSubmitEvent extends RegistrationEvent {}

class GenderFormSubmitEvent extends RegistrationEvent {}

class DateOfBirthFormSubmitEvent extends RegistrationEvent {}

class PhoneFormSubmitEvent extends RegistrationEvent {}

class SendPhoneCodeRequestEvent extends RegistrationEvent {}

class PhoneCodeFormSubmitEvent extends RegistrationEvent {
  final String code;

  PhoneCodeFormSubmitEvent({required this.code});

  @override
  List<Object?> get props => [code];
}
