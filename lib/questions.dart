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

class RememberWordsQuestion extends Question {
  final List<String> words;
  final Duration timeout;

  RememberWordsQuestion({required this.words, required this.timeout});

  RememberWordsQuestion.fromJson(Map<String, dynamic> json)
      : words = json['words'],
        timeout = Duration(seconds: json['timeout']);

  @override
  List<Object?> get props => [words];
}

class WritingAnswerQuestion extends Question {
  final String question;
  final String imageUrl;
  final String description;

  WritingAnswerQuestion.fromJson(Map<String, dynamic> json)
      : question = json['question'],
        imageUrl = json['imageUrl'],
        description = json['description'];

  @override
  List<Object?> get props => [question, imageUrl, description];
}

class ImageMatchingQuestion extends Question {
  final List<String> imageUrls;
  final List<String> words;
  final String questionText;

  ImageMatchingQuestion.fromJson(Map<String, dynamic> json)
      : imageUrls = json['imageUrls'],
        words = json['words'],
        questionText = json['questionText'];
}

class SchulteTableQuestion extends Question {
  final List<String> cells;
  final String description;

  SchulteTableQuestion.fromJson(Map<String, dynamic> json)
      : cells = json['cells'],
        description = json['description'];
}
