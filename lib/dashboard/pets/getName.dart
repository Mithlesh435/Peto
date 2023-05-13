// ignore_for_file: file_names, no_leading_underscores_for_local_identifiers
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class GetName extends StatefulWidget {
  final String documentId;
  const GetName({super.key, required this.documentId});

  @override
  State<GetName> createState() => _GetNameState();
}

class _GetNameState extends State<GetName> {
  String adoptionStatus = "";

  @override
  void initState() {
    super.initState();
    _fetchAdoptionStatus();
  }

  Future<void> _fetchAdoptionStatus() async {
    try {
      DocumentSnapshot document = await FirebaseFirestore.instance
          .collection('pets')
          .doc(widget.documentId)
          .get();

      if (document.exists) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        setState(() {
          adoptionStatus = data['_adoption status'];
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching adoption status: $e');
      }
    }
  }

  Future<void> updateAdoptionStatus(String newStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection('pets')
          .doc(widget.documentId)
          .update({'_adoption status': newStatus});

      setState(() {
        adoptionStatus = newStatus;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error updating adoption status: $e');
      }
    }
  }

  Future<void> deletePet() async {
    try {
      await FirebaseFirestore.instance
          .collection('pets')
          .doc(widget.documentId)
          .delete();
      if (kDebugMode) {
        print('Pet record deleted successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting pet record: $e');
      }
    }
  }

  CollectionReference pets = FirebaseFirestore.instance.collection('pets');

  String ad = "";

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: pets.doc(widget.documentId).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.hasData) {
            DocumentSnapshot document = snapshot.data!;
            if (document.exists) {
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
              adoptionStatus = data["_adoption status"];

              return Column(
                children: [
                  Container(
                    height: 350.0,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      image: DecorationImage(
                        image: NetworkImage('${data['_image0']}'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${data['_name']}',
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: adoptionStatus != "UAFA"
                                  ? Colors.lightGreen
                                  : Colors.red,
                              border:
                                  Border.all(color: Colors.white10, width: 2),
                              borderRadius: BorderRadius.circular(8.0)),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Center(
                              child: adoptionStatus != "UAFA"
                                  ? const Text(
                                      'ADOPTING :(',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 13.0),
                                    )
                                  : const Text(
                                      'ADOPTED :)',
                                      style: TextStyle(
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
                        child: Container(
                          decoration: BoxDecoration(
                              color: const Color.fromRGBO(198, 185, 250, 1),
                              border:
                                  Border.all(color: Colors.white10, width: 2),
                              borderRadius: BorderRadius.circular(8.0)),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: GestureDetector(
                              onTap: () {
                                if (adoptionStatus == "UFA") {
                                  updateAdoptionStatus("UAFA");
                                } else if (adoptionStatus == "UAFA") {
                                  updateAdoptionStatus("UFA");
                                }
                              },
                              child: Center(
                                child: adoptionStatus != "UFA"
                                    ? const Text(
                                        'Mark as Adopting',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13.0),
                                      )
                                    : const Text(
                                        'Mark as Adopted',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13.0),
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            deletePet();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.red,
                                border:
                                    Border.all(color: Colors.white10, width: 2),
                                borderRadius: BorderRadius.circular(8.0)),
                            child: const Padding(
                              padding: EdgeInsets.all(6.0),
                              child: Center(
                                  child: Text(
                                'Delete Pet',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 13.0),
                              )),
                            ),
                          ),
                        ),
                      ),

                      /* Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () {
                          /*Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PetProfile(petId: documentId,),
                              ));*/
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
                  ),*/
                    ],
                  ),
                ],
              );
            }
          }
        }
        return const Text("Loading");
      }),
    );
  }
}
