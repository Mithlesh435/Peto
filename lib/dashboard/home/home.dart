// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:peto/dashboard/home/notification.dart';
import '../../widgets/nav_widget.dart';
import 'getPetsDetails.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _selectedPetType = 'Dogs';

  @override
  void initState() {
    super.initState();
    _selectedPetType = _petTypes.first;
  }

  final List<String> _petTypes = ['Dog', 'Cat', 'Fish', 'Other'];

  void _onPetTypeSelected(String petType) {
    setState(() {
      _selectedPetType = petType;
      if (kDebugMode) {
        print(_selectedPetType);
      }
    });
  }

  final uid = FirebaseAuth.instance.currentUser!.email;

  List<String> docIDs = [];
  Future _getDocId() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('pets')
        .where('_type', isEqualTo: _selectedPetType)
        .get();
    docIDs = snapshot.docs.map((doc) => doc.id).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.menu,
              color: Colors.black,
            )),
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Center(
            child: Text(
          "Home",
          style: TextStyle(color: Colors.black),
        )),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const NotificationScreen();
                  },
                ),
              );
            },
            icon: const Icon(
              IconlyLight.notification,
              color: Colors.black,
            ),
          )
        ],
      ),
      body: Center(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10.0,
                ),
                const Divider(
                  thickness: 1,
                  color: Colors.black12,
                ),
                
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    Text(
                      'Category',
                      // ignore: prefer_const_constructors
                      style: GoogleFonts.rubikPuddles(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                PetTypeNavBar(
                  petTypes: _petTypes,
                  onPetTypeSelected: _onPetTypeSelected,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                        height: 260,
                        child: FutureBuilder(
                          future: _getDocId(),
                          builder: (context, snapshot) {
                            return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: docIDs.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    width:
                                        MediaQuery.of(context).size.width / 1.8,
                                    margin: const EdgeInsets.only(right: 14.0),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Colors.grey[100],
                                    ),
                                    child:
                                        GetPetsDetails(documentId: docIDs[index]),
                                  );
                              
                                });
                          },
                        )),
                              
                        const SizedBox(height: 20.0,),
                        SizedBox(
                        height: 260,
                        child: FutureBuilder(
                          future: _getDocId(),
                          builder: (context, snapshot) {
                            return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: docIDs.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    width:
                                        MediaQuery.of(context).size.width / 1.8,
                                    margin: const EdgeInsets.only(right: 14.0),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Colors.grey[100],
                                    ),
                                    child:
                                        GetPetsDetails(documentId: docIDs[index]),
                                  );
                              
                                });
                          },
                        )),
                      ],
                    ),
                  ),
                ),
                
            
              ],
            ),
          ),
        ),
      ),
    );
  }
}
