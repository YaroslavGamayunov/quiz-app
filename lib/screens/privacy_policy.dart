import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter/services.dart' show rootBundle;
import 'package:pep/util/widgets.dart';

import '../constants.dart';

Future<String> _loadPrivacyPolicy() async {
  return await rootBundle.loadString('assets/text/privacy_policy.txt');
}

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
            padding: EdgeInsets.only(left: 24, right: 24, top: 50),
            children: [
          Container(
              alignment: Alignment.topLeft,
              child: InkResponse(
                  child: SvgPicture.asset("assets/ic_arrow_2.svg"),
                  onTap: () => Navigator.of(context).pop())),
          Container(
              margin: EdgeInsets.symmetric(vertical: 32),
              child: Text("Политика конфиденциальности",
                  style: Theme.of(context)
                      .textTheme
                      .headline1!
                      .copyWith(color: Colors.black, fontSize: 32))),
          FutureBuilder(
              future: _loadPrivacyPolicy(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data as String,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(color: kSecondaryTextColor));
                }
                return Container(
                    padding: EdgeInsets.all(16),
                    alignment: Alignment.center,
                    child: CircularProgressIndicator());
              }),
          Container(
            margin: EdgeInsets.symmetric(vertical: 72),
            child: PepButton(
                title: "Подтвердить",
                onTap: () {
                  Navigator.of(context).pop();
                }),
          )
        ]));
  }
}
