import 'package:flutter/material.dart';
class Data extends StatefulWidget {
  @override
  _DataState createState() => _DataState();
}
class _DataState extends State<Data>{
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 18.0);
  bool check1Val = true;
  bool check2Val = true;
  bool check3Val = true;
  @override
  Widget build(BuildContext context) {
    final fName = TextField(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        labelText: "First Name",
      ),
    );
    final lName = TextField(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        labelText: "Last Name",
      ),
    );
    final email = TextField(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        labelText: "Email",
      ),
    );
    final saveButon = Material(
      elevation: 3.0,
      borderRadius: BorderRadius.circular(5.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {},
        child: Text(
            "save".toUpperCase(),
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),

    );
    final passwordField = TextField(
      obscureText: true,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
    );
    final npasswordField = TextField(
      obscureText: true,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "optional",
          labelText: "New Password",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
    );
    final dofbirth = TextField(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        labelText: "Date of Birth",
        hintText: "optional",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))
      ),
    );
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            "Your Personal Information",
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
        body: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Radio(
                        value: check3Val,
                        onChanged: (bool value) {
                          setState(() {
                            check3Val = value;
                          });
                        },
                      ),
                      SizedBox(
                        child: Text("Mrs"),
                        width: 300,
                      )
                    ],

                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Radio(
                        value: check3Val,
                        onChanged: (bool value) {
                          setState(() {
                            check3Val = value;
                          });
                        },
                      ),
                      SizedBox(
                        child: Text("Mr"),
                        width: 300,
                      )
                    ],

                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: fName
                      ),
                      SizedBox(width: 20),
                      Expanded(
                          child: lName
                      ),
                    ],
                  ),
                  email,
                  SizedBox(height: 20,),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: passwordField,
                      ),
                      SizedBox(width: 20),
                      Expanded(
                          child: npasswordField
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  dofbirth,
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: <Widget>[
                      Text("(E.g.: 05/31/1970)"),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Checkbox(
                        value: check1Val,
                        onChanged: (bool value) {
                          setState(() {
                            check1Val = value;
                          });
                        },
                      ),
                      Text("Receive offers from our partners"),
                    ],

                  ),
                  Row(
                    children: <Widget>[
                      Checkbox(
                        value: check2Val,
                        onChanged: (bool value) {
                          setState(() {
                            check2Val = value;
                          });
                        },
                      ),
                      SizedBox(
                        child: Text("Sign up for our newsletter You may unsubscribe at any moment. For that purpose, please find our contact info in the legal notice."),
                        width: 300,
                      )
                    ],

                  ),
                  SizedBox(height: 20,),
                  saveButon,



                ],



              ),


            ),
          ],
        )
      ),
    );
  }

}
