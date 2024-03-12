import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pep/constants.dart';
import 'package:pep/screens/developer_profile.dart';
import 'package:pep/screens/oncoming_test.dart';
import 'package:pep/screens/profile.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Widget> pages;
  late Widget _currentPage;

  int _navBarSelectedIndex = 0;

  @override
  void initState() {
    super.initState();
    pages = [
      OncomingTestPage(onPageChanged: _changePage),
      OncomingTestPage(onPageChanged: _changePage),
      DeveloperProfilePage(),
      ProfilePage()
    ];
    _currentPage = pages[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _currentPage),
      bottomNavigationBar: Container(
        height: 82,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color(0x1a000000),
              blurRadius: 30,
              spreadRadius: 30,
              offset: Offset(0, 15), // changes position of shadow
            ),
          ],
        ),
        child: BottomNavigationBar(
          unselectedItemColor: kSecondaryTextColor,
          backgroundColor: Colors.black,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
                icon: Builder(
                  builder: (context) {
                    return SvgPicture.asset(
                      'assets/ic_test.svg',
                      color: IconTheme.of(context).color,
                    );
                  },
                ),
                label: 'Тесты'),
            BottomNavigationBarItem(
                icon: Builder(
                  builder: (context) {
                    return SvgPicture.asset(
                      'assets/ic_leaderboard.svg',
                      color: IconTheme.of(context).color,
                    );
                  },
                ),
                label: 'Статистика'),
            BottomNavigationBarItem(
                icon: Builder(
                  builder: (context) {
                    return SvgPicture.asset(
                      'assets/ic_profile.svg',
                      color: IconTheme.of(context).color,
                    );
                  },
                ),
                label: 'Профиль'),
            BottomNavigationBarItem(
                icon: Builder(
                  builder: (context) {
                    return SvgPicture.asset(
                      'assets/ic_settings.svg',
                      color: IconTheme.of(context).color,
                    );
                  },
                ),
                label: 'Настройки'),
          ],
          selectedItemColor: kPrimaryColor,
          currentIndex: _navBarSelectedIndex,
          onTap: _onNavBarItemTapped,
        ),
      ),
    );
  }

  _onNavBarItemTapped(int index) {
    setState(() {
      _navBarSelectedIndex = index;
      _currentPage = pages[index];
    });
  }

  void _changePage(Widget page) {
    setState(() {
      _currentPage = page;
    });
  }
}
