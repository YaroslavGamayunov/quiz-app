import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pep/questions.dart';

import '../../../constants.dart';

class _CircleConnectionPainter extends CustomPainter {
  final bool isPreview;
  Offset? touchStart;
  Offset? touchEnd;
  final double minCircleRadius;

  ValueNotifier<_Segment> repaint;

  final TextStyle textStyle;
  List<CirclePoint> points;
  Map<CirclePoint, Set<CirclePoint>> connections;

  _CircleConnectionPainter(
      {this.isPreview = false,
      required this.touchStart,
      required this.touchEnd,
      required this.points,
      required this.connections,
      required this.repaint,
      required this.minCircleRadius,
      required this.textStyle})
      : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    _drawLines(canvas, size);
    _drawCircles(canvas, size);
  }

  Offset _getCanvasOffset(CirclePoint point, Size size) {
    double canvasX = point.x * size.width;
    double canvasY = point.y * size.height;
    return Offset(canvasX, canvasY);
  }

  void _drawLines(Canvas canvas, Size size) {
    Paint linePaint = Paint()
      ..color = kPrimaryColor
      ..style = PaintingStyle.fill
      ..strokeWidth = 10;
    CirclePoint? touchStartPoint;
    CirclePoint? touchEndPoint;

    Set<CirclePoint> processedPoints = Set();
    for (var point in points) {
      processedPoints.add(point);
      connections[point]?.forEach((endPoint) {
        if (!processedPoints.contains(endPoint)) {
          canvas.drawLine(_getCanvasOffset(point, size),
              _getCanvasOffset(endPoint, size), linePaint);
        }
      });

      var circle = _getCircle(size, point: point);

      if (circle.contains(touchStart)) {
        touchStartPoint = point;
      } else if (circle.contains(touchEnd)) {
        touchEndPoint = point;
      }
    }

    if (isPreview || touchStart == null || touchEnd == null) return;

    if (touchStartPoint != null) {
      if (touchEndPoint != null) {
        canvas.drawLine(_getCanvasOffset(touchStartPoint, size),
            _getCanvasOffset(touchEndPoint, size), linePaint);
        _connectPoints(touchStartPoint, touchEndPoint);
        repaint.value = _Segment(touchEnd, touchEnd);
      } else {
        canvas.drawLine(
            _getCanvasOffset(touchStartPoint, size), touchEnd!, linePaint);
      }
    }
  }

  void _connectPoints(CirclePoint a, CirclePoint b) {
    if (connections[a] == null) {
      connections[a] = Set();
    }
    if (connections[b] == null) {
      connections[b] = Set();
    }
    connections[a]!.add(b);
    connections[b]!.add(a);
  }

  TextPainter _getPointTextPainter(CirclePoint point) {
    TextSpan span = TextSpan(style: textStyle, text: point.text);
    return TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr);
  }

  _Circle _getCircle(Size size,
      {TextPainter? textPainter, required CirclePoint point}) {
    TextPainter tp = textPainter ?? _getPointTextPainter(point);
    tp.layout();
    double circleRadius = point.text.isNotEmpty
        ? max(max(tp.width, tp.height) / 2 + 7, minCircleRadius)
        : minCircleRadius;
    return _Circle(
        center: _getCanvasOffset(point, size),
        textOffset: -Offset(tp.width / 2, tp.height / 2),
        radius: circleRadius);
  }

  void _drawCircles(Canvas canvas, Size size) {
    for (var point in points) {
      TextPainter pointTextPainter = _getPointTextPainter(point);

      _Circle _circle =
          _getCircle(size, point: point, textPainter: pointTextPainter);

      bool isSelected = connections[point]?.isNotEmpty ?? false;
      if (_circle.contains(touchStart) || _circle.contains(touchEnd)) {
        isSelected = true;
      }

      if (isPreview) {
        isSelected = false;
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
  bool shouldRepaint(_CircleConnectionPainter oldDelegate) {
    return oldDelegate.touchStart != touchStart ||
        oldDelegate.touchEnd != touchEnd ||
        oldDelegate.connections != connections;
  }

  @override
  bool shouldRebuildSemantics(_CircleConnectionPainter oldDelegate) => false;
}

class CircleConnectionWidget extends StatefulWidget {
  final bool isPreview;
  final bool continuousConnection;

  final double minCircleRadius;
  final List<CirclePoint> initialPoints;
  final Map<CirclePoint, Set<CirclePoint>>? connections;

  CircleConnectionWidget(
      {this.continuousConnection = false,
      this.isPreview = false,
      required this.initialPoints,
      this.minCircleRadius = 15,
      this.connections});

  @override
  _CircleConnectionWidgetState createState() => _CircleConnectionWidgetState();
}

class _CircleConnectionWidgetState extends State<CircleConnectionWidget> {
  Offset? start;
  Offset? end;
  late Map<CirclePoint, Set<CirclePoint>> connections;
  ValueNotifier<_Segment> repaintNotifier =
      ValueNotifier<_Segment>(_Segment(null, null));

  @override
  void initState() {
    super.initState();
    connections = widget.connections ?? Map();
    repaintNotifier.addListener(() {
      start = repaintNotifier.value.start;
      end = repaintNotifier.value.end;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onPanStart: (details) {
          print(details.localPosition);
          setState(() {
            start = details.localPosition;
            end = null;
          });
        },
        onPanUpdate: (details) {
          setState(() {
            end = details.localPosition;
          });
        },
        onPanEnd: (details) {
          if (widget.continuousConnection) {
            connections.clear();
            repaintNotifier.value = _Segment(null, null);
          }
          setState(() {
            start = null;
            end = null;
          });
        },
        child: CustomPaint(
            painter: _CircleConnectionPainter(
                isPreview: widget.isPreview,
                minCircleRadius: widget.minCircleRadius,
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

class _Segment {
  Offset? start;
  Offset? end;

  _Segment(this.start, this.end);
}

class _Circle {
  Offset center;
  Offset textOffset;
  double radius;

  _Circle(
      {required this.center, required this.radius, required this.textOffset});

  bool contains(Offset? other) {
    if (other == null) {
      return false;
    }
    return (center - other).distance < radius;
  }
}
