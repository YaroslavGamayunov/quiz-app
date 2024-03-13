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

  void answerCurrentQuestion(dynamic answer) {
    if (state is OnQuestion) {
      int currentId = (state as OnQuestion).index;
      _userTestAnswers[currentId] = answer;
      if (currentId + 1 < _userTestAnswers.length) {
        currentId++;
        emit(OnQuestion(
            total: _testQuestions.length,
            index: currentId,
            question: _testQuestions[currentId]));
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

  DateTimeRange? getAvailableTestDate() {
    return DateTimeRange(start: DateTime(0), end: DateTime(2050));
  }

  void _loadCurrentTest() {
    // Todo: load current test json into testQuestionsJson
    var testQuestionsJson = [
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
        'questionData': {'imageUrls': ['https://www.wykop.pl/cdn/c3201142/comment_oQMV69SA6PV2Bx5XK3vwbUfStw7MPoAc,w1200h627f.jpg', 'https://cdn.pixabay.com/photo/2017/06/01/12/58/tree-2363456_1280.jpg', 'https://www.startrescue.co.uk/media/c8878855-4f7e-4f52-96a7-9a748e610356.jpg', 'https://smartwatch.bg/system/images/92287/original/casio_edifice_efr526l7avuef.png'], 'words': ['Лиса', 'Наручные часы', 'Дерево', 'Машина']}
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
      }

      if (question != null) _testQuestions.add(question);
    }
  }

  void startCurrentTest() {
    _loadCurrentTest();
    _userTestAnswers =
        List.filled(_testQuestions.length, null, growable: false);
    if (_testQuestions.isNotEmpty) {
      emit(OnQuestion(
          index: 0, total: _testQuestions.length, question: _testQuestions[0]));
    }
  }
}
