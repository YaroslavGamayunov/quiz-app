import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizapp/blocs/test/test_bloc.dart';
import 'package:quizapp/blocs/test/test_bloc_state.dart';
import 'package:quizapp/questions.dart';
import 'package:quizapp/screens/question_pages/binary_question.dart';
import 'package:quizapp/screens/question_pages/image_matching.dart';
import 'package:quizapp/screens/question_pages/image_puzzle/image_puzzle.dart';
import 'package:quizapp/screens/question_pages/number_connection.dart';
import 'package:quizapp/screens/question_pages/point_connection.dart';
import 'package:quizapp/screens/question_pages/remember_words.dart';
import 'package:quizapp/screens/question_pages/schulte_table.dart';
import 'package:quizapp/screens/question_pages/writing_answer.dart';
import 'package:quizapp/screens/test_finished.dart';

import '../constants.dart';

class TestPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  late TestBloc _testBloc;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _testBloc = BlocProvider.of<TestBloc>(context);
    _testBloc.startCurrentTest();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TestBloc, TestBlocState>(
        listener: (context, state) {
          if (state is TestFinished) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) =>
                        TestFinishedMessagePage(testResult: state)),
                (route) => false);
          }
        },
        bloc: _testBloc,
        buildWhen: (previousState, state) =>
            (previousState.runtimeType != state.runtimeType) ||
            (previousState is OnQuestion &&
                state is OnQuestion &&
                previousState.index != state.index),
        builder: (context, state) {
          if (state is OnQuestion) {
            return CustomScrollView(controller: _scrollController, slivers: [
              SliverPersistentHeader(
                  floating: true,
                  delegate:
                      _TestHeader(index: state.index, total: state.total)),
              _testBody(state.question)
            ]);
          }
          return Center(child: CircularProgressIndicator());
        });
  }

  void _onQuestionAnswered(dynamic answer) {
    developer.log("Answered question: $answer", name: "TestBloc");
    _testBloc.answerCurrentQuestion(answer);
    _scrollController.animateTo(0,
        duration: Duration(milliseconds: 0), curve: Curves.easeOut);
  }

  Widget _testBody(Question question) {
    switch (question.runtimeType) {
      case BinaryAnswerQuestion:
        return BinaryAnswerQuestionPage(
            onAnswer: _onQuestionAnswered,
            questionText: (question as BinaryAnswerQuestion).question,
            imageUrl: question.imageUrl);
      case RememberWordsQuestion:
        return RememberWordsQuestionPage(
            onAnswer: _onQuestionAnswered,
            words: (question as RememberWordsQuestion).words,
            timeOut: question.timeout);
      case WritingAnswerQuestion:
        return WritingAnswerQuestionPage(
            onAnswer: _onQuestionAnswered,
            questionText: (question as WritingAnswerQuestion).question,
            imageUrl: question.imageUrl,
            description: question.description);
      case ImageMatchingQuestion:
        return ImageMatchingQuestionPage(
            onAnswer: _onQuestionAnswered,
            imageUrls: (question as ImageMatchingQuestion).imageUrls,
            words: question.words,
            questionText: question.questionText);
      case SchulteTableQuestion:
        return SchulteTableQuestionPage(
            onAnswer: _onQuestionAnswered,
            cells: (question as SchulteTableQuestion).cells,
            description: question.description);
      case NumberConnectionQuestion:
        return NumberConnectionPage(
            onAnswer: _onQuestionAnswered,
            points: (question as NumberConnectionQuestion).points,
            description: question.description);
      case PointConnectionQuestion:
        return PointConnectionPage(
            onAnswer: _onQuestionAnswered,
            points: (question as PointConnectionQuestion).points,
            graph: question.connectionGraph);
      case ImagePuzzleQuestion:
        return ImagePuzzlePage(
            onAnswer: _onQuestionAnswered,
            imageUrl: (question as ImagePuzzleQuestion).imageUrl,
            puzzlePermutation: question.puzzlePermutation);
    }

    return Center();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class _TestHeader extends SliverPersistentHeaderDelegate {
  const _TestHeader({required this.index, required this.total});

  final int index;
  final int total;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: _getBoxShadowDecoration(overlapsContent)),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 24),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(height: 24),
            LinearProgressIndicator(
              color: kPrimaryColor,
              backgroundColor: kInputBackgroundColor,
              minHeight: 5.0,
              value: (index + 1) / total,
            ),
            SizedBox(height: 16),
            Text('Вопрос ${index + 1}/$total',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: kSecondaryTextColor)),
          ]),
        ));
  }

  @override
  double get maxExtent => 90;

  @override
  double get minExtent => 80;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  List<BoxShadow> _getBoxShadowDecoration(bool overlapsContent) {
    if (overlapsContent) {
      return [
        BoxShadow(
          color: Color(0x1a000000),
          blurRadius: 20,
          spreadRadius: 5,
          offset: Offset(0, 1), // changes position of shadow
        )
      ];
    }
    return [];
  }
}
