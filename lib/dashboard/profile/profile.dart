// ignore_for_file: avoid_unnecessary_containers, unused_local_variable, non_constant_identifier_names, await_only_futures, unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:peto/auth/mainpage.dart';
import '../../main/conditions.dart';
import 'edit_profile.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String _userImage = "";
  String _userName = "";

  final uid = FirebaseAuth.instance.currentUser!.email; //Get Current User UID

   _fetch() async {
    final firebaseUser = await FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .where('_email', isEqualTo: uid)
          .get();
      for (var doc in userDoc.docs) {
        final data = doc.data();
        setState(() {
          _userName = data['_name'];
           _userImage = data['_image'];
        });
      }
    }
  }

  @override
  void initState() {
    _fetch();
    super.initState();
  }

  final CurrentUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Container(
                      height: 150.0,
                      width: 150.0,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromRGBO(198, 185, 250, 1),
                            width: 1),
                        borderRadius: BorderRadius.circular(100.0),
                        image: DecorationImage(
                          image: NetworkImage(_userImage),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Text(_userName),
                    const SizedBox(
                      height: 5.0,
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    SizedBox(
                        width: 200.0,
                        height: 50.0,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const EditProfile();
                                  },
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(154, 105, 247, 1),
                              side: BorderSide.none,
                              shape: const StadiumBorder(),
                            ),
                            child: const Text(
                              "Edit Profile",
                              style: TextStyle(fontSize: 15.0),
                            ))),
                    const SizedBox(
                      height: 20.0,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: ListTileWidget(
                        title: "Settings",
                        icon: IconlyLight.setting,
                        onPress: () {},
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: ListTileWidget(
                        title: "Help & Support",
                        icon: IconlyLight.info_circle,
                        onPress: () {},
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: ListTileWidget(
                        title: "Terms & Conditions",
                        icon: IconlyLight.close_square,
                        onPress: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const Conditions();
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: ListTileWidget(
                        title: "Logout",
                        endIcon: false,
                        icon: IconlyLight.logout,
                        onPress: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return const Center(
                                  child: CircularProgressIndicator(
                                color: Colors.white,
                              ));
                            },
                          );
                          FirebaseAuth.instance.signOut();
                          Navigator.of(context).pop();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const MainPage();
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ListTileWidget extends StatelessWidget {
  const ListTileWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
  });

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      //Menu
      onTap: onPress,
      leading: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
        ),
        child: Icon(
          icon,
          color: Colors.black,
        ),
      ),
      title: Text(
        title,
      ),
      trailing: endIcon
          ? Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
              ),
              child: const Icon(
                IconlyLight.arrow_right_square,
                color: Colors.grey,
              ),
            )
          : null,
    );
  }
}
