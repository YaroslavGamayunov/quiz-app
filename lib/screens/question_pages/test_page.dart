abstract class ITestPage {
  final Function(dynamic result) onAnswer;

  ITestPage({required this.onAnswer});
}
