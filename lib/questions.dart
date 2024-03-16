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

  @override
  List<Object?> get props => [question, imageUrl];
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

  @override
  List<Object?> get props => [imageUrls, words, questionText];
}

class SchulteTableQuestion extends Question {
  final List<String> cells;
  final String description;

  SchulteTableQuestion.fromJson(Map<String, dynamic> json)
      : cells = json['cells'],
        description = json['description'];

  @override
  List<Object?> get props => [cells, description];
}

class CirclePoint extends Equatable {
  final double x;
  final double y;
  final String text;

  CirclePoint({required this.x, required this.y, required this.text});

  @override
  List<Object?> get props => [x, y, text];
}

class NumberCirclePoint extends CirclePoint {
  int get number => int.parse(super.text);

  NumberCirclePoint.fromJson(Map<String, dynamic> json)
      : super(x: json['x'], y: json['y'], text: json['number'].toString());
}

class EmptyCirclePoint extends CirclePoint {
  EmptyCirclePoint.fromJson(Map<String, dynamic> json)
      : super(x: json['x'], y: json['y'], text: '');
}

class NumberConnectionQuestion extends Question {
  final String description;
  final List<NumberCirclePoint> points;

  NumberConnectionQuestion.fromJson(Map<String, dynamic> json)
      : description = json['description'],
        points = (json['points'] as List<Map<String, dynamic>>)
            .map((pointJson) => NumberCirclePoint.fromJson(pointJson))
            .toList();

  @override
  List<Object?> get props => [description, points];
}

class PointConnectionQuestion extends Question {
  final List<EmptyCirclePoint> points;
  final List<List<int>> connectionGraph;

  PointConnectionQuestion.fromJson(Map<String, dynamic> json)
      : points = (json['points'] as List<Map<String, dynamic>>)
            .map((pointJson) => EmptyCirclePoint.fromJson(pointJson))
            .toList(),
        connectionGraph = json['graph'];

  @override
  List<Object?> get props => [points, connectionGraph];
}

class ImagePuzzleQuestion extends Question {
  final String imageUrl;
  final List<int> puzzlePermutation;

  ImagePuzzleQuestion.fromJson(Map<String, dynamic> json)
      : imageUrl = json['imageUrl'],
        puzzlePermutation = json['puzzlePermutation'];
}
