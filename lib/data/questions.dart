import 'package:equatable/equatable.dart';

class Question extends Equatable {
  @override
  List<Object?> get props => [];
}

mixin QuestionWithImages on Question {
  List<String> get imageUrls;
}

class BinaryAnswerQuestion extends Question with QuestionWithImages {
  final String question;
  final String imageUrl;

  BinaryAnswerQuestion({required this.question, required this.imageUrl});

  BinaryAnswerQuestion.fromJson(Map<String, dynamic> json)
      : question = json['question'],
        imageUrl = json['imageUrl'];

  @override
  List<Object?> get props => [question, imageUrl];

  @override
  List<String> get imageUrls => [imageUrl];
}

class RememberWordsQuestion extends Question {
  final List<String> words;
  final Duration timeout;

  RememberWordsQuestion({required this.words, required this.timeout});

  RememberWordsQuestion.fromJson(Map<String, dynamic> json)
      : words = List<String>.from(json['words']),
        timeout = Duration(seconds: json['timeout']);

  @override
  List<Object?> get props => [words];
}

class WritingAnswerQuestion extends Question with QuestionWithImages {
  final String question;
  final String imageUrl;
  final String description;

  WritingAnswerQuestion.fromJson(Map<String, dynamic> json)
      : question = json['question'],
        imageUrl = json['imageUrl'],
        description = json['description'];

  @override
  List<Object?> get props => [question, imageUrl, description];

  @override
  List<String> get imageUrls => [imageUrl];
}

class ImageMatchingQuestion extends Question with QuestionWithImages {
  final List<String> imageUrls;
  final List<String> words;
  final String questionText;

  ImageMatchingQuestion.fromJson(Map<String, dynamic> json)
      : imageUrls = List<String>.from(json['imageUrls']),
        words = List<String>.from(json['words']),
        questionText = json['questionText'];

  @override
  List<Object?> get props => [imageUrls, words, questionText];
}

class SchulteTableQuestion extends Question {
  final List<String> cells;
  final String description;

  SchulteTableQuestion.fromJson(Map<String, dynamic> json)
      : cells = List<String>.from(json['cells']),
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
        points = (json['points'])
            .map<NumberCirclePoint>(
                (pointJson) => NumberCirclePoint.fromJson(pointJson))
            .toList();

  @override
  List<Object?> get props => [description, points];
}

class PointConnectionQuestion extends Question {
  final List<EmptyCirclePoint> points;
  final List<List<int>> connectionGraph;

  PointConnectionQuestion.fromJson(Map<String, dynamic> json)
      : points = json['points']
            .map<EmptyCirclePoint>((pointJson) =>
                EmptyCirclePoint.fromJson(pointJson as Map<String, dynamic>))
            .toList() as List<EmptyCirclePoint>,
        connectionGraph = json['graph']
            .map<List<int>>((l) => List<int>.from(l))
            .toList() as List<List<int>>;

  @override
  List<Object?> get props => [points, connectionGraph];
}

class ImagePuzzleQuestion extends Question with QuestionWithImages {
  final String imageUrl;
  final List<int> puzzlePermutation;

  ImagePuzzleQuestion.fromJson(Map<String, dynamic> json)
      : imageUrl = json['imageUrl'].toString(),
        puzzlePermutation = List<int>.from(json['puzzlePermutation']);

  @override
  List<String> get imageUrls => [imageUrl];
}
