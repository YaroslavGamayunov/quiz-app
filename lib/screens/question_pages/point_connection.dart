import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pep/blocs/test_bloc.dart';
import 'package:pep/blocs/test_bloc_state.dart';
import 'package:pep/questions.dart';
import 'package:pep/screens/question_pages/test_page.dart';
import 'package:pep/util/widgets.dart';

import '../../constants.dart';
import 'common/circle_connection_widget.dart';

class PointConnectionPage extends StatefulWidget implements ITestPage {
  final List<EmptyCirclePoint> points;
  final List<List<int>> graph;

  PointConnectionPage(
      {required this.onAnswer, required this.points, required this.graph});

  @override
  State<StatefulWidget> createState() => _PointConnectionPageState();

  @override
  final Function(dynamic) onAnswer;
}

class _PointConnectionPageState extends State<PointConnectionPage> {
  int _timePassed = 0;
  bool _isPreview = true;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TestBloc, TestBlocState>(
        listener: (context, state) {
          if (state is OnQuestion) {
            _timePassed = state.timePassed;
          }
        },
        builder: (context, state) =>
            (_isPreview ? _preview(context) : _test(context)));
  }

  Map<CirclePoint, Set<CirclePoint>> _connectionsFromGraph(
      List<EmptyCirclePoint> points, List<List<int>> graph) {
    Map<CirclePoint, Set<CirclePoint>> connections = Map();
    for (var i = 0; i < graph.length; i++) {
      connections[points[i]] =
          graph[i].map((int otherId) => points[otherId]).toSet();
    }
    return connections;
  }

  Widget _preview(BuildContext context) => SliverList(
          delegate: SliverChildListDelegate([
        Container(
            margin: EdgeInsets.symmetric(horizontal: 24),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Cоедините точки линией, не отрывая пальца",
                  style: Theme.of(context)
                      .textTheme
                      .headline1!
                      .copyWith(color: Colors.black)),
              SizedBox(height: 16),
              ConstrainedBox(
                  constraints:
                      BoxConstraints(minHeight: 220, minWidth: double.infinity),
                  child: CircleConnectionWidget(
                      isPreview: true,
                      initialPoints: widget.points,
                      connections:
                          _connectionsFromGraph(widget.points, widget.graph))),
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
                  'Пример',
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
                  title: 'Начать',
                  onTap: () {
                    _isPreview = false;
                  }),
              SizedBox(height: 24),
            ]))
      ]));

  Widget _test(BuildContext context) => SliverFillRemaining(
      hasScrollBody: false,
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 24),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Cоедините точки линией, не отрывая пальца",
                style: Theme.of(context)
                    .textTheme
                    .headline1!
                    .copyWith(color: Colors.black)),
            SizedBox(height: 16),
            ConstrainedBox(
                constraints:
                    BoxConstraints(minHeight: 220, minWidth: double.infinity),
                child: CircleConnectionWidget(
                  continuousConnection: true,
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
          ])));
}
