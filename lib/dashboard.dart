import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:iconly/iconly.dart';
import 'package:peto/dashboard/favorites.dart';
import 'package:peto/dashboard/home.dart';
import 'package:peto/dashboard/pets.dart';
import 'package:peto/dashboard/profile/profile.dart';

import 'dashboard/chat.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  int _index = 0;
  final screens = [
    const Home(),
    const Favorites(),
    const Chat(),
    const Pets(),
    const Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_index],
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: GNav(
            tabActiveBorder: Border.all(color: const Color.fromRGBO(154, 105, 247, 1), width: 1),
            backgroundColor: Colors.white,
            color: Colors.grey[400],
            activeColor: const Color.fromRGBO(154, 105, 247, 1),
            tabBackgroundColor: Colors.transparent,
            padding: const EdgeInsets.all(15.0),
            gap: 10,
            selectedIndex: _index,
            onTabChange: (value){
               setState(() {
                _index = value;
              });
            },
            tabs: const [
              GButton(
                icon: IconlyLight.home,
                text: 'Home',
              ),
               GButton(
                icon: IconlyLight.heart,
                text: 'Favorites',
              ),
               GButton(
                icon: IconlyLight.chat,
                text: 'Chat',
              ),
              GButton(
                icon: IconlyLight.document,
                text: 'Pets',
              ),
               GButton(
                icon: IconlyLight.user,
                text: 'Profile',
              ),
            ],
          ),
        ),
      ),
      
    );
  }
}