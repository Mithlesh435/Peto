// ignore_for_file: file_names, await_only_futures, unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../config.dart';

class PetProfile extends StatefulWidget {
  final String petId;
  const PetProfile({super.key, required this.petId});

  @override
  State<PetProfile> createState() => _PetProfileState();
}

class _PetProfileState extends State<PetProfile> {
  String pname = "";
  String vacc = "";
  String pbreed = "";
  String page = "";
  String url = "";
  String ownerID = "";
  String dscript = "";
  String _userName = "";
  String _userPhone = "";
  String _userImage = "";

  fetchData(String documentId) async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('pets')
          .doc(widget.petId)
          .get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;

        setState(() {
          pname = data['_name'];
          vacc = data['_vaccination'];
          pbreed = data['_breed'];
          page = data['_age'];
          url = data['_image0'].toString();
          ownerID = data['_ownerID'];
          dscript = data['_dcs'];
        });

        final firebaseUser = await FirebaseAuth.instance.currentUser;
        if (firebaseUser != null) {
          final userDoc = await FirebaseFirestore.instance
              .collection('users')
              .where('_email', isEqualTo: ownerID)
              .get();
          for (var doc in userDoc.docs) {
            final data = doc.data();
            setState(() {
              _userName = data['_name'];
              _userPhone = data['_phone'].toString();
              _userImage = data['_image'].toString();
            });
          }
        } // Use the data as needed
        if (kDebugMode) {
          print(data);
        }
      } else {
        if (kDebugMode) {
          print('Document does not exist');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching data: $e');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData(widget.petId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: const Color.fromRGBO(198, 185, 250, 1), width: 1),
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                  image: DecorationImage(
                    image: NetworkImage(url),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 130,
                margin: const EdgeInsets.symmetric(horizontal: 25.0),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: shadowList,
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            pname,
                            style: TextStyle(
                                fontSize: 25, color: Colors.grey[600]),
                          ),
                          Icon(
                            Icons.vaccines,
                            color: Colors.grey[600],
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 9.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            pbreed,
                            style: TextStyle(
                                fontSize: 15, color: Colors.grey[600]),
                          ),
                          Text(
                            page,
                            style: TextStyle(
                                fontSize: 15, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        children: const [
                          Icon(IconlyLight.location),
                          Text("Pune"),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 50.0, vertical: 20.0),
                child: Container(
                  margin: const EdgeInsets.only(top: 210),
                  child: Row(
                    children: [
                      Container(
                        height: 50.0,
                        width: 50.0,
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
                        width: 20.0,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 230),
                        child: Column(
                          children: [
                            Text(_userName),
                            const SizedBox(height: 5.0),
                            const Text("Owner")
                          ],
                        ),
                      ),
                      const SizedBox(width: 20.0),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:25.0, vertical: 10.0),
              child: Container(
                margin: const EdgeInsets.only(top: 400),
                child:  Align(
                  alignment: Alignment.center,
                  child: Text(dscript),)),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 90,
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        margin: const EdgeInsets.all(15.0),
                        height: 60,
                        width: 70,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(Icons.arrow_back_ios_new),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 60,
                        margin: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Center(child: Text("Call Owner")),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
