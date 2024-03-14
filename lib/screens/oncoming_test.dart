import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pep/blocs/test_bloc.dart';
import 'package:pep/blocs/test_bloc_state.dart';
import 'package:pep/constants.dart';
import 'package:pep/screens/test.dart';
import 'package:pep/util/widgets.dart';

class OncomingTestPage extends StatefulWidget {
  final void Function(Widget page) onPageChanged;

  OncomingTestPage({required this.onPageChanged});

  @override
  _OncomingTestPageState createState() => _OncomingTestPageState();
}

class _OncomingTestPageState extends State<OncomingTestPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TestBloc, TestBlocState>(
        builder: (context, state) => Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(height: 82),
              Text('Пройти тест',
                  style: Theme.of(context)
                      .textTheme
                      .headline1!
                      .copyWith(color: Colors.black)),
              SizedBox(height: 12),
              Text('Тест доступен',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: kSecondaryTextColor)),
              Spacer(),
              PepButton(
                  title: 'Начать тест',
                  onTap: () {
                    setState(() {});
                    if (state is TestAvailable) {
                      widget.onPageChanged(
                          TestPage(onPageChanged: widget.onPageChanged));
                    }
                  }),
              Spacer()
            ])));
  }
}
