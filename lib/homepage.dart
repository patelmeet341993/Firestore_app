import 'dart:collection';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appss/myvar.dart';

import 'Msg.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController controller;
  List<Msg> msgs = [];

  late FirebaseFirestore firestore;



  void sendMsg() {
    String msg = controller.text;
    if (msg.trim().isNotEmpty) {
      //msgs.add(msg);

      Map<String, dynamic> data = HashMap();
      data["msg"] = msg;
      data["userId"] = Myvar.myid;
      data["sendtime"] = FieldValue.serverTimestamp();
      firestore.collection("msgs").doc().set(data).then((value) {
        controller.text = "";
        setState(() {});
      });
    }
  }
  
  
  void getMsgs(){
    
    
    firestore.collection("msgs").orderBy("sendtime",descending: false).snapshots(includeMetadataChanges: true).listen((event) {


      List<DocumentSnapshot> data=event.docs;

      msgs.clear();

     // data..forEach((element) { })

      for(int i=0;i<data.length;i++)
        {
          DocumentSnapshot m=data[i];
          Map<dynamic,dynamic> mainMap=m.data() as Map;
          msgs.add(Msg(mainMap));
        }

      setState(() {});

    });
    
    
  }
  
  
  @override
  void initState() {
    super.initState();

    firestore = FirebaseFirestore.instance;
    controller = TextEditingController();
    getMsgs();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            getAppBar(),
            msgList(),
            getBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget msgList() {
    return Expanded(
      child: ListView.builder(
          itemCount: msgs.length,
          itemBuilder: (ctx, index) {
            return msgItem(msgs[index]);
          }),
    );
  }

  Widget msgItem(Msg m) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: m.userId==Myvar.myid?Colors.blue:Colors.deepPurple,
        ),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          crossAxisAlignment:m.userId==Myvar.myid? CrossAxisAlignment.end:CrossAxisAlignment.start,
          children: [
            Text(m.userId+" : "+m.msg,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
          ],
        ));
  }

  Widget getAppBar() {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      color: Colors.grey,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            Myvar.myid!,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          Spacer(),
          Icon(Icons.logout)
        ],
      ),
    );
  }

 

  Widget getBottomBar() {
    return Row(
      children: [
        Expanded(
            child: TextField(
          controller: controller,
        )),
        InkWell(
          onTap: () {
            sendMsg();
          },
          child: Container(
            padding: EdgeInsets.all(15),
            child: Icon(Icons.send),
          ),
        )
      ],
    );
  }
}
