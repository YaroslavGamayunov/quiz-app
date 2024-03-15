import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../constants.dart';
import '../../../../questions.dart';

class CircleConnectionPainter extends CustomPainter {
  final bool isPreview;
  Offset? touchStart;
  Offset? touchEnd;
  final double minCircleRadius;

  ValueNotifier<Segment> repaint;

  final TextStyle textStyle;
  List<CirclePoint> points;
  Map<CirclePoint, Set<CirclePoint>> connections;

  CircleConnectionPainter(
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
        repaint.value = Segment(touchEnd, touchEnd);
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
  bool shouldRepaint(CircleConnectionPainter oldDelegate) {
    return oldDelegate.touchStart != touchStart ||
        oldDelegate.touchEnd != touchEnd ||
        oldDelegate.connections != connections;
  }

  @override
  bool shouldRebuildSemantics(CircleConnectionPainter oldDelegate) => false;
}

class Segment {
  Offset? start;
  Offset? end;

  Segment(this.start, this.end);
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
