import 'dart:developer' as developer;

import 'package:bitmap/bitmap.dart';
import 'package:flutter/material.dart';
import 'package:pep/constants.dart';
import 'package:pep/screens/question_pages/test_page.dart';
import 'package:pep/util/widgets.dart';

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
                  .headline1!
                  .copyWith(color: Colors.black)),
          SizedBox(height: 32),
          SizedBox(
              child: _PuzzleGrid(
                  image: image,
                  crossAxisCount: 3,
                  splitRows: 3,
                  splitColumns: 3)),
          SizedBox(height: 24),
          PepButton(
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
          _PuzzleWidget(
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
          PepButton(
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

class _PuzzleWidget extends StatefulWidget {
  final Bitmap image;
  final Function(bool completed) onCompleted;
  final int rows;
  final int columns;
  final List<int> initialPermutation;

  _PuzzleWidget(
      {required this.image,
      required this.onCompleted,
      required this.rows,
      required this.columns,
      required this.initialPermutation});

  @override
  _PuzzleWidgetState createState() => _PuzzleWidgetState();
}

class _PuzzleWidgetState extends State<_PuzzleWidget> {
  late List<int> inserted; // ids from top grid
  late List<int> tilePositionById;
  int? currentlySelectedTileId;
  _PuzzleGridController _bottomGridController = _PuzzleGridController();
  _PuzzleGridController _topGridController = _PuzzleGridController();

  @override
  void initState() {
    super.initState();
    tilePositionById =
        List.generate(widget.rows * widget.columns, (index) => -1);
    inserted = List.generate(widget.rows * widget.columns, (index) => -1);
  }

  @override
  void dispose() {
    _bottomGridController.dispose();
    _topGridController.dispose();
    super.dispose();
  }

  void _checkCorrectness() {
    bool isCorrect = true;
    for (int i = 0; i < widget.rows * widget.columns; i++) {
      if (inserted[i] != i) {
        isCorrect = false;
        break;
      }
    }
    widget.onCompleted(isCorrect);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(children: [
        Flexible(
            child: Text("Повторите картинку",
                style: Theme.of(context)
                    .textTheme
                    .displayLarge!
                    .copyWith(color: Colors.black))),
        SizedBox(
            width: 100,
            child: _PuzzleGrid(
                permutation: null,
                image: widget.image,
                crossAxisCount: 3,
                splitRows: 3,
                splitColumns: 3)),
      ]),
      SizedBox(height: 24),
      _PuzzleGrid(
          // This is a Top grid
          controller: _topGridController,
          permutation: inserted,
          onGridTap: (int? tileId, int position) {
            if (currentlySelectedTileId == null && inserted[position] != -1) {
              tilePositionById[inserted[position]] = -1;
              _bottomGridController.setSelectedTileId!(
                  inserted[position], false);
              _topGridController.setTile!(position, null);
              inserted[position] = -1;
              return;
            }

            _bottomGridController.clearActiveSelectionHighlight?.call();
            if (currentlySelectedTileId != null &&
                tilePositionById[currentlySelectedTileId!] == -1) {
              if (inserted[position] != -1 &&
                  inserted[position] != currentlySelectedTileId) {
                _bottomGridController.setSelectedTileId!(
                    inserted[position], false);
                tilePositionById[inserted[position]] = -1;
                inserted[position] = -1;
              }

              tilePositionById[currentlySelectedTileId!] = position;
              inserted[position] = currentlySelectedTileId!;
              _topGridController.setTile!(position, currentlySelectedTileId);
              currentlySelectedTileId = null;
            }
            _checkCorrectness();
          },
          image: widget.image,
          crossAxisCount: 3,
          splitRows: widget.rows,
          splitColumns: widget.columns),
      SizedBox(height: 32),
      _PuzzleGrid(
          // This is a Bottom grid
          controller: _bottomGridController,
          permutation: widget.initialPermutation,
          image: widget.image,
          onGridTap: (int? tileId, int position) {
            if (currentlySelectedTileId == tileId ||
                (tileId != null && tilePositionById[tileId] != -1)) {
              return;
            }
            if (currentlySelectedTileId != null) {
              _bottomGridController.setSelectedTileId!(
                  currentlySelectedTileId!, false);
            }
            currentlySelectedTileId = tileId;
            if (tileId != null) {
              _bottomGridController.setSelectedTileId!(
                  currentlySelectedTileId!, true);
            }
          },
          crossAxisCount: 4,
          splitRows: widget.rows,
          splitColumns: widget.columns),
    ]);
  }
}

class _PuzzleGridController {
  Function(int position, int? tileId)? setTile;
  Function(int tileId, bool isSelected)? setSelectedTileId;
  Function(int position, bool isSelected)? setSelectedPosition;
  Function()? clearActiveSelectionHighlight;

  void dispose() {
    setTile = null;
    setSelectedPosition = null;
    setSelectedPosition = null;
    clearActiveSelectionHighlight = null;
  }
}

class _PuzzleGrid extends StatefulWidget {
  final Bitmap image;
  final int splitColumns;
  final int splitRows;
  final int crossAxisCount;
  final List<int>? permutation;
  final _PuzzleGridController? controller;
  final Function(int? tileId, int position)? onGridTap;

  _PuzzleGrid(
      {required this.image,
      required this.crossAxisCount,
      required this.splitRows,
      this.permutation,
      required this.splitColumns,
      this.onGridTap,
      this.controller});

  @override
  _PuzzleGridState createState() => _PuzzleGridState();
}

class _PuzzleGridState extends State<_PuzzleGrid> {
  late List<_PuzzleTile> tiles;
  late final List<Bitmap> tileBitmaps;
  late List<int> positionByTileId;
  late List<int?> tileIdByPosition;
  int activeSelectionPosition = -1;

  void _splitIntoTiles(
      {required Bitmap image,
      required int rows,
      required int columns,
      Function(int? tileId, int position)? onGridTap,
      List<int>? permutation}) {
    if (permutation == null) {
      permutation = List.generate(rows * columns, (index) => index);
    }
    int tileWidth = (image.width / columns).floor();
    int tileHeight = (image.height / rows).floor();

    tileBitmaps = [];

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < columns; j++) {
        Bitmap tileBitmap = image.apply(BitmapCrop.fromLTWH(
            left: j * tileWidth,
            top: i * tileHeight,
            width: tileWidth,
            height: tileHeight));
        tileBitmaps.add(tileBitmap);
      }
    }

    tiles = [];
    positionByTileId = List.generate(rows * columns, (index) => -1);
    tileIdByPosition = permutation;

    for (int i = 0; i < (rows * columns); i++) {
      if (permutation[i] != -1) {
        positionByTileId[permutation[i]] = i;
      }
      tiles.add(_PuzzleTile(
        bitmap: ValueNotifier(
            permutation[i] == -1 ? null : tileBitmaps[permutation[i]]),
        selected: ValueNotifier(false),
        isActiveSelection: ValueNotifier(false),
        onTap: () {
          onGridTap?.call(tileIdByPosition[i], i);
        },
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    var controller = widget.controller;

    controller?.setSelectedPosition = _setSelectedPosition;
    controller?.setTile = _setTile;
    controller?.setSelectedTileId = _setSelectedTileId;
    controller?.clearActiveSelectionHighlight = _clearActiveSelectionHighlight;

    _splitIntoTiles(
        image: widget.image,
        rows: widget.splitRows,
        permutation: widget.permutation,
        onGridTap: widget.onGridTap,
        columns: widget.splitColumns);
  }

  void _setSelectedPosition(int position, bool isSelected) {
    tiles[position].selected.value = isSelected;
  }

  void _setTile(int position, int? tileId) {
    if (tileId == null) {
      tiles[position].bitmap.value = null;
    } else {
      tiles[position].bitmap.value = tileBitmaps[tileId];
    }
    tileIdByPosition[position] = tileId == null ? -1 : tileId;
  }

  void _setSelectedTileId(int tileId, bool isSelected) {
    if (positionByTileId[tileId] == -1) return;
    tiles[positionByTileId[tileId]].selected.value = isSelected;
    if (isSelected) {
      if (activeSelectionPosition != -1) {
        tiles[activeSelectionPosition].isActiveSelection.value = false;
      }
      tiles[positionByTileId[tileId]].isActiveSelection.value = true;
      activeSelectionPosition = positionByTileId[tileId];
    }
  }

  void _clearActiveSelectionHighlight() {
    if (activeSelectionPosition != -1) {
      tiles[activeSelectionPosition].isActiveSelection.value = false;
      activeSelectionPosition = -1;
    }
  }

  @override
  void dispose() {
    for (var tile in tiles) {
      tile.bitmap.dispose();
      tile.selected.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: widget.crossAxisCount,
      children: tiles,
    );
  }
}

class _PuzzleTile extends StatefulWidget {
  final ValueNotifier<Bitmap?> bitmap;
  final ValueNotifier<bool> selected;
  final ValueNotifier<bool> isActiveSelection;

  final Function()? onTap;

  _PuzzleTile(
      {required this.bitmap,
      required this.selected,
      required this.isActiveSelection,
      this.onTap});

  @override
  _PuzzleTileState createState() => _PuzzleTileState();
}

class _PuzzleTileState extends State<_PuzzleTile> {
  @override
  void initState() {
    super.initState();
    widget.selected.addListener(() {
      setState(() {});
    });
    widget.isActiveSelection.addListener(() {
      setState(() {});
    });
    widget.bitmap.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          widget.onTap?.call();
        },
        child: Container(
            decoration: BoxDecoration(
                border: Border.all(
                    color: widget.isActiveSelection.value
                        ? Colors.yellowAccent
                        : kSecondaryTextColor,
                    width: 1)),
            child: Opacity(
              child: _getImage(),
              opacity: (widget.selected.value ? 0.2 : 1.0),
            )));
  }

  Widget _getImage() {
    Bitmap? image = widget.bitmap.value;
    if (image != null) return Image.memory(image.buildHeaded());
    return Container(color: kInputBackgroundColor);
  }
}
