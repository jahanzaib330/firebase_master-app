import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  TextEditingController userSearch = TextEditingController();
    String userValue = '';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Screen"),
      ),

      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 150,
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Container(
                      width: 200,
                      child: TextFormField(
                        controller: userSearch,
                        decoration: InputDecoration(
                           hintText: "Search"
                        ),
                      ),
                    ),
                    IconButton(onPressed: (){
                      setState(() {
                        userValue = userSearch.text.toString();
                        print(userValue);
                      });
                    }, icon: Icon(Icons.search))
                  ],
                ),
              ),

              SizedBox(height: 20,),

              StreamBuilder(
                  stream: userValue==''?FirebaseFirestore.instance.collection("userData").snapshots():FirebaseFirestore.instance.collection("userData").where('User-Name',isEqualTo: userValue).snapshots(),
                  builder: (BuildContext context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasData) {
                      var dataLength = snapshot.data!.docs.length;
                      return dataLength==0?Text("Nothing to Show"):ListView.builder(
                        itemCount: dataLength,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          String ourUser = snapshot.data!.docs[index]['User-Name'];
                          return Text(ourUser);
                        },);
                    }if (snapshot.hasError) {
                      return Icon(Icons.error_outline);
                    }
                    return Container();
                  })
            ],
          ),
        ),
      ),
    );
  }
}
