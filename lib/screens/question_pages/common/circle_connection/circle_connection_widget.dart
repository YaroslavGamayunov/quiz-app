import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:pep/questions.dart';

import 'circle_connection_controller.dart';
import 'circle_connection_painter.dart';

class CircleConnectionWidget extends StatefulWidget {
  final bool isPreview;
  final bool continuousConnection;
  final CircleConnectionController? controller;

  final double minCircleRadius;
  final List<CirclePoint> initialPoints;
  final Map<CirclePoint, Set<CirclePoint>>? connections;

  CircleConnectionWidget(
      {this.controller,
      this.continuousConnection = false,
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
  bool canAddNewConnection = true;
  late Map<CirclePoint, Set<CirclePoint>> connections;
  ValueNotifier<Segment> repaintNotifier =
      ValueNotifier<Segment>(Segment(null, null));

  @override
  void initState() {
    widget.controller?.clearConnections = _clearConnections;
    connections = widget.connections ?? Map();
    repaintNotifier.addListener(() {
      start = repaintNotifier.value.start;
      end = repaintNotifier.value.end;
    });
    super.initState();
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
          developer.log("Pan end");
          if (widget.continuousConnection) {
            developer.log("connectionFinishedListener == ${widget.controller?.connectionFinishedListener}");
            canAddNewConnection = false;
            widget.controller?.connectionFinishedListener?.call(connections);
          }
          setState(() {
            start = null;
            end = null;
          });
        },
        child: CustomPaint(
            painter: CircleConnectionPainter(
                isPreview: widget.isPreview || !canAddNewConnection,
                minCircleRadius: widget.minCircleRadius,
                connections: connections,
                touchStart: this.start,
                touchEnd: this.end,
                points: widget.initialPoints,
                repaint: repaintNotifier,
                textStyle: Theme.of(context)
                    .textTheme
                    .displayLarge!
                    .copyWith(color: Colors.white))));
  }

  void _clearConnections() {
    connections.clear();
    repaintNotifier.value = Segment(null, null);
  }

  @override
  void dispose() {
    repaintNotifier.dispose();
    super.dispose();
  }
}
