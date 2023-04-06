import 'package:flutter/material.dart';
//import 'package:flutter/src/widgets/framework.dart';
//import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class Conditions extends StatefulWidget {
  const Conditions({super.key});
  
  @override
  State<Conditions> createState() => _ConditionsState();
}

class _ConditionsState extends State<Conditions> {
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
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Lottie.asset('assets/email-verification.json'),
                  Lottie.asset('assets/forgot-password.json'),
                  Lottie.asset('assets/signIn_screen.json'),
                  Lottie.asset('assets/swoosh-done-animation.json'),
                  Lottie.asset('assets/thank-you.json'),
                  Lottie.asset('assets/95247-email.json'),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Developed by miky',
                          style: GoogleFonts.sacramento(
                            textStyle: const TextStyle(fontSize: 18.0, color: Colors.white),
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