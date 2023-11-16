import 'package:firebase_imgae/fetch_screen.dart';
import 'package:firebase_imgae/insert_screen.dart';
import 'package:firebase_imgae/reuse_widgets.dart';
import 'package:flutter/material.dart';

class HorizontalScroll extends StatefulWidget {
  const HorizontalScroll({super.key});

  @override
  State<HorizontalScroll> createState() => _HorizontalScrollState();
}

class _HorizontalScrollState extends State<HorizontalScroll> {


  List names = ["Add Data", "Fetch Data"];
  int currentIndex = 0;

  List<Widget> screens= [
    boatWidget(),
    truckWidget()
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 8,vertical: 8),
              child: SizedBox(
                width: double.infinity,
                height: 40,
                child: ListView.builder(
                  itemCount: names.length,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: (){
                      setState(() {
                        currentIndex = index;
                      });
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.bounceIn,
                      width: 80,
                      height: 30,
                      margin: EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        border: currentIndex==index?Border.all(color: Colors.black):Border.all(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(14)
                      ),
                      child: Center(
                        child: Text(names[index]),
                      ),
                    ),
                  );
                },),
              ),
            ),

            SizedBox(height: 40,),

            ListView.builder(
              itemCount: 1,
              shrinkWrap: true,
              itemBuilder: (context, index) {
              return screens[currentIndex];
            },),

            SizedBox(height: 30,),


          ],
        ),
      ),
    );
  }
}


