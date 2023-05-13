// ignore_for_file: avoid_function_literals_in_foreach_calls, unused_element, prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:peto/dashboard/pets/addpets.dart';
import 'package:peto/dashboard/pets/getName.dart';

class Pets extends StatefulWidget {
  const Pets({super.key});

  @override
  State<Pets> createState() => _PetsState();
}

class _PetsState extends State<Pets> {
  final uid = FirebaseAuth.instance.currentUser!.email;
  List<String> docIDs = [];

  Future _getDocId() async {
    await FirebaseFirestore.instance
        .collection('pets')
        .where('_ownerID', isEqualTo: uid)
        .get()
        .then(
          (snapshot) => snapshot.docs.forEach((element) {
            if (kDebugMode) {
              print(element.reference);
              print(uid);
              docIDs.add(element.reference.id);
            }
          }),
        );
  }

  /* @override
  void initState() {
    _getDocId();
    super.initState();
  }*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return Addpets();
                  },
                ),
              );
            },
            icon: const Icon(
              IconlyLight.plus,
              color: Colors.black,
            ),
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height-150,
                    child: FutureBuilder(
                      future: _getDocId(),
                      builder: (context, snapshot) {
                        return ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: docIDs.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.grey[100],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: GetName(documentId: docIDs[index]),
                                  ),
                                ),
                              );
                            });
                      },
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
