import 'package:flutter/material.dart';

class NavigatorPage extends StatefulWidget {
  final Widget child;
  final GlobalKey navigatorKey;

  NavigatorPage({required this.child, required this.navigatorKey});

  @override
  _NavigatorPageState createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: widget.navigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            return widget.child;
          },
        );
      },
    );
  }
}
