// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:peto/main/conditions.dart';
import 'forgetpassword.dart';


class Login extends StatefulWidget {
  final VoidCallback showregisteruser;
  const Login({Key? key, required this.showregisteruser}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //Text Controller
  final _emailcontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();

  //Sign In Function
  Future signIn() async {

    showDialog(
      context: context, 
      builder: (context){
        return Center(child: CircularProgressIndicator(color: Colors.white,));
      },
    );

    await  FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _emailcontroller.text.trim(), 
      password: _passwordcontroller.text.trim()
    );
    Navigator.of(context).pop();
    
  }

  @override
  void dispose() {
    _emailcontroller.dispose();
    _passwordcontroller.dispose();  
      super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors:const [
            Color.fromRGBO(200, 161, 249, 1), 
            Color.fromRGBO(141, 173, 248, 1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomLeft,
            )
            ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Lottie.asset('assets/signIn_screen.json',width: 360),
                  Text(
                    'Welcome',
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(fontSize: 25.0, color: Colors.white),
                    ),
                    ),
                  SizedBox(height: 5.0,),
                  Text(
                    "Pleasure to have you here!",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                      ),
                    ),
                  SizedBox(height: 20.0,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextField(
                      controller: _emailcontroller,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: Colors.white,fontSize: 18.0),
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: Lottie.asset('assets/email.json',width: 4,height: 4),
                        ),//Icon(Icons.email,color: Colors.white,),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextField(
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      controller: _passwordcontroller,
                      keyboardType: TextInputType.visiblePassword,
                      style: TextStyle(color: Colors.white,fontSize: 18.0),
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.fingerprint,color: Colors.white,),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(10.0)),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(10.0)),
                        border: OutlineInputBorder(),
                        hintText: "Password",hintStyle: TextStyle(color: Colors.white),
                        labelText: 'Password',labelStyle: TextStyle(color: Colors.white),
                        filled: true,
                        fillColor: Color.fromRGBO(198, 185, 250, 1),
                      ),
                      
                    ),
                  ),
                  SizedBox(height: 10.0),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return ForgetPassword();
                      },),);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          Text('Forget Password?',style: TextStyle(color: Colors.white),),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  
                  GestureDetector(
                    onTap: signIn,
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
                          child: Text("Sign In",
                          style: TextStyle(color: Colors.black, fontSize: 18.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        Text("By login or creating your account you agree to our ",style: TextStyle(color: Colors.white,fontSize: 12.0),),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                            return Conditions();
                            },
                          ),); },
                          child: Text(
                            "Terms & Conditions",
                            style: 
                              TextStyle(color: Colors.white, fontSize: 12.0,fontWeight: FontWeight.bold),
                            )
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      Text("Don't have an account?  ",style: TextStyle(color: Colors.white,fontSize: 15.0),),
                      GestureDetector(
                        onTap: widget.showregisteruser,
                        child: Text(
                          "Create Account",
                          style: 
                            TextStyle(color: Colors.white, fontSize: 15.0,fontWeight: FontWeight.bold),
                          )
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Developed by miky',
                          style: GoogleFonts.sacramento(
                            textStyle: TextStyle(fontSize: 18.0, color: Colors.white),
                          ),
                          ),
                      ],
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