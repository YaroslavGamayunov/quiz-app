import 'dart:developer' as developer;

import 'package:bitmap/bitmap.dart';
import 'package:flutter/material.dart';
import 'package:quizapp/constants.dart';
import 'package:quizapp/screens/question_pages/test_page.dart';
import 'package:quizapp/util/widgets.dart';

import 'image_puzzle_widget.dart';

class ImagePuzzlePage extends StatefulWidget implements ITestPage {
  final String imageUrl;
  final List<int> puzzlePermutation;

  ImagePuzzlePage(
      {required this.onAnswer,
      required this.imageUrl,
      required this.puzzlePermutation});

  @override
  final Function(dynamic) onAnswer;

  @override
  _ImagePuzzlePageState createState() => _ImagePuzzlePageState();
}

class _ImagePuzzlePageState extends State<ImagePuzzlePage> {
  final int rows = 3;
  final int columns = 3;

  bool isPreview = true;
  bool isCompleted = false;

  Bitmap? image;

  @override
  void initState() {
    super.initState();
    Bitmap.fromProvider(NetworkImage(widget.imageUrl)).then((value) {
      setState(() {
        developer.log("loaded image", name: 'puzzle');
        image = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
        delegate: SliverChildListDelegate([
          image == null
              ? Center(child: CircularProgressIndicator())
              : isPreview
              ? _preview(context, image!)
              : _puzzle(context, image!)
        ]));
  }

  Widget _preview(BuildContext context, Bitmap image) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Повторите картинку",
              style: Theme.of(context)
                  .textTheme
                  .displayLarge!
                  .copyWith(color: Colors.black)),
          SizedBox(height: 32),
          SizedBox(
              child: PuzzleGrid(
                  image: image,
                  crossAxisCount: 3,
                  splitRows: 3,
                  splitColumns: 3)),
          SizedBox(height: 24),
          QuizAppButton(
              title: "Продолжить",
              onTap: () {
                setState(() {
                  isPreview = false;
                });
              }),
        ]));
  }

  Widget _puzzle(BuildContext context, Bitmap image) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 24),
        child: Column(children: [
          PuzzleWidget(
            rows: 3,
            columns: 3,
            image: image,
            initialPermutation: widget.puzzlePermutation,
            onCompleted: (value) {
              setState(() {
                isCompleted = value;
              });
            },
          ),
          SizedBox(height: 24),
          QuizAppButton(
              title: "Продолжить",
              color: (isCompleted ? kPrimaryColor : kSecondaryTextColor),
              onTap: () {
                if (isCompleted) {
                  widget.onAnswer(null);
                }
              }),
          SizedBox(height: 24),
        ]));
  }
}
