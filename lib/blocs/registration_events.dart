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

class RegistrationFormSubmitEvent extends RegistrationEvent {}

class NameFormSubmitEvent extends RegistrationEvent {}

class GenderFormSubmitEvent extends RegistrationEvent {}
