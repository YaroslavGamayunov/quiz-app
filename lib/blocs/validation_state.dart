import 'package:equatable/equatable.dart';

abstract class ValidationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FormSubmitted extends ValidationState {}

class Correct extends ValidationState {}

class Processing extends ValidationState {}

class Incorrect extends ValidationState {
  final String errorMessage;

  Incorrect({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
