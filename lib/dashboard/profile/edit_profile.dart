// ignore_for_file: non_constant_identifier_names, unused_element, unused_local_variable, await_only_futures, curly_braces_in_flow_control_structures, deprecated_member_use, unused_field
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late PickedFile _imageFile;
  final ImagePicker _picker = ImagePicker();

  String _userImage = "";

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
          _edit_namecontroller.text = data['_name'];
          _edit_phonecontroller.text = data['_phone'].toString();
          _edit_citycontroller.text = data['_city'];
          _userImage = data['_image'].toString();
        });
      }
    }
  }

  @override
  void initState() {
    _fetch();
    super.initState();
  }

  //TextField Controllers
  final _edit_namecontroller = TextEditingController();
  final _edit_phonecontroller = TextEditingController();
  final _edit_citycontroller = TextEditingController();

  @override
  void dispose() {
    _edit_namecontroller.dispose();
    _edit_phonecontroller.dispose();
    _edit_citycontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            IconlyLight.arrow_left_square,
            color: Colors.black,
          ),
        ),
        //title:  const Text("Edit Profile",style: TextStyle(color: Colors.black,),),
      ),
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
                        Container(
                          height: 150.0,
                          width: 150.0,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color.fromRGBO(198, 185, 250, 1),
                                width: 4),
                            borderRadius: BorderRadius.circular(100.0),
                            image: DecorationImage(
                              image: NetworkImage(_userImage),
                              fit: BoxFit.cover,
                            ),
                          ),
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
                            child: GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: ((builder) => bottomsheet()),
                                );
                              },
                              child: const Icon(IconlyLight.edit_square,
                                  color: Color.fromRGBO(154, 105, 247, 1)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      "Hey! $uid",
                      style: const TextStyle(color: Colors.black),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Form(
                        child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: TextField(
                            keyboardType: TextInputType.name,
                            textCapitalization: TextCapitalization.words,
                            controller: _edit_namecontroller,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 18.0),
                            cursorColor: const Color.fromRGBO(198, 185, 250, 1),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                IconlyLight.profile,
                                color: Color.fromRGBO(198, 185, 250, 1),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color.fromRGBO(198, 185, 250, 1),
                                  ),
                                  borderRadius: BorderRadius.circular(10.0)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color.fromRGBO(198, 185, 250, 1),
                                  ),
                                  borderRadius: BorderRadius.circular(10.0)),
                              hintText: "Name",
                              hintStyle: const TextStyle(
                                color: Color.fromRGBO(198, 185, 250, 1),
                              ),
                              labelText: 'Name',
                              labelStyle: const TextStyle(
                                color: Color.fromRGBO(198, 185, 250, 1),
                              ),
                              filled: false,
                              fillColor: const Color.fromRGBO(198, 185, 250, 1),
                              //labelText: "Email",
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: TextField(
                            keyboardType: TextInputType.phone,
                            controller: _edit_phonecontroller,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 18.0),
                            cursorColor: const Color.fromRGBO(198, 185, 250, 1),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                IconlyLight.call,
                                color: Color.fromRGBO(198, 185, 250, 1),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color.fromRGBO(198, 185, 250, 1)),
                                  borderRadius: BorderRadius.circular(10.0)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color.fromRGBO(198, 185, 250, 1),
                                  ),
                                  borderRadius: BorderRadius.circular(10.0)),
                              hintText: "Phone",
                              hintStyle: const TextStyle(
                                  color: Color.fromRGBO(198, 185, 250, 1)),
                              labelText: 'Phone',
                              labelStyle: const TextStyle(
                                  color: Color.fromRGBO(198, 185, 250, 1)),
                              filled: false,
                              fillColor: const Color.fromRGBO(198, 185, 250, 1),
                              //labelText: "Email",
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: TextField(
                            textCapitalization: TextCapitalization.words,
                            keyboardType: TextInputType.name,
                            controller: _edit_citycontroller,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 18.0),
                            cursorColor: const Color.fromRGBO(198, 185, 250, 1),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.location_city,
                                color: Color.fromRGBO(198, 185, 250, 1),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color.fromRGBO(198, 185, 250, 1)),
                                  borderRadius: BorderRadius.circular(10.0)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color.fromRGBO(198, 185, 250, 1),
                                  ),
                                  borderRadius: BorderRadius.circular(10.0)),
                              hintText: "Pune",
                              hintStyle: const TextStyle(
                                  color: Color.fromRGBO(198, 185, 250, 1)),
                              labelText: 'City',
                              labelStyle: const TextStyle(
                                  color: Color.fromRGBO(198, 185, 250, 1)),
                              filled: false,
                              fillColor: const Color.fromRGBO(198, 185, 250, 1),
                              //labelText: "Email",
                            ),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        GestureDetector(
                          onTap: () {},
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  color: const Color.fromRGBO(198, 185, 250, 1),
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: const Center(
                                child: Text(
                                  "Update",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Created on 31,July 2023"),
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      border: Border.all(color: Colors.white),
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  child: const Center(
                                    child: Text(
                                      "Delete Account",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 10.0),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5.0),
                      ],
                    ))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget bottomsheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              GestureDetector(
                  onTap: () {
                    takephoto(ImageSource.camera);
                  },
                  child: Column(
                    children: const [
                      Icon(
                        IconlyLight.camera,
                        size: 40.0,
                        color: Color.fromRGBO(198, 185, 250, 1),
                      ),
                      Text("Camera")
                    ],
                  )),
              GestureDetector(
                  onTap: () {
                    takephoto(ImageSource.gallery);
                  },
                  child: Column(
                    children: const [
                      Icon(
                        IconlyLight.image_2,
                        size: 40.0,
                        color: Color.fromRGBO(198, 185, 250, 1),
                      ),
                      Text("Gallery")
                    ],
                  )),
            ],
          ),
        ],
      ),
    );
  }

  void takephoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(source: source);
    setState(() {
      _imageFile = pickedFile!;
    });
  }
}
