// ignore_for_file: implementation_imports

import 'package:flutter/src/widgets/framework.dart';
import '../main/login.dart';
import '../main/newuser.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {

  bool showLoginpage = true;

  void toggleScreens(){
    setState(() {
      showLoginpage = ! showLoginpage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(showLoginpage){
      return Login(showregisteruser: toggleScreens);
    }else{
      return NewUser(showloginpage: toggleScreens);
    }
  }
}