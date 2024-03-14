import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pep/blocs/test_bloc.dart';
import 'package:pep/blocs/test_bloc_state.dart';
import 'package:pep/constants.dart';
import 'package:pep/screens/question_pages/test_page.dart';
import 'package:pep/util/widgets.dart';

class SchulteTableQuestionPage extends StatefulWidget implements ITestPage {
  final List<String> cells;
  final String description;

  SchulteTableQuestionPage(
      {required this.onAnswer, required this.cells, required this.description});

  @override
  State<StatefulWidget> createState() => _SchulteTableQuestionPageState();

  @override
  final Function(dynamic) onAnswer;
}

class _SchulteTableQuestionPageState extends State<SchulteTableQuestionPage> {
  late List<bool> isSelected;
  List<int> selectionOrder = [];
  int _timePassed = 0;

  @override
  void initState() {
    super.initState();
    isSelected = List.filled(widget.cells.length, false);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> cells = [];
    for (var i = 0; i < widget.cells.length; i++) {
      cells.add(_buildCell(
          text: widget.cells[i],
          isSelected: isSelected[i],
          onTap: () {
            if (!isSelected[i]) {
              isSelected[i] = true;
              selectionOrder.add(i);
              setState(() {});
            }
          }));
    }

    return BlocConsumer<TestBloc, TestBlocState>(
        listener: (context, state) {
          if (state is OnQuestion) {
            _timePassed = state.timePassed;
          }
        },
        builder: (context, state) => SliverList(
                delegate: SliverChildListDelegate([
              Container(
                margin: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Таблица Шульте",
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
                  ],
                ),
              ),
              GridView.count(
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  crossAxisCount: 5,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 5,
                  shrinkWrap: true,
                  children: cells),
              SizedBox(height: 24),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(children: [
                    Text(
                      'Таймер',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(color: kSecondaryTextColor),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      '${_timePassed} cекунд',
                      style: Theme.of(context)
                          .textTheme
                          .button!
                          .copyWith(color: kPrimaryColor),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24),
                    PepButton(
                        title: 'Продолжить',
                        onTap: () {
                          widget.onAnswer(selectionOrder);
                        }),
                    SizedBox(height: 24),
                  ]))
            ])));
  }

  Widget _buildCell(
      {required String text,
      required bool isSelected,
      required Function() onTap}) {
    return Material(
        color: (isSelected ? kPrimaryColor : kSecondaryTextColor),
        borderRadius: BorderRadius.circular(5),
        shadowColor: Colors.black,
        child: InkWell(
          borderRadius: BorderRadius.circular(5),
          onTap: onTap,
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                  child: Text(text,
                      style: Theme.of(context)
                          .textTheme
                          .headline1!
                          .copyWith(color: Colors.white)))),
        ));
  }
}
