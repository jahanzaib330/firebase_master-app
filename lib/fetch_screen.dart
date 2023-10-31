import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_imgae/update_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'insert_screen.dart';

class FetchScreen extends StatefulWidget {
  const FetchScreen({super.key});

  @override
  State<FetchScreen> createState() => _FetchScreenState();
}

class _FetchScreenState extends State<FetchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: 20,),

              StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("userData").snapshots(),
                  builder: (context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasData) {

                      var dataLength = snapshot.data!.docs.length;

                      return dataLength==0?Center(
                        child: Text("Nothing to Show"),
                      ):ListView.builder(
                        itemCount: dataLength,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {

                          String userID = snapshot.data!.docs[index].id;
                          String userName = snapshot.data!.docs[index]['User-Name'];
                          String userImage = snapshot.data!.docs[index]['User-Image'];
                          String userEmail = snapshot.data!.docs[index]['User-Email'];
                          String userage = snapshot.data!.docs[index]['User-Age'];
                          String userPassword = snapshot.data!.docs[index]['User-Password'];

                          return GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateScreen(uID: userID, uName: userName, uEmail: userEmail,uImage: userImage, uAge: userage, uPassword: userPassword),));
                            },
                            onDoubleTap: ()async{
                              showDialog<void>(
                                context: context,
                                // false = user must tap button, true = tap outside dialog
                                builder: (BuildContext dialogContext) {
                                  return AlertDialog(
                                    title: Text('Delete User'),
                                    content: Text('Are you sure you want to delete $userName'),
                                    actions: <Widget>[
                                      TextButton(onPressed: (){
                                        Navigator.of(dialogContext)
                                            .pop();
                                      }, child: Text("Cancel")),
                                      ElevatedButton(
                                          child: Text('Delete',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400),),
                                          onPressed: () async{
                                            await FirebaseFirestore.instance.collection("userData").doc(userID).delete();
                                            await FirebaseStorage.instance.refFromURL(userImage).delete();
                                            Navigator.of(dialogContext)
                                                .pop(); // Dismiss alert dialog
                                          },
                                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade600)
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              height: 80,
                              margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Container(
                                margin: EdgeInsets.only(left: 14,top: 8),
                                child: Row(
                                  children: [

                                    CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.blue,
                                      backgroundImage: userImage!=null?NetworkImage(userImage):null,
                                    ),

                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("$userName",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18),),
                                        Text("$userEmail",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14),),
                                        Text("$userPassword",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14),)
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },);
                    }
                    if (snapshot.hasError) {
                      return Icon(Icons.error_outline);
                    }
                    return Container();
                  })  ,

              SizedBox(height: 20,),

              Center(
                child: ElevatedButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => InsertScreen(),));
                }, child: Text("Add Data")),
              )
            ],
          ),
        ),
      ),
    );
  }
}
