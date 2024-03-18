import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:quizapp/screens/question_pages/test_page.dart';
import 'package:quizapp/widgets.dart';

import '../../data/image_cache_manager.dart';

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
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(questionText,
                style: Theme.of(context)
                    .textTheme
                    .displayLarge!
                    .copyWith(color: Colors.black)),
            SizedBox(height: 24),
            ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 300),
                child: Image(
                  image: CachedNetworkImageProvider(imageUrl,
                      cacheManager: QuestionImagesCacheManager()),
                )),
            SizedBox(height: 24),
            Row(
              children: [
                Flexible(
                    child: QuizAppButton(
                        title: 'Да',
                        onTap: () {
                          onAnswer('yes');
                        })),
                SizedBox(width: 8),
                Flexible(
                    child: QuizAppButton(
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
