import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pep/blocs/test_bloc_state.dart';
import 'package:pep/questions.dart';

class TestBloc extends Cubit<TestBlocState> {
  TestBloc() : super(InitialState()) {
    DateTimeRange? availableTestDate = getAvailableTestDate();
    DateTime currentTime = DateTime.now();
    if (availableTestDate != null &&
        currentTime.isAfter(availableTestDate.start) &&
        currentTime.isBefore(availableTestDate.end)) {
      emit(TestAvailable(testStartDate: availableTestDate.start));
    } else {
      emit(TestNotAvailable());
    }
  }

  List<Question> _testQuestions = [];
  List<dynamic> _userTestAnswers = [];
  List<int> _answerTimes = [];

  Timer? _timer;

  void answerCurrentQuestion(dynamic answer) {
    _timer?.cancel();
    if (state is OnQuestion) {
      int currentId = (state as OnQuestion).index;
      _userTestAnswers[currentId] = answer;
      if (currentId + 1 < _userTestAnswers.length) {
        _startQuestion(index: ++currentId);
      } else {
        // TODO: Send request to server to get test results
        emit(TestFinished(
            correctAnswers: 5,
            incorrectAnswers: _userTestAnswers.length - 5,
            time: 0));
        emit(InitialState());
      }
    }
  }

  void _startQuestion({required int index}) {
    var testState = OnQuestion(
        total: _testQuestions.length,
        index: index,
        question: _testQuestions[index]);
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      emit(testState.copyWith(timePassed: _answerTimes[index]++));
    });
  }

  DateTimeRange? getAvailableTestDate() {
    return DateTimeRange(start: DateTime(0), end: DateTime(2050));
  }

  void _loadCurrentTest() {
    // Todo: load current test json into testQuestionsJson
    var testQuestionsJson = [
      {
        'type': 'number_connection',
        'questionData': {
          'description': 'Соедините числа',
          'points': [
            {'x': 0.1, 'y': 0.1, 'number': 1},
            {'x': 0.15, 'y': 0.8, 'number': 2},
            {'x': 0.7, 'y': 0.9, 'number': 3},
            {'x': 0.9, 'y': 0.7, 'number': 4},
            {'x': 0.3, 'y': 0.3, 'number': 5},
            {'x': 0.05, 'y': 0.5, 'number': 6},
            {'x': 0.35, 'y': 0.6, 'number': 7},
            {'x': 0.75, 'y': 0.4, 'number': 8},
            {'x': 0.5, 'y': 0.2, 'number': 9},
            {'x': 0.82, 'y': 0.1, 'number': 10},
          ]
        }
      },
      {
        'type': 'schulte',
        'questionData': {
          'description': 'Выберите числа в порядке возрастания',
          'cells': [
            '1',
            '2',
            '3',
            '4',
            '5',
            '6',
            '7',
            '8',
            '9',
            '10',
            '11',
            '12',
            '13',
            '14',
            '15',
            '16',
            '17',
            '18',
            '19',
            '20',
            '21',
            '22',
            '23',
            '24',
            '25'
          ]
        }
      },
      {
        'type': 'binary',
        'questionData': {
          'question': 'Это место находится в Париже?',
          'imageUrl':
              'https://im0-tub-ru.yandex.net/i?id=e2498a755f094de2b8d73fe3f05f8ed3-l&n=13'
        }
      },
      {
        'type': 'image_matching',
        'questionData': {
          'imageUrls': [
            'https://www.wykop.pl/cdn/c3201142/comment_oQMV69SA6PV2Bx5XK3vwbUfStw7MPoAc,w1200h627f.jpg',
            'https://cdn.pixabay.com/photo/2017/06/01/12/58/tree-2363456_1280.jpg',
            'https://www.startrescue.co.uk/media/c8878855-4f7e-4f52-96a7-9a748e610356.jpg',
            'https://smartwatch.bg/system/images/92287/original/casio_edifice_efr526l7avuef.png'
          ],
          'words': ['Лиса', 'Наручные часы', 'Дерево', 'Машина'],
          'questionText': 'Соедините картинку и слово'
        }
      },
      {
        'type': 'binary',
        'questionData': {
          'question': 'Правда или фейк?',
          'imageUrl':
              'https://porosenka.net/uploads/d/3/d34ab0b623408299d0111ddc12a3c895.jpg'
        }
      },
      {
        'type': 'binary',
        'questionData': {
          'question': 'Правда ли что у человека разный рост утром и вечером?',
          'imageUrl':
              'https://avatars.mds.yandex.net/get-forms/1520179/c481e9058bd5932f36a63415ae5926f2/1280x'
        }
      },
      {
        'type': 'remember',
        'questionData': {
          'words': [
            'Cиний',
            'Карлик',
            'Орел',
            'Блокнот',
            'Пожарник',
            'Курица',
            'Десерт',
            'Небо',
            'Ароматизатор',
            'Офис'
          ],
          'timeout': 10,
        }
      },
      {
        'type': 'binary',
        'questionData': {
          'question': 'Это место находится в Париже?',
          'imageUrl':
              'https://im0-tub-ru.yandex.net/i?id=e2498a755f094de2b8d73fe3f05f8ed3-l&n=13'
        }
      },
      {
        'type': 'writing_answer',
        'questionData': {
          'question': 'Что вы видите на картинке?',
          'description': 'Что это такое?',
          'imageUrl':
              'https://ecolozen.com/fr/wp-content/uploads/2018/02/vegetarisme-solution-ultime-environnement.jpg'
        }
      },
      {
        'type': 'remember',
        'questionData': {
          'words': [
            'Cиний',
            'Карлик',
            'Орел',
            'Блокнот',
            'Пожарник',
            'Курица',
            'Десерт',
            'Небо',
            'Ароматизатор',
            'Офис'
          ],
          'timeout': 10,
        }
      },
      {
        'type': 'writing_answer',
        'questionData': {
          'question': 'Что вы видите на картинке?',
          'description': 'Что это такое?',
          'imageUrl':
              'https://ecolozen.com/fr/wp-content/uploads/2018/02/vegetarisme-solution-ultime-environnement.jpg'
        }
      },
    ];
    _testQuestions.clear();
    for (var questionJson in testQuestionsJson) {
      Map<String, dynamic> questionData =
          questionJson['questionData'] as Map<String, dynamic>;

      Question? question;
      switch (questionJson['type']) {
        case 'binary':
          question = BinaryAnswerQuestion.fromJson(questionData);
          break;
        case 'remember':
          question = RememberWordsQuestion.fromJson(questionData);
          break;
        case 'writing_answer':
          question = WritingAnswerQuestion.fromJson(questionData);
          break;
        case 'image_matching':
          question = ImageMatchingQuestion.fromJson(questionData);
          break;
        case 'schulte':
          question = SchulteTableQuestion.fromJson(questionData);
          break;
        case 'number_connection':
          question = NumberConnectionQuestion.fromJson(questionData);
          break;
      }

      if (question != null) _testQuestions.add(question);
    }
  }

  void startCurrentTest() {
    _timer?.cancel();
    _loadCurrentTest();
    _userTestAnswers =
        List.filled(_testQuestions.length, null, growable: false);
    _answerTimes = List.filled(_testQuestions.length, 0);
    if (_testQuestions.isNotEmpty) {
      _startQuestion(index: 0);
    }
  }
}
