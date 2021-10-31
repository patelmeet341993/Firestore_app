class Msg{

  late String msg;
  late String userId;

  Msg(Map<dynamic,dynamic> data)
  {
    msg=data["msg"];
    userId=data["userId"];
  }

}