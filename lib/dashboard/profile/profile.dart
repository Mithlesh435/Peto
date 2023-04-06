// ignore_for_file: avoid_unnecessary_containers, unused_local_variable, non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'edit_profile.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
                    Stack(
                      children: [
                        SizedBox(
                        width: 120,
                        height: 120,
                        child: ClipRRect(borderRadius: BorderRadius.circular(100),child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: const Center(child: Text("Upload Image",style: TextStyle(color: Colors.black),))),),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: const Icon(IconlyLight.edit_square,color: Color.fromRGBO(154, 105, 247, 1)),
                        ),
                      ),
                  ]),
                    const SizedBox(height: 20.0,),
                    const Text("Mithlesh Kumar Yadav"),
                    const SizedBox(height: 5.0,),
                    Text("Hey! ${CurrentUser.email}",style: const TextStyle(color: Colors.black),),
                    const SizedBox(height: 20.0,),
                    SizedBox(
                      width:200.0, 
                      height: 50.0,
                      child: ElevatedButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                              return const EditProfile();
                              },
                            ),);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(154, 105, 247, 1),
                          side: BorderSide.none, 
                          shape: const StadiumBorder(),
                        ), 
                        child: const Text("Edit Profile",style: TextStyle(fontSize: 15.0),)
                      )
                    ),
                    const SizedBox(height: 20.0,),
                    const Divider(),
                    const SizedBox(height: 10.0,),
                   
                     Padding(
                      padding: const EdgeInsets.symmetric(horizontal:25.0),
                      child: ListTileWidget(title: "Ratings",icon: IconlyLight.ticket_star,onPress: () {},),
                    ),
                     Padding(
                      padding: const EdgeInsets.symmetric(horizontal:25.0),
                      child: ListTileWidget(title: "Settings",icon: IconlyLight.setting,onPress: () {},),
                    ),
                     Padding(
                      padding: const EdgeInsets.symmetric(horizontal:25.0),
                      child: ListTileWidget(title: "Help & Support",icon: IconlyLight.info_circle ,onPress: () {},),
                    ),
                    
                     Padding(
                      padding: const EdgeInsets.symmetric(horizontal:25.0),
                      child: ListTileWidget(title: "Terms & Conditions",icon: IconlyLight.close_square,onPress: () {},),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:25.0),
                      child: ListTileWidget(
                        title: "Logout",
                        endIcon: false,
                        icon: IconlyLight.logout,
                        onPress: () {
                          showDialog(
                          context: context, 
                          builder: (context){
                            return const Center(child: CircularProgressIndicator(color: Colors.white,));
                          },);
                          FirebaseAuth.instance.signOut();
                          Navigator.of(context).pop();
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
    return ListTile(     //Menu
    onTap: onPress,
      leading: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
        ),
        child: Icon(icon,color: Colors.black,),
      ),
      title: Text(title,),
      trailing: endIcon? Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
        ),
        child: const Icon(IconlyLight.arrow_right_square,color: Colors.grey,),
      ): null,
    );
  }
}