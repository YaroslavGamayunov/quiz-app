import '../../../../questions.dart';

class CircleConnectionController {
  late Function() clearConnections;
  Function(Map<CirclePoint, Set<CirclePoint>>)? connectionFinishedListener;
}