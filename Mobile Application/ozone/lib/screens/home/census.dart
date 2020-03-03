import 'package:flutter/material.dart';
import 'package:ozone/services/auth.dart';
import 'package:ozone/shared/constants.dart';


class Census extends StatefulWidget {
  @override
  _CensusState createState() => _CensusState();
}

class _CensusState extends State<Census> {
  final AuthService _auth= AuthService();
  final _formKey= GlobalKey<FormState>();
  final List<String> regions=['0','1','2','3'];
  bool loading = false;

  //textfield state
  String firstname='';
  String lastname='';
  String email='';
  int _currentage;
  String _currentregion;
  String comfort_status='';
  String error='';
  String success='';
  @override
  Widget build(BuildContext context) {
    return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(8.0),
              child: Column(
              children: <Widget> [
                Text(
                  'Fill out a census',
                  style: TextStyle(fontSize: 15.0),
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Firstname'),
                  validator: (val)=> val.isEmpty ? 'Enter a name' : null,
                  onChanged: (val){
                    setState(()=> firstname=val);
                  },
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Lastname'),
                  validator: (val)=> val.isEmpty ? 'Enter a name' : null,
                  onChanged: (val){
                    setState(()=> lastname=val);
                  },
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  autovalidate: true,
                  validator: (val)=> val.isEmpty ? 'Enter an email' : null,
                  onChanged: (val){
                    setState(()=> email=val);
                  },
                ),
                SizedBox(height: 10.0),
                Text(
                  'Age',
                  style: TextStyle(fontSize: 15.0),
                ),
                Slider(
                  label: '$_currentage',
                  value: (_currentage ?? 18).toDouble(),
                  activeColor: Colors.blueGrey[_currentage ?? 18],
                  inactiveColor: Colors.blueGrey[_currentage ?? 18],
                  min:18.0,
                  max:70.0,
                  divisions: 52,
                  onChanged: (val)=>setState(()=>_currentage=val.round()),

                ),
                SizedBox(height: 2.0),
                Text(
                  'Region',
                  style: TextStyle(fontSize: 15.0),
                ),
                DropdownButtonFormField(
                  decoration: textInputDecoration,
                  value: _currentregion ?? '0',
                  items: regions.map((region){
                    return DropdownMenuItem(
                      value: region,
                      child: Text('$region'),
                    );
                  }).toList(),
                  onChanged: (val)=>setState(()=>_currentregion=val),
                ),

                SizedBox(height: 10.0),
                RaisedButton(
                  color: Colors.cyanAccent[400],
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async{
                    if(_formKey.currentState.validate()){
                      await _auth.fillOutCensus(firstname, lastname, email, _currentage, _currentregion);
                      Navigator.pop(context);
                    }
                  },
                ),
                SizedBox(height: 2.0),
                Text(
                  error,
                  style: TextStyle(color: Colors.red, fontSize: 5.0),
                ),
                SizedBox(height: 2.0),
                Text(
                  success,
                  style: TextStyle(color: Colors.green, fontSize: 5.0),
                )
              ],
            ),
          ),
    );
  }
}

