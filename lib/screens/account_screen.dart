//import 'package:flutter/material.dart';
//import 'package:xml/xml.dart' as xml;
//import 'dart:io';
//import 'package:dio/dio.dart';
//
//class AccountScreen extends StatefulWidget{
//  @override
//  _AccountScreenState createState() {
//    // TODO: implement createState
//    return _AccountScreenState();
//  }
//}
//
//class _AccountScreenState extends State<AccountScreen> {
//  var dio = Dio(Options(
//    baseUrl: "http://3Q49Q5T8GNBFV7MPR7HG9FT4EP92Q4ZB@store.pblcnt.com/api",
//    connectTimeout: 5000,
//    receiveTimeout: 100000,
//    // 5s
//    headers: {
//      HttpHeaders.userAgentHeader: "dio",
//      "api": "1.0.0",
//      //"Authorization":"Basic 3Q49Q5T8GNBFV7MPR7HG9FT4EP92Q4ZB",
//    },
//    contentType: ContentType.json,
//    // Transform the response data to a String encoded with UTF8.
//    // The default value is [ResponseType.JSON].
//    responseType: ResponseType.PLAIN,
//  ));
//  Response response;
//  String result;
//  Future<Response> get()async{
//
//    try {
//      response = await dio.get("/customers");
//      print(response.data);
//      print(response.toString());
//    } catch (e) {
//      print(e);
//    }
//    return response.data;
//  }
//  @override
//  void initState() {
//    result = get().toString();
//    super.initState();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//
//
//    return Scaffold(
//      body: Text(result),
//    );
//  }
//}

import 'package:flutter/material.dart';
import 'package:pbl_store/utils/network_utils.dart';
import 'package:pbl_store/utils/auth_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pbl_store/models/shopping_cart.dart';
import 'package:pbl_store/bloc/BlocProvider.dart';
import 'package:pbl_store/bloc/GlobalBloc.dart';
import 'package:pbl_store/screens/login.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  ShoppingCart cart;
  SharedPreferences _sharedPreferences;

  var _authToken, _id, _name, _homeResponse;



  @override
  void initState() {

    super.initState();
    _fetchSessionAndNavigate();
  }
  _fetchSessionAndNavigate() async {
    _sharedPreferences = await _prefs;
    String authToken = AuthUtils.getToken(_sharedPreferences);
    var id = _sharedPreferences.getString(AuthUtils.userIdKey);
    var name = _sharedPreferences.getString(AuthUtils.nameKey);

    setState(() {
      _authToken = authToken;
      _id = id;
      _name = name;
    });

    if(_authToken == null) {
      _logout();
    }
  }
  _logout() {
    NetworkUtils.logoutUser(_scaffoldKey.currentContext, _sharedPreferences);
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        key: _scaffoldKey,
        body: ListView(
          padding: const EdgeInsets.all(8),
          scrollDirection: Axis.vertical,
          children: <Widget>[
            Card(
              elevation: 3,
              margin: const EdgeInsets.all(5.0),
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(100 / 2),
              ) +
                  Border.all(color: Colors.white),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.favorite_border,
                          color: Colors.black,
                        ),
                        Text("Wish List"),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.star_border,
                          color: Colors.black,
                        ),
                        Text("Following")
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Card(
              borderOnForeground: true,
              margin: const EdgeInsets.all(0.5),
              child: ListTile(
                leading: Icon(Icons.playlist_play),
                title: Text('My Order'),
                trailing: Text("View All"),
              ),
            ),
            Card(
              margin: const EdgeInsets.all(0.5),
              borderOnForeground: true,
              child: ListTile(
                title: Text('Unpaid'),
              ),
            ),
            Card(
              margin: const EdgeInsets.all(0.5),
              borderOnForeground: true,
              child: ListTile(
                title: Text('To Be Shipped'),
              ),
            ),
            Card(
              margin: const EdgeInsets.all(0.5),
              borderOnForeground: true,
              child: ListTile(
                title: Text('Shipped'),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Card(
              elevation: 5,
              margin: const EdgeInsets.all(0.8),
              borderOnForeground: true,
              child: ListTile(
                leading: Icon(Icons.settings),
                title: Text('Setting'),
                trailing: Icon(Icons.flag),
              ),
            ),
            Card(
              margin: const EdgeInsets.all(0.0),
              borderOnForeground: true,
              child: ListTile(
                leading: Icon(Icons.help_outline),
                title: Text('Help Center'),
              ),
            ),

            Card(
              margin: const EdgeInsets.all(0.0),
              borderOnForeground: true,
              child: ListTile(
                onTap: (){
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            "Log Out?",
                            style: TextStyle(fontSize: 16),
                          ),
                          content: Text("Are you sure you want to log out?"),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()),
                                );
                              },
                              child: Text("Cancel"),
                            ),
                            FlatButton(
                              onPressed: _logout,
                              child: Text("Log Out"),
                            ),
                          ],
                        );
                      });
                },
                leading: Icon(Icons.exit_to_app),
                title: Text('Log Out'),
              ),
            ),

          ],
        ));
  }
}

