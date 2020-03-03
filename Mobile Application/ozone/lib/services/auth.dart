import 'package:firebase_auth/firebase_auth.dart';
import 'package:ozone/models/user.dart';
import 'package:ozone/services/database.dart';

class AuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //create user object based on FireabseUser
  User _userFromForebaseUser(FirebaseUser user){
    return user !=null ? User(uid: user.uid) : null;
  }

  //auth change user stream
  Stream<User> get user{
    return _auth.onAuthStateChanged
      .map(_userFromForebaseUser);
  }

  //sign in anonymously
  Future signInAnon() async{
    try{
     AuthResult result =  await _auth.signInAnonymously();
     FirebaseUser user = result.user;
     return _userFromForebaseUser(user);
    } catch(e){
      print(e.toString());
      return null;
    }
  }
  //create a method to sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async{
    try{
      AuthResult result= await _auth.signInWithEmailAndPassword(email: email.trim(), password: password);
      FirebaseUser user=result.user;
      return _userFromForebaseUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  //register with email and password
  Future registerWithEmailAndPassword(String email, String password) async{
    try{
      AuthResult result= await _auth.createUserWithEmailAndPassword(email: email.trim(), password: password);
      FirebaseUser user=result.user;
      return _userFromForebaseUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  //fill out census form
  Future fillOutCensus(String firstname, String lastname,String email, int age, String region) async {
    try{
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      print(user.uid);
      await DatabaseService().updateUserData(firstname, lastname, email, age, region);
    }catch(e){
      print(e.toString());
      return null;
    }
  }
  //sign out
  Future signOut()async{
    try{
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }
}