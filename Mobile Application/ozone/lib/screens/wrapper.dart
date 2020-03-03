import 'package:flutter/material.dart';
import 'package:ozone/screens/authenticate/authenticate.dart';
import 'package:ozone/screens/home/home.dart';
import 'package:provider/provider.dart';
import 'package:ozone/models/user.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user= Provider.of<User>(context);

    //Return either home or Authenticate widget
    if(user == null){
      return Authenticate();
    }else{
      return Home();
    }
  }
}
