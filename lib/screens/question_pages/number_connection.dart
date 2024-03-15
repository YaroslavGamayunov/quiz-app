import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pep/blocs/test_bloc.dart';
import 'package:pep/blocs/test_bloc_state.dart';
import 'package:pep/constants.dart';
import 'package:pep/questions.dart';
import 'package:pep/screens/question_pages/test_page.dart';
import 'package:pep/util/widgets.dart';

class NumberConnectionPage extends StatefulWidget implements ITestPage {
  final List<NumberPoint> points;
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
                          child: NumberConnectionWidget(
                              initialPoints: widget.points)),
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

class NumberConnectionWidget extends StatefulWidget {
  final List<NumberPoint> initialPoints;

  NumberConnectionWidget({required this.initialPoints});

  @override
  _NumberConnectionWidgetState createState() => _NumberConnectionWidgetState();
}

class _PointCircle {
  Offset center;
  Offset textOffset;
  double radius;

  _PointCircle(
      {required this.center, required this.radius, required this.textOffset});

  bool contains(Offset? other) {
    if (other == null) {
      return false;
    }
    return (center - other).distance < radius;
  }
}

class _NumberCanvasPainter extends CustomPainter {
  Offset? touchStart;
  Offset? touchEnd;

  ValueNotifier<_Segment> repaint;

  final TextStyle textStyle;
  List<NumberPoint> points;
  Map<NumberPoint, Set<NumberPoint>> connections;
  Set<NumberPoint> processedPoints = Set();

  _NumberCanvasPainter(
      {required this.touchStart,
      required this.touchEnd,
      required this.points,
      required this.connections,
      required this.repaint,
      required this.textStyle})
      : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    _drawLines(canvas, size);
    _drawCircles(canvas, size);
  }

  Offset _getCanvasOffset(NumberPoint point, Size size) {
    double canvasX = point.x * size.width;
    double canvasY = point.y * size.height;
    return Offset(canvasX, canvasY);
  }

  void _drawLines(Canvas canvas, Size size) {
    Paint linePaint = Paint()
      ..color = kPrimaryColor
      ..style = PaintingStyle.fill
      ..strokeWidth = 10;
    NumberPoint? touchStartPoint;
    NumberPoint? touchEndPoint;

    for (var point in points) {
      processedPoints.add(point);
      connections[point]?.forEach((endPoint) {
        if (!processedPoints.contains(endPoint)) {
          canvas.drawLine(_getCanvasOffset(point, size),
              _getCanvasOffset(endPoint, size), linePaint);
        }
      });

      var circle = _getPointCircle(size, point: point);

      if (circle.contains(touchStart)) {
        touchStartPoint = point;
      } else if (circle.contains(touchEnd)) {
        touchEndPoint = point;
      }
    }

    if (touchStart == null || touchEnd == null) return;

    if (touchStartPoint != null) {
      if (touchEndPoint != null) {
        canvas.drawLine(_getCanvasOffset(touchStartPoint, size),
            _getCanvasOffset(touchEndPoint, size), linePaint);
        _connectPoints(touchStartPoint, touchEndPoint);
        repaint.value = _Segment(null, null);
      } else {
        canvas.drawLine(
            _getCanvasOffset(touchStartPoint, size), touchEnd!, linePaint);
      }
    }
  }

  void _connectPoints(NumberPoint a, NumberPoint b) {
    if (connections[a] == null) {
      connections[a] = Set();
    }
    if (connections[b] == null) {
      connections[b] = Set();
    }
    connections[a]!.add(b);
    connections[b]!.add(a);
  }

  TextPainter _getPointTextPainter(NumberPoint point) {
    TextSpan span = TextSpan(style: textStyle, text: point.number.toString());
    return TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr);
  }

  _PointCircle _getPointCircle(Size size,
      {TextPainter? textPainter, required NumberPoint point}) {
    TextPainter tp = textPainter ?? _getPointTextPainter(point);
    tp.layout();
    double circleRadius = max(tp.width, tp.height) / 2 + 7;
    return _PointCircle(
        center: _getCanvasOffset(point, size),
        textOffset: -Offset(tp.width / 2, tp.height / 2),
        radius: circleRadius);
  }

  void _drawCircles(Canvas canvas, Size size) {
    for (var point in points) {
      TextPainter pointTextPainter = _getPointTextPainter(point);

      _PointCircle _circle =
          _getPointCircle(size, point: point, textPainter: pointTextPainter);

      bool isSelected = connections[point]?.isNotEmpty ?? false;
      if (_circle.contains(touchStart) || _circle.contains(touchEnd)) {
        isSelected = true;
      }

      canvas.drawCircle(
          _circle.center, _circle.radius, _getCirclePaint(isSelected));

      pointTextPainter.layout();
      pointTextPainter.paint(canvas, _circle.center + _circle.textOffset);
    }
  }

  Paint _getCirclePaint(bool isSelected) => Paint()
    ..color = (isSelected ? kPrimaryColor : kSecondaryTextColor)
    ..style = PaintingStyle.fill;

  @override
  bool shouldRepaint(_NumberCanvasPainter oldDelegate) {
    return oldDelegate.touchStart != touchStart ||
        oldDelegate.touchEnd != touchEnd;
  }

  @override
  bool shouldRebuildSemantics(_NumberCanvasPainter oldDelegate) => false;
}

class _Segment {
  Offset? start;
  Offset? end;

  _Segment(this.start, this.end);
}

class _NumberConnectionWidgetState extends State<NumberConnectionWidget> {
  Offset? start;
  Offset? end;
  Map<NumberPoint, Set<NumberPoint>> connections = Map();
  ValueNotifier<_Segment> repaintNotifier =
      ValueNotifier<_Segment>(_Segment(null, null));

  @override
  void initState() {
    super.initState();
    repaintNotifier.addListener(() {
      start = repaintNotifier.value.start;
      end = repaintNotifier.value.end;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => print('t'),
        onPanStart: (details) {
          print(details.localPosition);
          setState(() {
            start = details.localPosition;
            end = null;
          });
        },
        onPanUpdate: (details) {
          print("pan update");
          setState(() {
            end = details.localPosition;
          });
        },
        onPanEnd: (details) {
          setState(() {
            start = null;
            end = null;
          });
        },
        child: CustomPaint(
            painter: _NumberCanvasPainter(
                connections: connections,
                touchStart: this.start,
                touchEnd: this.end,
                points: widget.initialPoints,
                repaint: repaintNotifier,
                textStyle: Theme.of(context)
                    .textTheme
                    .headline1!
                    .copyWith(color: Colors.white))));
  }

  @override
  void dispose() {
    repaintNotifier.dispose();
    super.dispose();
  }
}
