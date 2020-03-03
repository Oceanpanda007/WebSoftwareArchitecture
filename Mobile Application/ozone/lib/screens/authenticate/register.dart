import 'package:flutter/material.dart';
import 'package:ozone/services/auth.dart';
import 'package:ozone/shared/constants.dart';
import 'package:ozone/shared/loading.dart';

class Register extends StatefulWidget {

  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth= AuthService();
  final _formKey= GlobalKey<FormState>();
  bool loading = false;

  //textfield state
  String email='';
  String password='';
  String cpassword='';
  String error='';
  String success='';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[400],
        elevation: 0.0,
        title: Text('Sign Up'),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person,
                color: Colors.cyanAccent),
            label: Text('Log In',
              style: TextStyle(color: Colors.white),),
            onPressed: () {
              widget.toggleView();
              },
          )
        ],
      ),
      body: Container(
          padding:  EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 20.0),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  autovalidate: true,
                  decoration: textInputDecoration.copyWith(hintText: 'Email'),
                  validator: (val)=> val.isEmpty ? 'Enter an email' : null,
                  onChanged: (val){
                    setState(()=> email=val);
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Password'),
                  validator: (val)=> val.length<6 ? 'Enter a password 6+ characters long' : null,
                  obscureText: true,
                  onChanged: (val){
                    setState(()=> password=val);
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Confirm Password'),
                  validator: (val)=> val!=password ? 'Passwords do not match' : null,
                  obscureText: true,
                  onChanged: (val){
                    setState(()=> cpassword=val);
                  },
                ),
                SizedBox(height: 20.0),
                RaisedButton(
                  color: Colors.cyanAccent[400],
                  child: Text(
                    'Register',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async{
                    if(_formKey.currentState.validate()){
                      setState(()=>loading=true);
                      dynamic result= await _auth.registerWithEmailAndPassword(email,password);
                      if(result==null){
                        setState(() {
                          error='Could not sign in with those credentials';
                          loading=false;
                        });
                      }else{
                        setState(() => success='User successfully Created');
                      }
                    }
                  },
                ),
                SizedBox(height: 12.0),
                Text(
                  error,
                  style: TextStyle(color: Colors.red, fontSize: 14.0),
                ),
                SizedBox(height: 12.0),
                Text(
                  success,
                  style: TextStyle(color: Colors.green, fontSize: 14.0),
                )
              ],
            ),
          )
      ),
    );
  }
}
