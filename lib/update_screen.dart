import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class UpdateScreen extends StatefulWidget {
  String uID;
  String uName;
  String uEmail;
  String uImage;
  String uAge;
  String uPassword;

  UpdateScreen(
      {required this.uID,
      required this.uName,
      required this.uEmail,
      required this.uImage,
      required this.uAge,
      required this.uPassword});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  TextEditingController userName = TextEditingController();
  TextEditingController userEmail = TextEditingController();
  TextEditingController userAge = TextEditingController();
  TextEditingController userPassword = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState

    userName.text = widget.uName;
    userEmail.text = widget.uEmail;
    userAge.text = widget.uAge;
    userPassword.text = widget.uPassword;
    super.initState();
  }

  File? userProfile;

  void userUpdatewithImage() async {
    FirebaseStorage.instance.refFromURL(widget.uImage).delete();
    UploadTask uploadTask = FirebaseStorage.instance
        .ref()
        .child("User-Images")
        .child(Uuid().v1())
        .putFile(userProfile!);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    userUpdate(imgUrl: downloadUrl);
    Navigator.pop(context);
  }

  void userUpdate({String? imgUrl}) async {
    await FirebaseFirestore.instance
        .collection("userData")
        .doc(widget.uID)
        .update({
      "User-ID": widget.uID,
      "User-Name": userName.text.toString(),
      "User-Email": userEmail.text.toString(),
      "User-Image": imgUrl,
      "User-Age": userAge.text.toString(),
      "User-Password": userPassword.text.toString(),
    });
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
                Text("Update Data"),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () async {
                    XFile? selectedImage = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
                    if (selectedImage != null) {
                      File convertedFile = File(selectedImage.path);
                      setState(() {
                        userProfile = convertedFile;
                      });
                    }
                  },
                  child: userProfile == null
                      ? CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.blue,
                          backgroundImage: NetworkImage(widget.uImage),
                        )
                      : CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.blue,
                          backgroundImage: userProfile != null
                              ? FileImage(userProfile!)
                              : null,
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
                      labelText: "Enter Your Email",
                      suffixIcon: Icon(Icons.key)),
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
                  controller: userPassword,
                  decoration: InputDecoration(
                      labelText: "Enter Your Password",
                      suffixIcon: Icon(Icons.key)),
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      userUpdatewithImage();
                    },
                    child: Text("UPdate"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
