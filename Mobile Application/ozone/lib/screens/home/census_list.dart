
import 'package:flutter/material.dart';
import 'package:ozone/models/census_model.dart';
import 'package:provider/provider.dart';
import 'package:ozone/screens/home/census_tile.dart';

class CensusList extends StatefulWidget {
  @override
  _CensusListState createState() => _CensusListState();
}

class _CensusListState extends State<CensusList> {
  @override
  Widget build(BuildContext context) {
    final census= Provider.of<List<census_model>>(context);

    return ListView.builder(
      itemCount: census.length,
      itemBuilder: (context,index){
        return CensusTile(census: census[index]);
      },
    );
  }
}
