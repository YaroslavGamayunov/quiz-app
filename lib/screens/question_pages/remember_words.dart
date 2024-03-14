import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pep/blocs/test_bloc.dart';
import 'package:pep/blocs/test_bloc_state.dart';
import 'package:pep/constants.dart';
import 'package:pep/screens/question_pages/test_page.dart';
import 'package:pep/util/widgets.dart';

class RememberWordsQuestionPage extends StatefulWidget implements ITestPage {
  @override
  final Function(dynamic) onAnswer;
  final List<String> words;
  final Duration timeOut;

  RememberWordsQuestionPage(
      {required this.onAnswer, required this.words, required this.timeOut});

  @override
  _RememberWordsQuestionPageState createState() =>
      _RememberWordsQuestionPageState();
}

class _RememberWordsQuestionPageState extends State<RememberWordsQuestionPage> {
  bool _isOnRememberingScreen = true;
  late final List<String?> answers;
  final _formKey = GlobalKey<FormState>();
  int _timePassed = 0;

  @override
  void initState() {
    super.initState();
    answers = List.filled(widget.words.length, "");
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TestBloc, TestBlocState>(
        listener: (context, state) {
          if (state is OnQuestion) {
            _timePassed = state.timePassed;
          }
        },
        builder: (context, state) =>
            (_isOnRememberingScreen ? _rememberWords : _enterWords));
  }

  Widget get _rememberWords => SliverList(
          delegate: SliverChildListDelegate([
        Container(
          margin: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Запомните слова',
            style: Theme.of(context)
                .textTheme
                .headline1!
                .copyWith(color: Colors.black),
            textAlign: TextAlign.start,
          ),
        ),
        SizedBox(height: 24),
        GridView(
            padding: EdgeInsets.symmetric(horizontal: 24),
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 10, childAspectRatio: 2.5),
            children: widget.words
                .map((word) => Text(word,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.black)))
                .toList()),
        SizedBox(height: 24),
        Container(
            margin: EdgeInsets.symmetric(horizontal: 24),
            child: Column(children: [
              Text(
                'Таймер',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: kSecondaryTextColor),
                textAlign: TextAlign.center,
              ),
              Text(
                '${_timePassed} cекунд',
                style: Theme.of(context)
                    .textTheme
                    .button!
                    .copyWith(color: kPrimaryColor),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              PepButton(
                  title: 'Продолжить',
                  onTap: () {
                    setState(() {
                      _isOnRememberingScreen = false;
                    });
                  }),
              SizedBox(height: 24),
            ]))
      ]));

  Widget get _enterWords => SliverList(
          delegate: SliverChildListDelegate([
        Container(
          margin: EdgeInsets.symmetric(horizontal: 24),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              'Введите слова',
              style: Theme.of(context)
                  .textTheme
                  .headline1!
                  .copyWith(color: Colors.black),
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 40),
            _makeWordInputForm(widget.words.length),
            SizedBox(height: 32),
            PepButton(
                title: "Прододжить",
                onTap: () {
                  _formKey.currentState?.save();
                  widget.onAnswer(answers);
                }),
            SizedBox(height: 24)
          ]),
        )
      ]));

  Widget _makeWordInputForm(int count) {
    List<Widget> forms = [];
    for (var i = 0; i < count; i++) {
      forms.add(PepFormField(
          hint: "Слово ${i + 1}",
          onSaved: (text) {
            answers[i] = text;
          }));
      if (i + 1 < count) forms.add(SizedBox(height: 16));
    }
    return Form(key: _formKey, child: Column(children: forms));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
