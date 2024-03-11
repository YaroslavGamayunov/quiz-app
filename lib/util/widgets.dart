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
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;
  final TextEditingController? controller;
  final bool obscureText;
  final bool autoFocus;
  final FocusNode? focusNode;

  PepFormField(
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
                  .bodyText1!
                  .copyWith(color: kSecondaryTextColor),
              contentPadding: EdgeInsets.all(16)),
          style: Theme.of(context).textTheme.bodyText1!),
    );
  }
}

class PepRegistrationForm extends StatelessWidget {
  final Widget body;
  final Function() onContinue;

  PepRegistrationForm({required this.body, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: [
      SliverFillRemaining(
          hasScrollBody: false,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(children: [
              SizedBox(height: 32),
              body,
              SizedBox(height: 32),
              Spacer(),
              PepButton(title: "Продолжить", onTap: onContinue),
              SizedBox(height: 80)
            ]),
          ))
    ]);
  }
}

class PepRadioButton<T> extends StatelessWidget {
  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;

  PepRadioButton(
      {required this.value, required this.groupValue, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
        scale: 1.5,
        child: Radio(
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
          activeColor: kPrimaryColor,
        ));
    //fillColor: MaterialStateProperty.resolveWith(_getFillColor));
  }

  Color _getFillColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.selected,
    };
    if (states.any(interactiveStates.contains)) {
      return kPrimaryColor;
    }
    return kInputBackgroundColor;
  }
}
