import 'package:equatable/equatable.dart';

class Question extends Equatable {
  @override
  List<Object?> get props => [];
}

class BinaryAnswerQuestion extends Question {
  final String question;
  final String imageUrl;

  BinaryAnswerQuestion({required this.question, required this.imageUrl});

  BinaryAnswerQuestion.fromJson(Map<String, dynamic> json)
      : question = json['question'],
        imageUrl = json['imageUrl'];
}
