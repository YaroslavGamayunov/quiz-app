import 'package:flutter/material.dart';

class PepButton extends StatelessWidget {

  final String title;
  final void Function() onTap;
  final Color? color;
  final Widget? icon;

  PepButton({required this.title, required this.onTap, this.color, this.icon}) : super();

  @override
  Widget build(BuildContext context) {
    Color buttonColor = color == null ? Theme.of(context).accentColor : color!;
    return Material(
        color: buttonColor,
        borderRadius: BorderRadius.circular(5),
        shadowColor: Colors.black,
        child: InkWell(borderRadius: BorderRadius.circular(5), onTap: onTap, child:
        Container(height: 64, decoration: BoxDecoration( borderRadius: BorderRadius.circular(5),),child:
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          icon != null ? Row(children: [
            icon!,
            SizedBox(width: 10),
          ],) : SizedBox.shrink(),
          Text(title, style: Theme.of(context).textTheme.button!.copyWith(color: Colors.white))
        ],)
        ),
        ));
  }
}