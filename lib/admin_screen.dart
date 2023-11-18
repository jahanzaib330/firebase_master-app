import 'package:firebase_imgae/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
            onTap: ()async{
              SharedPreferences userCheck = await SharedPreferences.getInstance();
              userCheck.clear();
              Navigator.push(context, MaterialPageRoute(builder: (context) => SplashScreen(),));
            },
            child: Text("Admin Panel")),
      ),
    );
  }
}
