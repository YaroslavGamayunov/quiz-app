import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pep/blocs/test_bloc.dart';
import 'package:pep/blocs/test_bloc_state.dart';
import 'package:pep/questions.dart';
import 'package:pep/screens/question_pages/binary_question.dart';
import 'package:pep/screens/question_pages/image_matching.dart';
import 'package:pep/screens/question_pages/remember_words.dart';
import 'package:pep/screens/question_pages/writing_answer.dart';
import 'package:pep/screens/test_finished.dart';

import '../constants.dart';

class TestPage extends StatefulWidget {
  final Function(Widget page) onPageChanged;

  TestPage({required this.onPageChanged});

  @override
  State<StatefulWidget> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  late TestBloc _testBloc = TestBloc();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _testBloc.startCurrentTest();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TestBloc, TestBlocState>(
        listener: (context, state) {
          if (state is TestFinished) {
            widget.onPageChanged(TestFinishedPage(
                countOfQuestions:
                    state.correctAnswers + state.incorrectAnswers));
          }
        },
        bloc: _testBloc,
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
            words: question.words);
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
                    .bodyText1!
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
