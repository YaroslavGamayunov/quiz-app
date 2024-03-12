import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pep/constants.dart';
import 'package:pep/util/widgets.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: [
      SliverFillRemaining(
          hasScrollBody: false,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 48),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        'Владимир Иванов',
                        textAlign: TextAlign.justify,
                        style: Theme.of(context)
                            .textTheme
                            .headline1!
                            .copyWith(color: Colors.black),
                      ),
                    ),
                    IconButton(
                      icon: SvgPicture.asset('assets/ic_edit.svg'),
                      onPressed: () {},
                    )
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  'Мужчина, 50 лет',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: kSecondaryTextColor),
                ),
                SizedBox(height: 4),
                Text(
                  'Москва, Россия',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: kSecondaryTextColor),
                ),
                SizedBox(height: 32),
                Text(
                  'Учетная запись',
                  style: Theme.of(context)
                      .textTheme
                      .button!
                      .copyWith(color: Colors.black),
                ),
                SizedBox(height: 16),
                Text(
                  '+7-(909)-767-68-77',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: kSecondaryTextColor),
                ),
                SizedBox(height: 4),
                Text(
                  'vova@gmail.com',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: kSecondaryTextColor),
                ),
                SizedBox(height: 42),
                PepButton(title: 'Редактировать тест', onTap: () {})
              ],
            ),
          ))
    ]);
  }
}
