import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:peto/dashboard/foster/addFosterHome.dart';
import 'package:peto/dashboard/foster/getFosterDetails.dart';
import '../../widgets/nav_widget.dart';

class Foster extends StatefulWidget {
  const Foster({super.key});

  @override
  State<Foster> createState() => _FosterState();
}

class _FosterState extends State<Foster> {

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
        .collection('foster')
        .where('_type', isEqualTo: _selectedPetType)
        .get();
    docIDs = snapshot.docs.map((doc) => doc.id).toList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            IconlyLight.game,
            color:  Color.fromRGBO(198, 185, 250, 1),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const AddFosterHome();
                  },
                ),
              );
            },
            icon: const Icon(
              IconlyLight.plus,
              color: Colors.black,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,

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
                  height: 10.0,
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
                                        GetFosterDetails(documentId: docIDs[index]),
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
