import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_imgae/admin_screen.dart';
import 'package:firebase_imgae/fetch_screen.dart';
import 'package:firebase_imgae/firebase_options.dart';
import 'package:firebase_imgae/insert_screen.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  Future userLog ()async{
    SharedPreferences userCheck = await SharedPreferences.getInstance();
    return userCheck.getString("userCheck");
  }

  @override
  void initState() {
    // TODO: implement initState
    userLog().then((value) {
      if (value=="admin") {
        Timer(Duration(milliseconds: 3000),  () => Navigator.push(context, MaterialPageRoute(builder: (context) => AdminScreen(),)),);
      }
      else if (value=="user") {
        Timer(Duration(milliseconds: 3000),  () => Navigator.push(context, MaterialPageRoute(builder: (context) => FetchScreen(),)),);
      }
      else{
        Timer(Duration(milliseconds: 3000),  () => Navigator.push(context, MaterialPageRoute(builder: (context) => InsertScreen(),)),);
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Kuch Bhi",style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold
        ),),
      ),
    );
  }
}


