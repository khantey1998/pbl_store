import 'package:flutter/material.dart';
import 'package:pbl_store/models/manufacturer_model.dart';
import 'package:pbl_store/utils/network_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ManufacturerScreen extends StatefulWidget {

  @override
  ManufacturerState createState() {
    return ManufacturerState();
  }
}

class ManufacturerState extends State<ManufacturerScreen>{
  List<ManufacturerModel> manufacturers;
  String baseUrl = "http://3Q49Q5T8GNBFV7MPR7HG9FT4EP92Q4ZB@pblstore.com/api";
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
        Text("All Brands", style: TextStyle(color: Colors.black),),
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
                  leading: CachedNetworkImage(
                    imageUrl:
                    '$baseUrl/images/manufacturers/${manufacturers[index].id}',
                    placeholder: (context, url) =>
                        Image.asset('assets/p.png'),
                    fit: BoxFit.fitHeight,
                    width: 70,
                  ),
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

