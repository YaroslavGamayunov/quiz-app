import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pep/constants.dart';
import 'package:pep/screens/question_pages/test_page.dart';
import 'package:pep/util/widgets.dart';
import 'package:transparent_image/transparent_image.dart';

class WritingAnswerQuestionPage extends StatefulWidget implements ITestPage {
  final String questionText;
  final String imageUrl;
  final String description;

  WritingAnswerQuestionPage(
      {required this.questionText,
      required this.imageUrl,
      required this.onAnswer,
      required this.description});

  @override
  _WritingAnswerQuestionPageState createState() =>
      _WritingAnswerQuestionPageState();

  @override
  final Function(dynamic) onAnswer;
}

class _WritingAnswerQuestionPageState extends State<WritingAnswerQuestionPage> {
  final TextEditingController _answerInputController = TextEditingController();

  bool _canContinue = false;

  @override
  void initState() {
    super.initState();
    _answerInputController.addListener(() {
      setState(() {
        _canContinue = _answerInputController.text.isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
        delegate: SliverChildListDelegate([
      Container(
        margin: EdgeInsets.symmetric(horizontal: 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(widget.questionText,
              style: Theme.of(context)
                  .textTheme
                  .headline1!
                  .copyWith(color: Colors.black)),
          SizedBox(height: 24),
          SizedBox(
              width: MediaQuery.of(context).size.width - 48,
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: widget.imageUrl,
              )),
          SizedBox(height: 8),
          Container(
              width: double.infinity,
              child: Text(widget.description,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: kSecondaryTextColor))),
          SizedBox(height: 32),
          PepFormField(
              hint: 'Введите ответ', controller: _answerInputController),
          SizedBox(height: 16),
          PepButton(
              title: 'Продолжить',
              onTap: () {
                if (_canContinue) {
                  widget.onAnswer(_answerInputController.text);
                }
              },
              color: (_canContinue ? kPrimaryColor : kSecondaryTextColor)),
          SizedBox(height: 24)
        ]),
      )
    ]));
  }

  @override
  void dispose() {
    _answerInputController.dispose();
    super.dispose();
  }
}
