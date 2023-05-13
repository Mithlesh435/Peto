// ignore_for_file: non_constant_identifier_names, no_leading_underscores_for_local_identifiers, avoid_print, deprecated_member_use, unused_element
//import 'dart:ffi';

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

class NewUser extends StatefulWidget {
  final VoidCallback showloginpage;
  const NewUser({Key? key, required this.showloginpage}) : super(key: key);

  @override
  State<NewUser> createState() => _NewUserState();
}

class _NewUserState extends State<NewUser> {
  File? _image;
  String? _imageUrl;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        if (kDebugMode) {
          print('No image selected.');
        }
      }
    });
  }

  void _removeImage() {
    setState(() {
      _image = null;
    });
  }

  Future<void> _uploadImages() async {
    if (_image != null) {
      final FirebaseStorage storage = FirebaseStorage.instance;
      DateTime now = DateTime.now();
      String formattedDate =
          '${now.year}${now.month}${now.day}_${now.hour}${now.minute}${now.second}';
      Reference ref =
          storage.ref().child('user_image/image_$formattedDate.jpg');
      UploadTask uploadTask = ref.putFile(_image!);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      _imageUrl = downloadUrl;

      if (kDebugMode) {
        print('Image ploaded: $downloadUrl');
        print(_imageUrl);
      }
      // save the url to Firestore using `set()` or `update()` method
    }
  }

  //Controllers
  final _create_emailcontroller = TextEditingController();
  final _create_namecontroller = TextEditingController();
  final _create_phonecontroller = TextEditingController();
  final _create_citycontroller = TextEditingController();
  final _create_passwordcontroller = TextEditingController();

  //Create_user
  Future registerUser() async {
    await _uploadImages();
    //Authenticate User
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: _create_emailcontroller.text.trim(),
      password: _create_passwordcontroller.text.trim(),
    );
    //Add User details to firestore
    addUserDetails(
      _create_namecontroller.text.trim(),
      _create_emailcontroller.text.trim(),
      int.parse(_create_phonecontroller.text.trim()),
      _create_citycontroller.text.trim(),
      _imageUrl.toString(),
    );
  }

  Future addUserDetails(
    String Name,
    String Email,
    int Phone,
    String City,
    String Image,
  ) async {
    await FirebaseFirestore.instance.collection('users').add({
      '_name': Name,
      '_email': Email,
      '_phone': Phone,
      '_city': City,
      '_image': Image,
    });
  }

  @override
  void dispose() {
    _create_emailcontroller.dispose();
    _create_namecontroller.dispose();
    _create_phonecontroller.dispose();
    _create_citycontroller.dispose();
    _create_passwordcontroller.dispose();
    super.dispose();
  }

  void getCurrentUserUid() {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
    final uid = user?.uid;
    print('Current user UID: $uid');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
        colors: [
          Color.fromRGBO(200, 161, 249, 1),
          Color.fromRGBO(141, 173, 248, 1)
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomLeft,
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  //Lottie.asset('assets/newUser_sea-walk.json', height: 200),
                  // ignore: prefer_const_constructors
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        const Text(
                          'Get on Board!',
                          // ignore: prefer_const_constructors
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 2.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        const Text(
                          "Create profile to start your journey :)",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Stack(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: GestureDetector(
                            onTap: () => _pickImage(),
                            child: _image != null
                                ? Image.file(
                                    _image!,
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(IconlyLight.plus)),
                      ),
                      if (_image != null)
                        Positioned(
                          top: 2,
                          right: 2,
                          child: GestureDetector(
                            onTap: () => _removeImage(),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: Colors.white,
                                //shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                IconlyLight.close_square,
                                color: Colors.red,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _create_emailcontroller,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 18.0),
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: Lottie.asset('assets/email.json',
                              width: 4, height: 4),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(10.0)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(10.0)),
                        hintText: "Email",
                        hintStyle: const TextStyle(color: Colors.white),
                        labelText: 'Email',
                        labelStyle: const TextStyle(color: Colors.white),
                        filled: true,
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
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      controller: _create_namecontroller,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 18.0),
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(10.0)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(10.0)),
                        hintText: "Name",
                        hintStyle: const TextStyle(color: Colors.white),
                        labelText: 'Name',
                        labelStyle: const TextStyle(color: Colors.white),
                        filled: true,
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
                      controller: _create_phonecontroller,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 18.0),
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.call,
                          color: Colors.white,
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(10.0)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(10.0)),
                        hintText: "Phone",
                        hintStyle: const TextStyle(color: Colors.white),
                        labelText: 'Phone',
                        labelStyle: const TextStyle(color: Colors.white),
                        filled: true,
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
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.words,
                      controller: _create_citycontroller,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 18.0),
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.location_city,
                          color: Colors.white,
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(10.0)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(10.0)),
                        hintText: "City",
                        hintStyle: const TextStyle(color: Colors.white),
                        labelText: 'City',
                        labelStyle: const TextStyle(color: Colors.white),
                        filled: true,
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
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      controller: _create_passwordcontroller,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 18.0),
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.fingerprint,
                          color: Colors.white,
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(10.0)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(10.0)),
                        border: const OutlineInputBorder(),
                        hintText: "Password",
                        hintStyle: const TextStyle(color: Colors.white),
                        labelText: 'Password',
                        labelStyle: const TextStyle(color: Colors.white),
                        filled: true,
                        fillColor: const Color.fromRGBO(198, 185, 250, 1),
                        //labelText: "Email",
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  GestureDetector(
                    onTap: registerUser,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(10.0)),
                        child: const Center(
                          child: Text(
                            "Create Account",
                            style:
                                TextStyle(color: Colors.black, fontSize: 18.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      const Text(
                        "Already have an account?  ",
                        style: TextStyle(color: Colors.white, fontSize: 15.0),
                      ),
                      GestureDetector(
                          onTap: widget.showloginpage,
                          child: const Text(
                            "Sign In",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold),
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
