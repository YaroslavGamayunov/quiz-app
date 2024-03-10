import 'package:flutter/material.dart';
import 'package:pep/constants.dart';

class PepButton extends StatelessWidget {
  final String title;
  final void Function() onTap;
  final Color? color;
  final Widget? icon;

  PepButton({required this.title, required this.onTap, this.color, this.icon})
      : super();

  @override
  Widget build(BuildContext context) {
    Color buttonColor = color == null ? Theme.of(context).accentColor : color!;
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

class PepFormField extends StatelessWidget {
  final String hint;
  final FormFieldValidator<String> validator;

  PepFormField({Key? key, this.hint = "", required this.validator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xfff0f0f0), borderRadius: BorderRadius.circular(5)),
      child: TextFormField(
          validator: validator,
          decoration: InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintText: hint,
              hintStyle: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: kSecondaryTextColor),
              contentPadding: EdgeInsets.all(16)),
          style: Theme.of(context).textTheme.bodyText1!),
    );
  }
}
