import 'package:flutter/material.dart';
import 'package:flutter_appss/homepage.dart';
import 'package:flutter_appss/myvar.dart';
import 'package:shared_preferences/shared_preferences.dart';
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {


 late TextEditingController controller;

 late SharedPreferences sharedPreferences;


 void checkLogin()async
 {
   sharedPreferences=await SharedPreferences.getInstance();
   String? id=sharedPreferences.getString("id");

   if(id!=null)
     {

       Myvar.myid=id;
       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));

     }


 }



  @override
  void initState() {
    super.initState();

    controller=TextEditingController();
    checkLogin();



  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller,
                ),
                SizedBox(height: 10,),
                InkWell(
                  onTap: ()async{

                    String id=controller.text;

                    if(id.trim().isNotEmpty)
                      {
                        await sharedPreferences.setString("id", id);
                        Myvar.myid=id;
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));


                      }

                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    color: Colors.grey,

                    child: Text("Log in"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
