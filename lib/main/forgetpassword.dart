// ignore_for_file: prefer_const_constructors, sort_child_properties_last, use_build_context_synchronously, duplicate_ignore
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
//import 'package:flutter/src/widgets/framework.dart';
//import 'package:flutter/src/widgets/placeholder.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});
  

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {

  //Text Field Controller
  final _forgetemailcontroller = TextEditingController();
  

  //Dispose
  @override
  void dispose() {
    _forgetemailcontroller.dispose();
    super.dispose();
  }

  //Forget Password Function
  Future passwordReset() async{
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _forgetemailcontroller.text.trim());
      showDialog(
        context: context, 
        builder: (context){
          return AlertDialog(
            content: Text("Reset link sent! Check you email"),
          );
        }
        );
    }on FirebaseAuthException catch (e){
      if (kDebugMode) {
        print(e);
      }
      showDialog(
        context: context, 
        builder: (context){
          return AlertDialog(
            content: Text(e.message.toString()),
          );
        }
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors:[
            Color.fromRGBO(200, 161, 249, 1), 
            Color.fromRGBO(141, 173, 248, 1)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomLeft,
        )
      ),
      child:  Scaffold(
        backgroundColor: Colors.transparent,
       // appBar: AppBar(backgroundColor: const Color.fromRGBO(200, 161, 249, 1),),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Lottie.asset('assets/forgot-password.json'),
                  ),//Lottie.asset('assets/email-verification.json'),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [//Icon(Icons.contact_mail,size: 150.0,color: Colors.white,),
                          ],
                        ),
                      ),
                    ),
                     const SizedBox(height: 20.0,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          const Text(
                            'Forget your password? ',
                            // ignore: prefer_const_constructors
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 2.0,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          const Text(
                            "Enter your registered emai below to receive pasaword reset link",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              color: Colors.white,
                              ),
                            ),
                        ],
                      ),
                    ),                  
                    const SizedBox(height: 20.0,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: 
                          TextField(
                            controller: _forgetemailcontroller,
                            style: TextStyle(color: Colors.white,fontSize: 18.0),
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(bottom: 15.0),
                                  child: Lottie.asset('assets/email.json',width: 4,height: 4),
                        ),
                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(10.0)),
                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(10.0)),
                              hintText: "Email",
                              hintStyle: TextStyle(color: Colors.white),
                              labelText: 'Email',
                              labelStyle: TextStyle(color: Colors.white),
                              filled: true,
                              fillColor: Color.fromRGBO(198, 185, 250, 1),
                              //labelText: "Email",
                            ),
                          ),
                        ),
                        SizedBox(height: 10.0,),
                        GestureDetector(
                          onTap: passwordReset,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(10.0)
                              ),
                              child: Center(
                                child: Text("Forget Password",
                                style: TextStyle(color: Colors.black, fontSize: 18.0),
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
      ),
    );
  }
}