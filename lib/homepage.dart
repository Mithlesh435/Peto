// ignore_for_file: implementation_imports, non_constant_identifier_names, prefer_const_literals_to_create_immutables, prefer_const_constructors, duplicate_ignore
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:iconly/iconly.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final CurrentUser = FirebaseAuth.instance.currentUser!;
  int _index = 0;
   final screens = [
    HomePage(),
    //SearchPage(),
    //ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: screens[_index],
      backgroundColor: Colors.white,
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: GNav(
            tabActiveBorder: Border.all(color: Color.fromRGBO(154, 105, 247, 1), width: 1),
            backgroundColor: Colors.white,
            color: Colors.grey[400],
            activeColor: Color.fromRGBO(154, 105, 247, 1),
            tabBackgroundColor: Colors.transparent,
            padding: EdgeInsets.all(15.0),
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
                icon: Icons.pets,
                text: 'Pets',
              ),
               GButton(
                icon: CupertinoIcons.person_solid,
                text: 'Profile',
              ),
            ],
          ),
        ),
      ),
      /*SafeArea(
        child: Center(
          child: SingleChildScrollView(
            // ignore: duplicate_ignore
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                Text("Welcome ${CurrentUser.email}",style: const TextStyle(color: Colors.black),),
                const SizedBox(height: 20.0,),
                GestureDetector(
                  onTap: (){
                    showDialog(
                      context: context, 
                      builder: (context){
                        return const Center(child: CircularProgressIndicator(color: Colors.white,));
                      },
                    );
                    FirebaseAuth.instance.signOut();
                    Navigator.of(context).pop();
                  },
                  child: const Icon(Icons.logout,color: Colors.black,)
                ),
                const SizedBox(height: 30.0,),
                GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return const Addpets();
                      },),);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          const Text('Add Pet',style: TextStyle(color: Colors.black),),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),*/
    );
  }
}