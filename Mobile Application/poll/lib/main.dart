import 'package:flutter/material.dart';
import 'package:poll/add_bio.dart';
import 'package:poll/bio.dart';
import 'package:poll/edit_bio.dart';
import 'package:poll/register.dart';
import 'login.dart';

void main() => runApp(PollApp());

class PollApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/bio': (context) => BioPage(),
        '/add_bio': (context) => AddBioPage(),
        '/edit_bio': (context) => EditBioPage()
      },
    );
  }
}

