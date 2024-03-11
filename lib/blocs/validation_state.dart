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

class CorrectStep extends Correct {
  final int step;

  CorrectStep({required this.step});

  @override
  List<Object?> get props => [step];
}

class IncorrectStep extends Incorrect {
  final int step;
  final String errorMessage;

  IncorrectStep({required this.step, required this.errorMessage})
      : super(errorMessage: errorMessage);

  @override
  List<Object?> get props => [step];
}
