// ignore_for_file: prefer_const_constructors, unused_element, duplicate_ignore, unnecessary_null_comparison, non_constant_identifier_names, prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

class Addpets extends StatefulWidget {
  const Addpets({super.key});

  @override
  State<Addpets> createState() => _AddpetsState();
}

class _AddpetsState extends State<Addpets> {

  String selectedPet = "";
  String selectedGender = "";
  String selectedAge = "";
  String selectedVacc = "";


  Future<List<dynamic>> _loadJsonData(String assetPath) async {
  final jsonString = await rootBundle.loadString(assetPath);
  final data = json.decode(jsonString);
  return data;
}
  dynamic _selectedCounty;
  dynamic _selectedState;
  //String? _selectedCity;

  List<dynamic> _counties = [];
  List<dynamic> _states = [];
  //List<dynamic> _cities = [];

   @override
    void initState() {
    super.initState();
    _loadData();
  }

   Future<void> _loadData() async {
    _counties = await _loadJsonData('assets/county.json');
    _states = await _loadJsonData('assets/state.json');
   // _cities = await _loadJsonData('assets/city.json');
    setState(() {});
  }


  final pet_name = TextEditingController();
  final pet_breed = TextEditingController();
  final pet_color = TextEditingController();
  final pet_weight = TextEditingController();
  //final pet_country = TextEditingController();
  //final pet_state = TextEditingController();
  //final pet_city = TextEditingController();

  Future registerPets() async {
    //Add pets details to firestore
    addpets(
      pet_name.text.trim(),
      selectedPet.trim(),
      pet_breed.text.trim(),
      selectedGender.trim(),
      pet_color.text.trim(),
      selectedAge.trim(),
      selectedVacc.trim(),
      pet_weight.text.trim(),
      //pet_country.text.trim(),
      //pet_state.text.trim(),
      //pet_city.text.trim(),
      
    );
  }

  Future addpets(String Name, String Type, String Breed, String Gender, String Color, String Age, String Vaccinated, String Weight) async{
    await FirebaseFirestore.instance.collection('pets').doc(Type).set({
      '_name':Name,
      '_type':Type,
      '_breed':Breed,
      '_gender':Gender,
      '_color':Color,
      '_age':Age,
      '_vaccinated':Vaccinated,
      '_weight':Weight + "kgs",
      //'_country':City,
      //'_state':City,
      //'_city':City,
    });
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors:[
            Color.fromRGBO(200, 161, 249, 1), 
            Color.fromRGBO(141, 173, 248, 1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomLeft,
            )
            ),
      child: Scaffold(
       backgroundColor: Colors.transparent,
        body: SafeArea(
          minimum: const EdgeInsets.only(top: 40.0,bottom: 40.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Lottie.asset('assets/fetching-business-details.json',width: 300,height: 300),
                  // ignore: prefer_const_constructors
                  const SizedBox(height: 2.0,),
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        const Text(
                          "Let's get your pet a New Home :)",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextField(
                      textCapitalization: TextCapitalization.words,
                      controller: pet_name,
                      style: const TextStyle(color: Colors.white,fontSize: 18.0),
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.abc_outlined,color: Colors.white,size: 18.0,),
                        enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(10.0)),
                        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(10.0)),
                        hintText: "Coco, Luna",
                        hintStyle: const TextStyle(color: Colors.white),
                        labelText: 'Pet Name',
                        labelStyle: const TextStyle(color: Colors.white),
                        filled: true,
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
                        padding: const EdgeInsets.symmetric(horizontal:25.0),
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(10.0)),
                                focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(10.0)),
                                 //hintText: "Coco, Luna",
                                 //hintStyle: const TextStyle(color: Colors.white),
                                 labelText: 'Type',
                                 labelStyle: const TextStyle(color: Colors.white),
                                  filled: true,
                                   fillColor: const Color.fromRGBO(198, 185, 250, 1),
                              ),
                          icon: const Icon(Icons.pets),
                          iconEnabledColor: Colors.white,
                          style: const TextStyle(color: Colors.white,fontSize: 15.0),
                          borderRadius: BorderRadius.circular(8.0),
                          dropdownColor: const Color.fromRGBO(198, 185, 250, 1),
                          hint: const Text("Type",style: TextStyle(color: Colors.white),),
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
                    ),
                    Expanded(
                      child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: TextField(
                        textCapitalization: TextCapitalization.words,
                        controller: pet_breed,
                        style: const TextStyle(color: Colors.white,fontSize: 15.0),
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.abc_outlined,color: Colors.white,size: 18.0,),
                          enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(10.0)),
                          focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(10.0)),
                          hintText: "Indi, Husky",
                          hintStyle: const TextStyle(color: Colors.white),
                          labelText: 'Breed',
                          labelStyle: const TextStyle(color: Colors.white),
                          filled: true,
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
                        padding: const EdgeInsets.symmetric(horizontal:25.0),
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(10.0)),
                                focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(10.0)),
                                 //hintText: "Coco, Luna",
                                 //hintStyle: const TextStyle(color: Colors.white),
                                 labelText: 'Gender',
                                 labelStyle: const TextStyle(color: Colors.white),
                                  filled: true,
                                   fillColor: const Color.fromRGBO(198, 185, 250, 1),
                              ),
                          icon: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.person_2),
                          ),
                          iconEnabledColor: Colors.white,
                          style: const TextStyle(color: Colors.white,fontSize: 15.0),
                          borderRadius: BorderRadius.circular(8.0),
                          dropdownColor: const Color.fromRGBO(198, 185, 250, 1),
                          hint: const Text("Gender",style: TextStyle(color: Colors.white),),
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
                    ),
                        Expanded(
                          child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: TextField(
                            textCapitalization: TextCapitalization.words,
                            controller: pet_color,
                            style: const TextStyle(color: Colors.white,fontSize: 15.0),
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.abc_outlined,color: Colors.white,size: 18.0,),
                              enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(10.0)),
                              focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(10.0)),
                              hintText: "White, Black, Ash",
                              hintStyle: const TextStyle(color: Colors.white),
                              labelText: 'Color',
                              labelStyle: const TextStyle(color: Colors.white),
                              filled: true,
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
                        padding: const EdgeInsets.only(left:25.0,),
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(10.0)),
                                focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(10.0)),
                                 //hintText: "Coco, Luna",
                                 //hintStyle: const TextStyle(color: Colors.white),
                                 labelText: 'Age',
                                 labelStyle: const TextStyle(color: Colors.white),
                                  filled: true,
                                   fillColor: const Color.fromRGBO(198, 185, 250, 1),
                              ),
                          iconEnabledColor: Colors.white,
                          style: const TextStyle(color: Colors.white,fontSize: 15.0),
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
                                enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(10.0)),
                                focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(10.0)),
                                 //hintText: "Coco, Luna",
                                 //hintStyle: const TextStyle(color: Colors.white),
                                 labelText: 'Vaccinated',
                                 labelStyle: const TextStyle(color: Colors.white),
                                  filled: true,
                                   fillColor: const Color.fromRGBO(198, 185, 250, 1),
                              ),
                          
                          iconEnabledColor: Colors.white,
                          style: const TextStyle(color: Colors.white,fontSize: 15.0),
                          borderRadius: BorderRadius.circular(8.0),
                          dropdownColor: const Color.fromRGBO(198, 185, 250, 1),
                          value: selectedVacc.isNotEmpty ? selectedVacc : null,
                          hint: const Text("Vaccinated",style: TextStyle(color: Colors.white),),
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
                        style: const TextStyle(color: Colors.white,fontSize: 15.0),
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.abc_outlined,color: Colors.white,size: 18.0,),
                          enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(10.0)),
                          focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(10.0)),
                          hintText: "in Kgs",
                          hintStyle: const TextStyle(color: Colors.white,fontSize: 15.0),
                          labelText: 'Weight',
                          labelStyle: const TextStyle(color: Colors.white,fontSize: 13.0),
                          filled: true,
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
                            padding: const EdgeInsets.symmetric(horizontal:25.0),
                            child: DropdownButtonFormField<dynamic>(
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(10.0)),
                                focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(10.0)),
                                 //hintText: "Coco, Luna",
                                 //hintStyle: const TextStyle(color: Colors.white),
                                 labelText: 'Country',
                                 labelStyle: const TextStyle(color: Colors.white),
                                  filled: true,
                                   fillColor: const Color.fromRGBO(198, 185, 250, 1),
                              ),
                              style: const TextStyle(color: Colors.white,fontSize: 15.0),
                              dropdownColor: Color.fromRGBO(198, 185, 250, 1),
                              iconEnabledColor: Colors.white,
                                  value: _selectedCounty,
                                  items: _counties.map((county) {
                                  return DropdownMenuItem<dynamic>(
                                   value: county['name'],
                                    child: Text(county['name']),
                                   );
                                  }).toList(),
                                  onChanged: (dynamic newValue){
                                    setState(() {
                                      _selectedCounty = newValue;
                                      _selectedState = null;
                                    });
                                  }
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
                            padding: const EdgeInsets.symmetric(horizontal:25.0),
                            child: DropdownButtonFormField<dynamic>(
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(10.0)),
                                focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(10.0)),
                                 //hintText: "Coco, Luna",
                                 //hintStyle: const TextStyle(color: Colors.white),
                                 labelText: 'State',
                                 labelStyle: const TextStyle(color: Colors.white),
                                  filled: true,
                                   fillColor: const Color.fromRGBO(198, 185, 250, 1),
                              ),
                              style: const TextStyle(color: Colors.white,fontSize: 15.0),
                              dropdownColor: Color.fromRGBO(198, 185, 250, 1),
                              iconEnabledColor: Colors.white,
                                  value: _selectedState,
                                  items: _states.map((state) {
                                    return DropdownMenuItem<dynamic>(
                                      value: state['name'],
                                      child: Text(state['name']),
                                   );
                                  }).toList(),
                                  onChanged: (dynamic newValue){
                                    setState(() {
                                      _selectedState = newValue;
                                    });
                                  }
                                ),
                          ),
                        ),  
                   ],
                 ),
                const SizedBox(height: 20.0),
                  GestureDetector(
                    onTap: registerPets,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(10.0)
                        ),
                        child:  Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              const Text("Add Pet ",
                              style: TextStyle(color: Colors.black, fontSize: 18.0),),
                              const Icon(Icons.add,color: Colors.black,),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}