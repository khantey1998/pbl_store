import 'package:flutter/material.dart';
import 'package:pbl_store/utils/network_utils.dart';
import 'package:pbl_store/utils/auth_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pbl_store/models/shopping_cart.dart';
import 'package:pbl_store/screens/login.dart';
import 'package:pbl_store/screens/order_list.dart';
import 'package:pbl_store/screens/personal_data.dart';
import 'package:pbl_store/screens/address_list.dart';
import 'package:pbl_store/screens/contact_us_screen.dart';
import 'package:pbl_store/screens/about_screen.dart';
import 'package:pbl_store/screens/help_center.dart';
import 'package:pbl_store/screens/content_mangement_screen.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  ShoppingCart cart;
  SharedPreferences _sharedPreferences;

  var _authToken, _id, _name;

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

    if (_authToken == null) {
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
      body: Container(
        color: Color(0xfc0c0c0),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 30, top: 20, bottom: 20),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      "$_name ",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    flex: 2,
                  ),
                  Expanded(
                    flex: 1,
                    child: CircleAvatar(
                      backgroundColor: Colors.deepOrangeAccent,
                      radius: 30,
                      child: Text(
                        "$_name".substring(0, 2).toUpperCase(),
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
            GestureDetector(
              child: Card(
                margin: const EdgeInsets.all(0.5),
                child: ListTile(
                  leading: Icon(Icons.playlist_play),
                  title: Text('My Order'),
                  trailing: Text("View All"),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListOrder(),
                  ),
                );
              },
            ),
            SizedBox(
              height: 15.0,
            ),
            Card(
              margin: const EdgeInsets.all(0.0),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ContentManagementScreen(),
                    ),
                  );
                },
                leading: Icon(Icons.settings),
                title: Text('Setting'),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            ),
            Card(
              margin: const EdgeInsets.all(0.0),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Data(
                        id: _id,
                      ),
                    ),
                  );
                },
                leading: Icon(Icons.person),
                title: Text('Personal Information'),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            ),
            Card(
              margin: const EdgeInsets.all(0.0),
              child: ListTile(
                leading: Icon(Icons.pin_drop),
                title: Text('Addresses'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddressList(),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            Card(
              margin: const EdgeInsets.all(0.0),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HelpCenter(),
                    ),
                  );
                },
                leading: Icon(Icons.headset_mic),
                title: Text('Help Center'),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            ),
            Card(
              margin: const EdgeInsets.all(0.0),
              child: ListTile(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => AboutUs()),
                  );
                },
                leading: Icon(Icons.wb_incandescent),
                title: Text('About Us'),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            ),
            Card(
              margin: const EdgeInsets.all(0.0),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ContactUs(
                        userId: _id,
                      ),
                    ),
                  );
                },
                leading: Icon(Icons.contact_phone),
                title: Text('Contact Us'),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            ),
            Container(
              height: 65,
              padding: EdgeInsets.only(top: 15, left: 25, right: 25),
              child: RaisedButton(
                color: Colors.red,
                child: Text(
                  "Sign Out",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
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
                                    builder: (context) => LoginPage(),
                                  ),
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
              ),
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
