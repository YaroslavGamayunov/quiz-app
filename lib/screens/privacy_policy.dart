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
        appBar: AppBar(
          leading: IconButton(
            icon: SvgPicture.asset("assets/ic_arrow_2.svg"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body:
            ListView(padding: EdgeInsets.symmetric(horizontal: 24), children: [
          Container(
              margin: EdgeInsets.symmetric(vertical: 32),
              child: Text("Политика конфиденциальности",
                  style: Theme.of(context)
                      .textTheme
                      .headline1!
                      .copyWith(color: Colors.black))),
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
            child: PepButton(
                title: "Подтвердить",
                onTap: () {
                  Navigator.of(context).pop();
                }),
            margin: EdgeInsets.symmetric(vertical: 72),
          )
        ]));
  }
}
