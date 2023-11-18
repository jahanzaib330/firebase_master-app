import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_imgae/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class InsertScreen extends StatefulWidget {
  const InsertScreen({super.key});

  @override
  State<InsertScreen> createState() => _InsertScreenState();
}

class _InsertScreenState extends State<InsertScreen> {

  TextEditingController userName = TextEditingController();
  TextEditingController userEmail = TextEditingController();
  TextEditingController userAge = TextEditingController();
  TextEditingController userGender = TextEditingController();
  TextEditingController userPassword = TextEditingController();

  File? userProfile;
  bool screenLoader = false;

  void userInertwithImage()async{
    setState(() {
      screenLoader = !screenLoader;
    });
    String userID = Uuid().v1();
    UploadTask uploadTask = FirebaseStorage.instance.ref().child("User-Images").child(Uuid().v1()).putFile(userProfile!);
    TaskSnapshot taskSnapshot = await uploadTask;
    String userImage = await taskSnapshot.ref.getDownloadURL();
    SharedPreferences userLog = await SharedPreferences.getInstance();
    userLog.setString('userID', userID);
    userInsert(imgUrl: userImage,uID: userID);
    setState(() {
      screenLoader = !screenLoader;
    });
    Navigator.pop(context);
  }

  void userInsert({String? imgUrl, String? uID})async{
    Map<String, dynamic> useradd = {
      "User-ID": uID,
      "User-Name": userName.text.toString(),
      "User-Email": userEmail.text.toString(),
      "User-Image": imgUrl,
      "User-Age": userAge.text.toString(),
      "User-Gender": userGender.text.toString(),
      "User-Password": userPassword.text.toString(),
    };
    SharedPreferences userCheck = await SharedPreferences.getInstance();
    if (userEmail.text.toString()=="admin@gmail.com") {
      userCheck.setString('userCheck', "admin");
      Navigator.push(context, MaterialPageRoute(builder: (context) => SplashScreen(),));
    }
    else{
      userCheck.setString('userCheck', "user");
      Navigator.push(context, MaterialPageRoute(builder: (context) => SplashScreen(),));
    }
    FirebaseFirestore.instance.collection("userData").doc(uID).set(useradd);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Text("Insert Data"),
                SizedBox(
                  height: 10,
                ),

                GestureDetector(
                  onTap: ()async{
                    XFile? selectedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
                    if (selectedImage!=null) {
                      File convertedFile  = File(selectedImage.path);
                      setState(() {
                        userProfile = convertedFile;
                      });
                    }
                    else{
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No Image Selected")));
                    }
                  },
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.blue,
                    backgroundImage: userProfile!=null?FileImage(userProfile!):null,
                  ),
                ),


                SizedBox(
                  height: 10,
                ),

                TextFormField(
                  controller: userName,
                  decoration: InputDecoration(
                      labelText: "Enter Your Name",
                      suffixIcon: Icon(Icons.email)),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: userEmail,
                  decoration: InputDecoration(
                      labelText: "Enter Your Email", suffixIcon: Icon(Icons.key)),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: userAge,
                  decoration: InputDecoration(
                      labelText: "Enter Your Age", suffixIcon: Icon(Icons.key)),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: userGender,
                  decoration: InputDecoration(
                      labelText: "Enter Your Gender",
                      suffixIcon: Icon(Icons.male)),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: userPassword,
                  decoration: InputDecoration(
                      labelText: "Enter Your Password",
                      suffixIcon: Icon(Icons.key)),
                ),
                SizedBox(
                  height: 10,
                ),
                screenLoader==false?ElevatedButton(
                    onPressed: () {
                      userInertwithImage();
                    },
                    child: Text("Insert")):SizedBox(
                  width: 40,
                  height: 40,
                  child: Center(child: CircularProgressIndicator(),),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
