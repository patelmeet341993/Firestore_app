import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appss/myvar.dart';
import 'package:flutter_appss/user.dart';

import 'Msg.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController controller;
  List<Msg> msgs = [];
  List<User> users = [];

  bool isTyping = false;
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

  void getMsgs() {
    firestore
        .collection("msgs")
        .orderBy("sendtime", descending: false)
        .snapshots(includeMetadataChanges: true)
        .listen((event) {
      List<DocumentSnapshot> data = event.docs;

      msgs.clear();

      // data..forEach((element) { })

      for (int i = 0; i < data.length; i++) {
        DocumentSnapshot m = data[i];
        Map<dynamic, dynamic> mainMap = m.data() as Map;
        msgs.add(Msg(mainMap));
      }

      setState(() {});
    });
  }

  void getUsers() {
    firestore
        .collection("users")
        .orderBy("updatetime", descending: false)
        .snapshots(includeMetadataChanges: true)
        .listen((event) {
      List<DocumentSnapshot> data = event.docs;

      users.clear();

      // data..forEach((element) { })

      for (int i = 0; i < data.length; i++) {
        DocumentSnapshot m = data[i];
        Map<dynamic, dynamic> mainMap = m.data() as Map;
        users.add(User(data: mainMap));
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
    getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            getAppBar(),
            userSlider(),
            msgList(),
            getBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget userSlider() {
    return Container(
      height: 90,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: users.length,
          itemBuilder: (ctx, index) {
            return userAvtar(users[index]);
          }),
    );
  }

  Widget userAvtar(User user) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipOval(
            child: Image.network(
              user.image,
              height: 60,
              width: 60,
              fit: BoxFit.cover,
            ),
          ),
          Text(
            user.uid!,
            style: TextStyle(color: user.istyping! ? Colors.deepPurple: Colors.black38, fontSize: 20),
          )
        ],
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
          color: m.userId == Myvar.myid ? Colors.blue : Colors.deepPurple,
        ),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          crossAxisAlignment: m.userId == Myvar.myid
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              m.userId + " : " + m.msg,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
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
          onChanged: (val) {
            if (val.isEmpty) {
              isTyping = false;
            } else {
              isTyping = true;
            }

            Map<String,Object> updateData=HashMap();
            updateData["istyping"]=isTyping;
            updateData["updatetime"]=FieldValue.serverTimestamp();
            firestore.collection("users").doc(Myvar.myid).update(updateData);


          },
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
