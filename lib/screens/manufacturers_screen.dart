import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pbl_store/models/manufacturer_model.dart';
import 'package:pbl_store/utils/network_utils.dart';

class ManufacturerScreen extends StatefulWidget {

  @override
  ManufacturerState createState() {
    return ManufacturerState();
  }
}

class ManufacturerState extends State<ManufacturerScreen>{
  List<ManufacturerModel> manufacturers;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
        title:
        Image.asset("assets/logo.jpg", width: 200,),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search, color: Color(0xff333366),),
            onPressed: () {
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: NetworkUtils.getManufacturers(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.hasData){
            manufacturers = snapshot.data;

            return ListView.separated(
              separatorBuilder: (context, index) => Divider(
                color: Colors.grey,
              ),
              padding: EdgeInsets.all(0),
              itemCount: manufacturers.length,
              itemBuilder: (context, index){
                return ListTile(
                  title: Text(manufacturers[index].name),
                );
              },
            );

          }
          else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),

    );
  }
}

