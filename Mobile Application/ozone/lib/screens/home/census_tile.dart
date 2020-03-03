import 'package:flutter/material.dart';
import 'package:ozone/models/census_model.dart';


class CensusTile extends StatelessWidget {
  final census_model census;
  CensusTile({this.census});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 60.0, 20.0, 0.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.blueGrey[census.age],
          ),
          title: Text(census.firstname),
          subtitle: Text(census.lastname),
        ),
      ),
    );
  }
}
