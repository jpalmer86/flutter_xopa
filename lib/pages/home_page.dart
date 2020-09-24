import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:xopa_app/pages/collaborate/collaborate_page.dart';
import 'package:xopa_app/pages/loading/loading_page.dart';
import 'package:xopa_app/pages/messages/conversations_page.dart';
import 'package:xopa_app/pages/profile/profile_tab.dart';
import 'package:xopa_app/pages/search/search_tab.dart';
import 'package:xopa_app/theme/widgets/themed_appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final int initialIndex;

  HomePage({this.initialIndex = 2});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex;

  PageStorageBucket _bucket = new PageStorageBucket();

  final List<Widget> pages = [
    CollaboratePage(key: const PageStorageKey('Collaborate')),
    SearchTab(key: const PageStorageKey('Search')),
    ProfileTab(key: const PageStorageKey('Profile')),
    ConversationsPage(key: const PageStorageKey('Messages')),
  ];

  @override
  void initState() {
    currentIndex = widget.initialIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: ThemedAppBar(
        title: const Text('Xopa'),
        actions: <Widget>[
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert),
            itemBuilder: (context) => [
              const PopupMenuItem(
                child: Text('Sign Out'),
                value: 'Sign Out',
              ),
            ],
            onSelected: (String value) {
              if(value == 'Sign Out') {
                _signOut();
              }
            },
          ),
        ],
      ),
      body: PageTransitionSwitcher(
        transitionBuilder: (child, primary, secondary) {
          return FadeThroughTransition(
            child: child,
            animation: primary,
            secondaryAnimation: secondary,
          );
        },
        child: PageStorage(
          key: ValueKey<int>(currentIndex),
          child: pages[currentIndex],
          bucket: _bucket,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.group_work),
            title: const Text('Collaborate'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: const Text('Search'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.portrait),
            title: const Text('Portfolio'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            title: const Text('Messages'),
          ),
        ],
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }

  void _signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('interests', false);
    prefs.setString('token', null);
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => LoadingPage()));
  }
}
