import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizapp/blocs/test/test_bloc.dart';
import 'package:quizapp/blocs/test/test_bloc_state.dart';
import 'package:quizapp/constants.dart';
import 'package:quizapp/data/questions.dart';
import 'package:quizapp/screens/question_pages/common/circle_connection/circle_connection_widget.dart';
import 'package:quizapp/screens/question_pages/test_page.dart';
import 'package:quizapp/widgets.dart';

class NumberConnectionPage extends StatefulWidget implements ITestPage {
  final List<NumberCirclePoint> points;
  final String description;

  NumberConnectionPage(
      {required this.onAnswer,
      required this.points,
      required this.description});

  @override
  _NumberConnectionPageState createState() => _NumberConnectionPageState();

  @override
  final Function(dynamic) onAnswer;
}

class _NumberConnectionPageState extends State<NumberConnectionPage> {
  int _timePassed = 0;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TestBloc, TestBlocState>(
        listener: (context, state) {
          if (state is OnQuestion) {
            _timePassed = state.timePassed;
          }
        },
        builder: (context, state) => SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Связь чисел",
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(color: Colors.black)),
                      SizedBox(height: 16),
                      Text(
                        widget.description,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: kSecondaryTextColor),
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.3,
                          width: double.infinity,
                          child: CircleConnectionWidget(
                            initialPoints: widget.points,
                          )),
                      SizedBox(height: 24),
                      Align(
                        child: Text(
                          'Таймер',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: kSecondaryTextColor),
                          textAlign: TextAlign.center,
                        ),
                        alignment: Alignment.center,
                      ),
                      Align(
                        child: Text(
                          '${_timePassed} cекунд',
                          style: Theme.of(context)
                              .textTheme
                              .button!
                              .copyWith(color: kPrimaryColor),
                          textAlign: TextAlign.center,
                        ),
                        alignment: Alignment.center,
                      ),
                      SizedBox(height: 24),
                      QuizAppButton(
                          title: 'Продолжить',
                          onTap: () {
                            widget.onAnswer(null);
                          }),
                      SizedBox(height: 24),
                    ]))));
  }
}
