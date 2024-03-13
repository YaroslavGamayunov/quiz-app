import 'package:flutter/material.dart';
import 'package:pep/screens/question_pages/test_page.dart';
import 'package:pep/util/widgets.dart';
import 'package:transparent_image/transparent_image.dart';

class BinaryAnswerQuestionPage extends StatelessWidget implements ITestPage {
  final String questionText;
  final String imageUrl;

  BinaryAnswerQuestionPage(
      {required this.questionText,
      required this.imageUrl,
      required this.onAnswer});

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
        hasScrollBody: false,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(questionText,
                style: Theme.of(context)
                    .textTheme
                    .headline1!
                    .copyWith(color: Colors.black)),
            SizedBox(height: 24),
            ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 300),
                child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: imageUrl,
                )),
            SizedBox(height: 24),
            Row(
              children: [
                Flexible(
                    child: PepButton(
                        title: 'Да',
                        onTap: () {
                          onAnswer('yes');
                        })),
                SizedBox(width: 8),
                Flexible(
                    child: PepButton(
                        color: Color(0xffC30000),
                        title: 'Нет',
                        onTap: () {
                          onAnswer('no');
                        }))
              ],
            ),
            SizedBox(height: 24)
          ]),
        ));
  }

  @override
  final Function(dynamic) onAnswer;
}
