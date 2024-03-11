import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NameForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NameFormState();
}

class _NameFormState extends State<NameForm> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController secondNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      Spacer(),
      Text("Как вас зовут?", style: Theme.of(context).textTheme.bodyText1)
    ]));
  }
}
