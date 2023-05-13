// ignore_for_file: deprecated_member_use, use_build_context_synchronously, prefer_final_fields, file_names, non_constant_identifier_names

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';

import '../../dashboard.dart';
import '../../widgets/nav_widget.dart';

class AddFosterHome extends StatefulWidget {
  const AddFosterHome({super.key});

  @override
  State<AddFosterHome> createState() => _AddFosterHomeState();
}

class _AddFosterHomeState extends State<AddFosterHome> {

  String _selectedPetType = 'Dog';
  final List<String> _petTypes = ['Dog', 'Cat', 'Fish', 'Other'];
  void _onPetTypeSelected(String petType) {
    setState(() {
      _selectedPetType = petType;
    });
  }

  bool _isVaccinated = false;

  void _onVaccinatedChanged(bool? value) {
    setState(() {
      _isVaccinated = value ?? false;
    });
  }

  String _vaccinationStatus() {
    return _isVaccinated ? 'Only Vaccinated' : 'Vaccinated/Non-Vaccinated';
  }

  RangeValues _frange = const RangeValues(0, 30);
  void _onPetAgeRangeChanged(RangeValues values) {
    setState(() {
      _frange = values;
    });
  }

  //  save Images
  List<File?> _images = List.generate(4, (_) => null);
  final List<String?> _imageUrls = List.generate(4, (_) => null);

  Future<void> _pickImage(int index) async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _images[index] = File(pickedFile.path);
      } else {
        if (kDebugMode) {
          print('No image selected.');
        }
      }
    });
  }

  //Remove selected images
  void _removeImage(int index) {
    setState(() {
      _images[index] = null;
    });
  }

  Future<void> _uploadImages() async {
    for (int i = 0; i < _images.length; i++) {
      if (_images[i] != null) {
        final FirebaseStorage storage = FirebaseStorage.instance;
        DateTime now = DateTime.now();
        String formattedDate =
            '${now.year}${now.month}${now.day}_${now.hour}${now.minute}${now.second}';
        Reference ref = storage.ref().child('foster_images/image_$formattedDate.jpg');
        UploadTask uploadTask = ref.putFile(_images[i]!);
        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
        final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
        _imageUrls[i] = downloadUrl;

        if (kDebugMode) {
          print('Image $i uploaded: $downloadUrl');
          print(_imageUrls[i]);
        }
      }
    }
  }

  Widget _buildImageContainer(int index) {
    return GestureDetector(
      onTap: () => _pickImage(index),
      child: Stack(
        children: [
          Container(
            height: 110,
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color.fromRGBO(198, 185, 250, 1),
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: _images[index] != null
                ? Image.file(
                    _images[index]!,
                    fit: BoxFit.cover,
                  )
                : const Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.add,
                        color: Color.fromRGBO(198, 185, 250, 1),
                      ),
                    ),
                  ),
          ),
          if (_images[index] != null)
            Positioned(
              top: 2,
              right: 2,
              child: GestureDetector(
                onTap: () => _removeImage(index),
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
    );
  }
  
final ownerId = FirebaseAuth.instance.currentUser!.email;

  String selectedPet = "";

  //String selectedVacc = "";
  //String adoptionStatus = "UFA";

  final f_name = TextEditingController();
  final f_city = TextEditingController();
  final f_charge = TextEditingController();
  //final pet_weight = TextEditingController();

  String image0 = "";
  String image1 = "";
  String image2 = "";
  String image3 = "";

  Future registerPets() async {
    await _uploadImages();
    String fosterdays =
        '${_frange.start.toInt()} - ${_frange.end.toInt()} D';
    String vacc = _vaccinationStatus().toString();

    if (kDebugMode) {
      print(ownerId);
    }
    //Add pets details to firestore
    addpets(
        f_name.text.trim(),
        _selectedPetType.trim(),
        f_city.text.trim(),
        int.parse(f_charge.text.trim()),
        fosterdays.trim(),
        vacc.trim(),
        ownerId.toString().trim(),
        _imageUrls[0].toString(),
        _imageUrls[1].toString(),
        _imageUrls[2].toString(),
        _imageUrls[3].toString());
  }

  Future addpets(
    String Name,
    String Type,
    String City,
    int Charge,
    String Days,
    String Vaccinated,
    String OwnID,
    String Image0,
    String Image1,
    String Image2,
    String Image3,
  ) async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
            child: CircularProgressIndicator(
          color: Colors.white,
        ));
      },
    );
    await FirebaseFirestore.instance.collection('foster').doc().set({
      '_fname': Name,
      '_type': Type,
      '_fcity': City,
      '_fcharge': Charge,
      '_fdays': Days,
      '_vaccination': Vaccinated,
      '_ownerID': OwnID,
      '_image0': Image0,
      '_image1': Image1,
      '_image2': Image2,
      '_image3': Image3,
    });
    Navigator.of(context).pop();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const Dashboard(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromRGBO(198, 185, 250, 1),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            IconlyLight.arrow_left_square,
            color: Colors.white,
          ),
        ),
        //title: Center(child: Text("Edit Profile",style: TextStyle(color: Colors.black,),)),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        minimum: const EdgeInsets.only(top: 10.0, bottom: 5.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 2.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Text(
                        "Foster Home Details",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: PetTypeNavBar(
                    petTypes: _petTypes,
                    onPetTypeSelected: _onPetTypeSelected,
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    textCapitalization: TextCapitalization.words,
                    controller: f_name,
                    style: const TextStyle(color: Colors.black, fontSize: 18.0),
                    cursorColor: const Color.fromRGBO(198, 185, 250, 1),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.abc_outlined,
                        color: Color.fromRGBO(198, 185, 250, 1),
                        size: 18.0,
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
                      hintText: "Coco, Luna",
                      hintStyle: const TextStyle(
                        color: Color.fromRGBO(198, 185, 250, 1),
                      ),
                      labelText: 'Foster Name',
                      labelStyle: const TextStyle(
                        color: Color.fromRGBO(198, 185, 250, 1),
                      ),
                      filled: false,
                      fillColor: const Color.fromRGBO(198, 185, 250, 1),
                      //labelText: "Email",
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: TextField(
                          textCapitalization: TextCapitalization.words,
                          controller: f_city,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 15.0),
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.abc_outlined,
                              color: Color.fromRGBO(198, 185, 250, 1),
                              size: 18.0,
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
                            hintText: "Ex - Pune",
                            hintStyle: const TextStyle(
                              color: Color.fromRGBO(198, 185, 250, 1),
                            ),
                            labelText: 'City',
                            labelStyle: const TextStyle(
                              color: Color.fromRGBO(198, 185, 250, 1),
                            ),
                            filled: false,
                            fillColor: const Color.fromRGBO(198, 185, 250, 1),
                            //labelText: "Email",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: TextField(
                          keyboardType: TextInputType.phone,
                          textCapitalization: TextCapitalization.words,
                          controller: f_charge,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 15.0),
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.abc_outlined,
                              color: Color.fromRGBO(198, 185, 250, 1),
                              size: 18.0,
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
                            hintText: "Ex : 500/-",
                            hintStyle: const TextStyle(
                              color: Color.fromRGBO(198, 185, 250, 1),
                            ),
                            labelText: 'Charge/day',
                            labelStyle: const TextStyle(
                              color: Color.fromRGBO(198, 185, 250, 1),
                            ),
                            filled: false,
                            fillColor: const Color.fromRGBO(198, 185, 250, 1),
                            //labelText: "Email",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                
                //Text('What is the age range of your pet?'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: RangeSlider(
                    activeColor: const Color.fromRGBO(198, 185, 250, 1),
                    values: _frange,
                    inactiveColor: Colors.grey[200],
                    min: 0,
                    max: 30,
                    divisions: 30,
                    labels: RangeLabels(
                      '${_frange.start.toInt()} days',
                      '${_frange.end.toInt()} days',
                    ),
                    onChanged: _onPetAgeRangeChanged,
                  ),
                ),
                Text(
                    'Min - Max days for foster : ${_frange.start.toInt()} - ${_frange.end.toInt()} days'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: CheckboxListTile(
                    checkColor: Colors.white,
                    activeColor: const Color.fromRGBO(198, 185, 250, 1),
                    title: const Text('Vaccinated?'),
                    value: _isVaccinated,
                    onChanged: _onVaccinatedChanged,
                  ),
                ),
                const SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(child: _buildImageContainer(0)),
                      const SizedBox(width: 10),
                      Expanded(child: _buildImageContainer(1)),
                      const SizedBox(width: 10),
                      Expanded(child: _buildImageContainer(2)),
                      const SizedBox(width: 10),
                      Expanded(child: _buildImageContainer(3)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: registerPets,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(198, 185, 250, 1),
                          border: Border.all(
                            color: const Color.fromRGBO(198, 185, 250, 1),
                          ),
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              "Add Foster ",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18.0),
                            ),
                            Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
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