import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FirstPage(),
    );
  }
}

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {

 late FirebaseFirestore firestore;

  @override
  void initState() {
    super.initState();
    firestore=FirebaseFirestore.instance;

  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(body:
    Center(
      child: InkWell(
        onTap: (){



          Map<String,dynamic> stuData=HashMap();

          stuData["name"]="Yash";
          stuData["age"]=21;
          stuData["clg"]="BIT";


          Map<String,dynamic> eduData=HashMap();
          eduData["10th"]=82;
          eduData["12th"]=76;
          eduData["Clg"]=80;


          stuData["result"]=eduData;



          firestore.collection("student").doc().set(stuData).whenComplete(() {
            print("Saved : $stuData");
          });
        },
        child: Container(
          padding: EdgeInsets.all(15),
          color: Colors.grey,
          child: Text("Save"),
        ),
      ),
    ),));
  }
}

