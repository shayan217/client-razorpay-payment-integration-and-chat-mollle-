import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:molle/Utils/constants.dart';
import 'package:molle/Views/Screens/Home/Search/search.dart';

import '../Chat/chat_screen.dart';
import '../Create_Event/create_event.dart';
import '../Profile/profile.dart';
import '../home.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  late PageController _pageController;

  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  List<Widget> _children = [];

  @override
  void initState() {
    _pageController = PageController();
    _children = [
      HomePage(),
      Search(),
      EventDetail(),
      Chat(),
      ProfileScreen(),

      // Wallet(),
      // MiningTeam(),
      // Support(),
    ];

    // TODO: implement initState
    //re appear statusbar in case it was not there in the previous page
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: CurvedNavigationBar(
      //   color: const Color(0xffDAC21A),
      //   backgroundColor: Colors.white,
      //   items: const [
      //     CurvedNavigationBarItem(
      //       child: Icon(
      //         Icons.home,
      //         color: Colors.white,
      //       ),
      //       label: 'Home',
      //       labelStyle: TextStyle(color: Colors.white),
      //     ),
      //     CurvedNavigationBarItem(
      //       child: Icon(
      //         CupertinoIcons.person,
      //         color: Colors.white,
      //       ),
      //       label: 'Profile',
      //       labelStyle: TextStyle(color: Colors.white),
      //     ),
      //     CurvedNavigationBarItem(
      //       child: Icon(
      //         Icons.wallet,
      //         color: Colors.white,
      //       ),
      //       label: 'Wallet',
      //       labelStyle: TextStyle(color: Colors.white),
      //     ),
      //     CurvedNavigationBarItem(
      //       child: Icon(
      //         CupertinoIcons.person_2,
      //         color: Colors.white,
      //       ),
      //       label: 'Team',
      //       labelStyle: TextStyle(color: Colors.white),
      //     ),
      //     CurvedNavigationBarItem(
      //       child: Icon(
      //         Icons.support_agent,
      //         color: Colors.white,
      //       ),
      //       label: 'Support',
      //       labelStyle: TextStyle(color: Colors.white),
      //     ),
      //   ],
      //   onTap: _onItemTapped,
      // ),
      bottomNavigationBar: CustomNavigationBar(
        borderRadius: const Radius.circular(10),
        currentIndex: _currentIndex,
        unSelectedColor: const Color(0xffC7C7CC),
        strokeColor: Colors.white,
        selectedColor: ColorConstants.mainColor,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        items: [
          CustomNavigationBarItem(
            icon: const Icon(Icons.home),
            // title: Text(
            //   "Home",
            //   style: TextStyle(
            //     color: Color(0xffC7C7CC),
            //   ),
            // ),
          ),
          CustomNavigationBarItem(
            icon: const Icon(
              CupertinoIcons.search,
            ),
          ),
          CustomNavigationBarItem(
            icon: const Icon(
              Icons.add,
            ),
          ),
          CustomNavigationBarItem(
            icon: const Icon(
              CupertinoIcons.chat_bubble,
            ),
          ),
          CustomNavigationBarItem(
            icon: const Icon(
              Icons.person,
            ),
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _children,
      ),
    );
  }
}
