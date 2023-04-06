import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:peto/dashboard.dart';
import 'auth.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            return const Dashboard();
          }else{
            return const Auth();
          }
        }
      ,),
    );
  }
}
