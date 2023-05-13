// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, unused_field, prefer_final_fields, unused_element, deprecated_member_use, prefer_is_empty

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:peto/dashboard.dart';
import '../../widgets/nav_widget.dart';

class Addpets extends StatefulWidget {
  const Addpets({super.key});

  @override
  State<Addpets> createState() => _AddpetsState();
}

class _AddpetsState extends State<Addpets> {
  String _selectedPetType = 'Dog';
  final List<String> _petTypes = ['Dog', 'Cat', 'Fish', 'Other'];
  void _onPetTypeSelected(String petType) {
    setState(() {
      _selectedPetType = petType;
    });
  }

  final List<String> _gender = [
    'Male',
    'Female',
    'Unknown',
  ];
  String _selectedGender = 'Male';
  void _onGenderSelected(String gender) {
    setState(() {
      _selectedGender = gender;
    });
  }

  bool _isVaccinated = false;

  void _onVaccinatedChanged(bool? value) {
    setState(() {
      _isVaccinated = value ?? false;
    });
  }

  String _vaccinationStatus() {
    return _isVaccinated ? 'Vaccinated' : 'Not Vaccinated';
  }

  RangeValues _petAgeRange = const RangeValues(0, 12);
  void _onPetAgeRangeChanged(RangeValues values) {
    setState(() {
      _petAgeRange = values;
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
        Reference ref = storage.ref().child('pets_images/image_$formattedDate.jpg');
        UploadTask uploadTask = ref.putFile(_images[i]!);
        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
        final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
        _imageUrls[i] = downloadUrl;

        if (kDebugMode) {
          print('Image $i uploaded: $downloadUrl');
          print(_imageUrls[i]);
        }
        // save the url to Firestore using `set()` or `update()` method
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
  String selectedGender = "";
  String selectedAge = "";
  //String selectedVacc = "";
  String adoptionStatus = "UFA";

  final pet_name = TextEditingController();
  final pet_breed = TextEditingController();
  final pet_color = TextEditingController();
  final pet_weight = TextEditingController();

  String image0 = "";
  String image1 = "";
  String image2 = "";
  String image3 = "";

  Future registerPets() async {
    await _uploadImages();
    String petAgeRangeString =
        '${_petAgeRange.start.toInt()} - ${_petAgeRange.end.toInt()} M';
    String vacc = _vaccinationStatus().toString();

    if (kDebugMode) {
      print(ownerId);
    }
    //Add pets details to firestore
    addpets(
        pet_name.text.trim(),
        _selectedPetType.trim(),
        pet_breed.text.trim(),
        _selectedGender.trim(),
        pet_color.text.trim(),
        petAgeRangeString.trim(),
        vacc.trim(),
        ownerId.toString().trim(),
        adoptionStatus.trim(),
        _imageUrls[0].toString(),
        _imageUrls[1].toString(),
        _imageUrls[2].toString(),
        _imageUrls[3].toString());
  }

  Future addpets(
    String Name,
    String Type,
    String Breed,
    String Gender,
    String Color,
    String Age,
    String Vaccinated,
    String OwnID,
    String AS,
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
    await FirebaseFirestore.instance.collection('pets').doc().set({
      '_name': Name,
      '_type': Type,
      '_breed': Breed,
      '_gender': Gender,
      '_color': Color,
      '_age': Age,
      '_vaccination': Vaccinated,
      '_ownerID': OwnID,
      '_adoption status': AS,
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
                        "Pet Details",
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
                    controller: pet_name,
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
                      labelText: 'Pet Name',
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
                    /*Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal:25.0),
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color.fromRGBO(198, 185, 250, 1),),borderRadius: BorderRadius.circular(10.0)),
                              focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color.fromRGBO(198, 185, 250, 1),),borderRadius: BorderRadius.circular(10.0)),
                               //hintText: "Coco, Luna",
                               //hintStyle: const TextStyle(color: Colors.white),
                               labelText: 'Type',
                               labelStyle: const TextStyle(color: Color.fromRGBO(198, 185, 250, 1),),
                                filled: false,
                                 fillColor: const Color.fromRGBO(198, 185, 250, 1),
                            ),
                        icon: const Icon(Icons.pets),
                        iconEnabledColor: const Color.fromRGBO(198, 185, 250, 1),
                        style: const TextStyle(color: Colors.black,fontSize: 15.0),
                        borderRadius: BorderRadius.circular(8.0),
                        dropdownColor: const Color.fromRGBO(198, 185, 250, 1),
                        hint: const Text("Type",style: TextStyle(color: Color.fromRGBO(198, 185, 250, 1),),),
                        value: selectedPet.isNotEmpty ? selectedPet : null,
                        onChanged: (String ? newValue){
                          setState(() {
                            selectedPet = newValue!;
                          }
                          );
                        },
                        items: <String>['Dog', 'Cat', 'Fish', 'Ham', 'Bird', 'Turtle'].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),*/
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: TextField(
                          textCapitalization: TextCapitalization.words,
                          controller: pet_breed,
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
                            hintText: "Indi, Husky",
                            hintStyle: const TextStyle(
                              color: Color.fromRGBO(198, 185, 250, 1),
                            ),
                            labelText: 'Breed',
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
                    /*Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal:25.0),
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color.fromRGBO(198, 185, 250, 1),),borderRadius: BorderRadius.circular(10.0)),
                              focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color.fromRGBO(198, 185, 250, 1),),borderRadius: BorderRadius.circular(10.0)),
                               //hintText: "Coco, Luna",
                               //hintStyle: const TextStyle(color: Colors.white),
                               labelText: 'Gender',
                               labelStyle: const TextStyle(color: Color.fromRGBO(198, 185, 250, 1),),
                                filled: false,
                                fillColor: const Color.fromRGBO(198, 185, 250, 1),
                            ),
                        icon: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.person_2),
                        ),
                        iconEnabledColor: const Color.fromRGBO(198, 185, 250, 1),
                        style: const TextStyle(color: Colors.black,fontSize: 15.0),
                        borderRadius: BorderRadius.circular(8.0),
                        dropdownColor: const Color.fromRGBO(198, 185, 250, 1),
                        hint: const Text("Gender",style: TextStyle(color: Color.fromRGBO(198, 185, 250, 1),),),
                        value: selectedGender.isNotEmpty ? selectedGender : null,
                        onChanged: (String ? newValue){
                          setState(() {
                            selectedGender = newValue!;
                          }
                          );
                        },
                        items: <String>['Male', 'Female', 'Other'].map<DropdownMenuItem<String>>((String v) {
                          return DropdownMenuItem<String>(
                          value: v,
                          child: Text(v),
                          );
                        }).toList(),
                      ),
                    ),
                  ),*/
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: TextField(
                          textCapitalization: TextCapitalization.words,
                          controller: pet_color,
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
                            hintText: "White, Black, Ash",
                            hintStyle: const TextStyle(
                              color: Color.fromRGBO(198, 185, 250, 1),
                            ),
                            labelText: 'Color',
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: PetTypeNavBar(
                    petTypes: _gender,
                    onPetTypeSelected: _onGenderSelected,
                  ),
                ),
                const SizedBox(height: 10.0),

                //Text('What is the age range of your pet?'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: RangeSlider(
                    activeColor: const Color.fromRGBO(198, 185, 250, 1),
                    values: _petAgeRange,
                    inactiveColor: Colors.grey[200],
                    min: 0,
                    max: 12,
                    divisions: 12,
                    labels: RangeLabels(
                      '${_petAgeRange.start.toInt()} months',
                      '${_petAgeRange.end.toInt()} months',
                    ),
                    onChanged: _onPetAgeRangeChanged,
                  ),
                ),
                Text(
                    'Pet age range : ${_petAgeRange.start.toInt()} - ${_petAgeRange.end.toInt()} months'),
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
                /*Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left:25.0,),
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color.fromRGBO(198, 185, 250, 1),),borderRadius: BorderRadius.circular(10.0)),
                              focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color.fromRGBO(198, 185, 250, 1),),borderRadius: BorderRadius.circular(10.0)),
                               //hintText: "Coco, Luna",
                               //hintStyle: const TextStyle(color: Colors.white),
                               labelText: 'Age',
                               labelStyle: const TextStyle(color: Color.fromRGBO(198, 185, 250, 1),),
                                filled: false,
                                 fillColor: const Color.fromRGBO(198, 185, 250, 1),
                            ),
                        iconEnabledColor: const Color.fromRGBO(198, 185, 250, 1),
                        style: const TextStyle(color: Colors.black,fontSize: 15.0),
                        borderRadius: BorderRadius.circular(8.0),
                        dropdownColor: const Color.fromRGBO(198, 185, 250, 1),
                        value: selectedAge.isNotEmpty ? selectedAge : null,
                        hint: const Text("Age",style: TextStyle(color: Colors.white),),
                        onChanged: (String ? newValue){
                          setState(() {
                            selectedAge = newValue!;
                          }
                          );
                        },
                        items: <String>['< 1 M', '> 1 M', '1 - 3 M', '3 - 6 M', '6 - 9 M', '1  Y', '> 1 Y'].map<DropdownMenuItem<String>>((String v) {
                          return DropdownMenuItem<String>(
                          value: v,
                          child: Text(v),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left:10.0, right: 10.0),
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color.fromRGBO(198, 185, 250, 1),),borderRadius: BorderRadius.circular(10.0)),
                              focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color.fromRGBO(198, 185, 250, 1),),borderRadius: BorderRadius.circular(10.0)),
                               //hintText: "Coco, Luna",
                               //hintStyle: const TextStyle(color: Colors.white),
                               labelText: 'Vaccinated',
                               labelStyle: const TextStyle(color: Color.fromRGBO(198, 185, 250, 1),),
                                filled: false,
                                 fillColor: const Color.fromRGBO(198, 185, 250, 1),
                          ),
                        
                        iconEnabledColor: const Color.fromRGBO(198, 185, 250, 1),
                        style: const TextStyle(color: Colors.black,fontSize: 15.0),
                        borderRadius: BorderRadius.circular(8.0),
                        dropdownColor: const Color.fromRGBO(198, 185, 250, 1),
                        value: selectedVacc.isNotEmpty ? selectedVacc : null,
                        hint: const Text("Vaccinated",style: TextStyle(color: Color.fromRGBO(198, 185, 250, 1),),),
                        onChanged: (String ? newValue){
                          setState(() {
                            selectedVacc = newValue!;
                          }
                          );
                        },
                        items: <String>['Yes', 'No'].map<DropdownMenuItem<String>>((String v) {
                          return DropdownMenuItem<String>(
                          value: v,
                          child: Text(v),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  Expanded(
                    child: Padding(
                    padding: const EdgeInsets.only(right: 25.0),
                    child: TextField(
                      textCapitalization: TextCapitalization.words,
                      controller: pet_weight,
                      style: const TextStyle(color: Colors.black,fontSize: 15.0),
                      cursorColor: const Color.fromRGBO(198, 185, 250, 1),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.abc_outlined,color: Color.fromRGBO(198, 185, 250, 1),size: 18.0,),
                        enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color.fromRGBO(198, 185, 250, 1),),borderRadius: BorderRadius.circular(10.0)),
                        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color.fromRGBO(198, 185, 250, 1),),borderRadius: BorderRadius.circular(10.0)),
                        hintText: "in Kgs",
                        hintStyle: const TextStyle(color: Color.fromRGBO(198, 185, 250, 1),fontSize: 15.0),
                        labelText: 'Weight',
                        labelStyle: const TextStyle(color: Color.fromRGBO(198, 185, 250, 1),fontSize: 13.0),
                        filled: false,
                        fillColor: const Color.fromRGBO(198, 185, 250, 1),
                        //labelText: "Email",
                      ),
                    ),
                    ),
                  ),
                ],
              ),*/
                /* Row(
                mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal:25.0),
                          child: DropdownButtonFormField<dynamic>(
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color.fromRGBO(198, 185, 250, 1),),borderRadius: BorderRadius.circular(10.0)),
                              focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color.fromRGBO(198, 185, 250, 1),),borderRadius: BorderRadius.circular(10.0)),
                               //hintText: "Coco, Luna",
                               //hintStyle: const TextStyle(color: Colors.white),
                               labelText: 'City',
                               labelStyle: const TextStyle(color: Color.fromRGBO(198, 185, 250, 1),),
                                filled: true,
                                 fillColor: const Color.fromRGBO(198, 185, 250, 1),
                            ),
                            style: const TextStyle(color: Colors.black,fontSize: 15.0),
                            dropdownColor: Color.fromRGBO(198, 185, 250, 1),
                            iconEnabledColor: Color.fromRGBO(198, 185, 250, 1),
                                value: _selectedCity,
                                items: _cities.map((city) {
                                  return DropdownMenuItem<dynamic>(
                                    value: city['name'],
                                    child: Text(city['name']),
                                 );
                                }).toList(),
                                onChanged: (dynamic newValue){
                                  setState(() {
                                    _selectedCity = newValue;
                                  });
                                }
                              ),
                        ),
                      ),  
                 ],
                ),*/
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
                              "Add Pet ",
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
