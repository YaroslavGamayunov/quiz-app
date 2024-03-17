import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quizapp/constants.dart';

class QuizAppButton extends StatelessWidget {
  final String title;
  final void Function() onTap;
  final Color? color;
  final Widget? icon;

  QuizAppButton({required this.title, required this.onTap, this.color, this.icon})
      : super();

  @override
  Widget build(BuildContext context) {
    Color buttonColor =
        color == null ? Theme.of(context).colorScheme.secondary : color!;
    return Material(
        color: buttonColor,
        borderRadius: BorderRadius.circular(5),
        shadowColor: Colors.black,
        child: InkWell(
          borderRadius: BorderRadius.circular(5),
          onTap: onTap,
          child: Container(
              height: 64,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon != null
                      ? Row(
                          children: [
                            icon!,
                            SizedBox(width: 10),
                          ],
                        )
                      : SizedBox.shrink(),
                  Text(title,
                      style: Theme.of(context)
                          .textTheme
                          .button!
                          .copyWith(color: Colors.white))
                ],
              )),
        ));
  }
}

class QuizAppFormField extends StatelessWidget {
  final String hint;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;
  final TextEditingController? controller;
  final bool obscureText;
  final bool autoFocus;
  final FocusNode? focusNode;

  QuizAppFormField(
      {Key? key,
      this.hint = "",
      this.validator,
      this.controller,
      this.onSaved,
      this.focusNode,
      this.autoFocus = false,
      this.obscureText = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: kInputBackgroundColor, borderRadius: BorderRadius.circular(5)),
      child: TextFormField(
          autofocus: autoFocus,
          focusNode: focusNode,
          controller: controller,
          validator: validator,
          obscureText: obscureText,
          onSaved: onSaved,
          decoration: InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintText: hint,
              hintStyle: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: kSecondaryTextColor),
              contentPadding: EdgeInsets.all(16)),
          style: Theme.of(context).textTheme.bodyText1!),
    );
  }
}

class QuizAppTestResultCard extends StatelessWidget {
  final double resultPercent;
  final Widget text;

  QuizAppTestResultCard({required this.resultPercent, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Color(0x1a000000),
            blurRadius: 20,
            spreadRadius: 5,
            offset: Offset(0, 1), // changes position of shadow
          )
        ]),
        child: Material(
            borderRadius: BorderRadius.circular(5),
            child: Container(
                padding:
                    EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 24),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: text),
                            SizedBox(width: 32),
                            InkResponse(
                                child: Container(
                                    child: SvgPicture.asset(
                                        'assets/ic_arrow_right.svg')),
                                onTap: () {}),
                          ]),
                      SizedBox(height: 8),
                      Text(
                        '${(resultPercent * 100).round()}%',
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge!
                            .copyWith(color: _getResultColor(resultPercent)),
                      ),
                      LinearProgressIndicator(
                        color: _getResultColor(resultPercent),
                        backgroundColor: kInputBackgroundColor,
                        minHeight: 5.0,
                        value: resultPercent,
                      ),
                    ]))));
  }

  Color _getResultColor(double percent) {
    if (percent < 0.75) {
      return Color(0xffe27c04);
    }
    return kPrimaryColor;
  }
}
