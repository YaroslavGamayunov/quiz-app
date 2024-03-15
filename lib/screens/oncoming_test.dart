import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizapp/blocs/test/test_bloc.dart';
import 'package:quizapp/blocs/test/test_bloc_state.dart';
import 'package:quizapp/constants.dart';
import 'package:quizapp/screens/test.dart';
import 'package:quizapp/util/widgets.dart';

class OncomingTestPage extends StatefulWidget {
  @override
  _OncomingTestPageState createState() => _OncomingTestPageState();
}

class _OncomingTestPageState extends State<OncomingTestPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TestBloc, TestBlocState>(
        builder: (context, state) => Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                      SizedBox(height: 82),
                      Text('Пройти тест',
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(color: Colors.black)),
                      SizedBox(height: 12),
                    ] +
                    (state is TestAvailable
                        ? _buildTestAvailableState()
                        : _buildTestNotAvailableState()))));
  }

  List<Widget> _buildTestAvailableState() {
    return [
      Text('Тест доступен',
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: kSecondaryTextColor)),
      Spacer(),
      QuizAppButton(
          title: 'Начать тест',
          onTap: () {
            setState(() {});
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => TestPage()),
                (route) => false);
          }),
      Spacer()
    ];
  }

  List<Widget> _buildTestNotAvailableState() {
    return [
      Spacer(),
      Text('Доступных тестов нет :(',
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: kSecondaryTextColor)),
      Spacer()
    ];
  }
}
