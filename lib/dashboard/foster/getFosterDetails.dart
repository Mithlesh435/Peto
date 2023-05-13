// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'package:iconly/iconly.dart';
import 'package:peto/dashboard/foster/fosterProfile.dart';

class GetFosterDetails extends StatelessWidget {
  final String documentId;
  const GetFosterDetails({super.key, required this.documentId});

  @override
  Widget build(BuildContext context) {
    CollectionReference foster = FirebaseFirestore.instance.collection('foster');

    return FutureBuilder<DocumentSnapshot>(
      future: foster.doc(documentId).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Column(
            children: [
              Stack(children: [
                Container(
                  height: 150.0,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                      image: NetworkImage('${data['_image0']}'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                 const Positioned(
                    right: 6,
                    top: 6,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.white,
                      child: Icon(
                        IconlyBold.heart,
                        color: Color.fromRGBO(152, 104, 247, 1),
                      ),
                    ))
              ]),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${data['_fname']}',
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.lightGreen,
                          border: Border.all(color: Colors.white10, width: 2),
                          borderRadius: BorderRadius.circular(8.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Center(
                          child: Text(
                            '${data['_fdays']}',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 13.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8.0,
              ),
              Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Charges : ${data['_fcharge']}",
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FosterProfile(fosterId: documentId,),
                              ));
                        },
                        child: const Text(
                          'more details >',
                          style: TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        }
        return const Text("Loading");
      }),
    );
  }
}