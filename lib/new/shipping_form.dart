import 'package:flutter/material.dart';
class Shipping extends StatelessWidget{
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    final saveButon = Material(
      elevation: 3.0,
      borderRadius: BorderRadius.circular(5.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {},
        child: Text(
            "Continue".toUpperCase(),
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),

    );
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            "Shipping Method",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              size: 25.0,
              color: Colors.grey,
            ),
            onPressed: () {
            },

          ),

        ),
        body: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Center(
                child: Icon(Icons.local_shipping,size: 100,color: Colors.grey,),
              ),
              Card(
                child: ListTile(
                  title: Text("Free delivery"),
                  subtitle: Text("4 to 8 hour ( Working hour 8am to 19pm )"),
                  leading: Icon(Icons.card_membership,size: 24,),
                ),
              ),
              SizedBox(height: 10,),
              saveButon,

            ],


          ),
        ),
      ),
    );
  }

}
