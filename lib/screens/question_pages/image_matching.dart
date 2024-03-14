import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pep/constants.dart';
import 'package:pep/screens/question_pages/test_page.dart';
import 'package:pep/util/widgets.dart';
import 'package:transparent_image/transparent_image.dart';

class ImageMatchingQuestionPage extends StatefulWidget implements ITestPage {
  final List<String> imageUrls;
  final List<String> words;
  final String questionText;

  ImageMatchingQuestionPage(
      {required this.onAnswer,
      required this.imageUrls,
      required this.words,
      required this.questionText});

  @override
  _ImageMatchingQuestionPageState createState() =>
      _ImageMatchingQuestionPageState();

  @override
  final Function(dynamic) onAnswer;
}

class _ImageMatchingQuestionPageState extends State<ImageMatchingQuestionPage> {
  late List<Color> imageColor;
  late List<int?> pickedImageIndex; // index of image picked for i-th word
  late List<int?> pickedWordIndex; // index of word picked for i-th image
  bool isFormFilled = false;

  int? currentPickedImage;

  @override
  void initState() {
    super.initState();
    Random _random = Random();
    imageColor = List.generate(widget.imageUrls.length,
        (index) => Colors.primaries[_random.nextInt(Colors.primaries.length)]);
    pickedImageIndex = List.filled(widget.words.length, null);
    pickedWordIndex = List.filled(widget.words.length, null);
  }

  @override
  Widget build(BuildContext context) {
    int i = 0;
    List<Widget> images = List.generate(widget.imageUrls.length * 2, (index) {
      if (index % 2 == 1) {
        return SizedBox(height: 16);
      }

      int id = i;
      Color color = (currentPickedImage == id || pickedWordIndex[id] != null
          ? imageColor[id]
          : kSecondaryTextColor);
      var image = _ImageContainer(
        imageUrl: widget.imageUrls[i],
        color: color,
        onTap: () {
          currentPickedImage = id;
          setState(() {});
        },
      );
      i++;
      return image;
    });

    i = 0;
    List<Widget> words = List.generate(widget.words.length * 2, (index) {
      if (index % 2 == 1) {
        return SizedBox(height: 16);
      }
      int wordId = i;
      var container = _WordContainer(
          word: widget.words[wordId],
          color: _getCurrentColor(wordId),
          onTap: () {
            int? alreadyPickedWord = pickedWordIndex[currentPickedImage!];

            if (alreadyPickedWord != null) {
              pickedImageIndex[alreadyPickedWord] = null;
              pickedWordIndex[currentPickedImage!] = null;
            }

            int? alreadyPickedImage = pickedImageIndex[wordId];
            if (alreadyPickedImage != null) {
              pickedWordIndex[alreadyPickedImage] = null;
              pickedImageIndex[wordId] = null;
            }

            pickedWordIndex[currentPickedImage!] = wordId;
            pickedImageIndex[wordId] = currentPickedImage!;

            setState(() {
              isFormFilled = !pickedImageIndex.contains(null);
            });
          });
      i++;
      return container;
    });

    return SliverList(
        delegate: SliverChildListDelegate([
      Container(
          margin: EdgeInsets.symmetric(horizontal: 24),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(widget.questionText,
                style: Theme.of(context)
                    .textTheme
                    .headline1!
                    .copyWith(color: Colors.black)),
            SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: images,
                ),
                Spacer(),
                SizedBox(width: 16),
                Spacer(),
                Column(
                  children: words,
                )
              ],
            ),
            PepButton(
                title: "Продолжить",
                color: (isFormFilled ? kPrimaryColor : kSecondaryTextColor),
                onTap: () {
                  if (isFormFilled) {
                    widget.onAnswer(pickedImageIndex);
                  }
                }),
            SizedBox(height: 24)
          ]))
    ]));
  }

  Color? _getCurrentColor(int wordId) {
    return (pickedImageIndex[wordId] == null
        ? null
        : imageColor[pickedImageIndex[wordId]!]);
  }
}

class _ImageContainer extends StatelessWidget {
  final String imageUrl;
  final Color color;
  final Function() onTap;

  _ImageContainer(
      {required this.imageUrl, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkResponse(
        onTap: onTap,
        child: Container(
            foregroundDecoration: BoxDecoration(
                border: Border.all(color: color, width: 4.0),
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.5 - 48),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage, image: imageUrl)))));
  }
}

class _WordContainer extends StatelessWidget {
  final String word;
  final Color? color;
  final Function() onTap;

  _WordContainer(
      {required this.word, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5 - 24,
      child: Material(
          color: color ?? kSecondaryTextColor,
          borderRadius: BorderRadius.circular(5),
          shadowColor: Colors.black,
          child: InkWell(
            borderRadius: BorderRadius.circular(5),
            onTap: onTap,
            child: Container(
                padding:
                    EdgeInsets.only(left: 24, right: 24, top: 40, bottom: 40),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(word,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .button!
                        .copyWith(color: Colors.white))),
          )),
    );
  }
}
