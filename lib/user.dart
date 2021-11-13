class User{

  String? uid;
  String image="";
  bool? istyping;


  User({required Map<dynamic,dynamic> data})
  {
    uid=data["uid"];
    istyping=data["istyping"];
    image=data["urls"];
  }

}