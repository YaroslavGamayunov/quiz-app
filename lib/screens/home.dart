import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quizapp/constants.dart';
import 'package:quizapp/screens/navigation/navigator_page.dart';
import 'package:quizapp/screens/oncoming_test.dart';
import 'package:quizapp/screens/profile.dart';
import 'package:quizapp/screens/statistics.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<int, GlobalKey<NavigatorState>> _navigatorKeys = {
    0: GlobalKey<NavigatorState>(),
    1: GlobalKey<NavigatorState>(),
    2: GlobalKey<NavigatorState>(),
    3: GlobalKey<NavigatorState>(),
  };
  int _navBarSelectedIndex = 0;

  Widget buildNavigator() {
    return NavigatorPopHandler(
      onPop: () => _navigatorKeys[_navBarSelectedIndex]!.currentState!.pop(),
      child: IndexedStack(
        index: _navBarSelectedIndex,
        children: [
          NavigatorPage(
              child: OncomingTestPage(), navigatorKey: _navigatorKeys[0]!),
          NavigatorPage(
              child: StatisticsPage(), navigatorKey: _navigatorKeys[1]!),
          NavigatorPage(child: ProfilePage(), navigatorKey: _navigatorKeys[2]!)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: buildNavigator(),
            bottomNavigationBar: buildBottomNavigationBar()));
  }

  Widget buildBottomNavigationBar() {
    return BottomNavigationBar(
      unselectedItemColor: kSecondaryTextColor,
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
    );
  }

  _onNavBarItemTapped(int index) {
    setState(() {
      _navBarSelectedIndex = index;
    });
  }
}
