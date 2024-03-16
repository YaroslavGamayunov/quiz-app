
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pep/blocs/test_bloc.dart';
import 'package:pep/blocs/test_bloc_state.dart';
import 'package:pep/constants.dart';
import 'package:pep/questions.dart';
import 'package:pep/screens/question_pages/common/circle_connection_widget.dart';
import 'package:pep/screens/question_pages/test_page.dart';
import 'package:pep/util/widgets.dart';

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
                              .headline1!
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
                      ConstrainedBox(
                          constraints: BoxConstraints(
                              minHeight: 250, minWidth: double.infinity),
                          child: CircleConnectionWidget(
                            initialPoints: widget.points,
                          )),
                      SizedBox(height: 24),
                      Align(
                        child: Text(
                          'Таймер',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
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
                      PepButton(
                          title: 'Продолжить',
                          onTap: () {
                            widget.onAnswer(null);
                          }),
                      SizedBox(height: 24),
                    ]))));
  }
}
