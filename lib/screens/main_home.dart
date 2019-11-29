import 'package:flutter/material.dart';
import 'package:pbl_store/screens/account_screen.dart';
import 'package:pbl_store/screens/home_screen.dart';
import 'package:pbl_store/screens/shoppingcart_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pbl_store/utils/auth_utils.dart';

class MainHomePage extends StatefulWidget{
  static final String routeName = 'home';
  @override
  _HomePageState createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<MainHomePage>{

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  static SharedPreferences _sharedPreferences;
  static var _authToken, _id, _name, _homeResponse;
  int _currentIndex = 0;

  final List<Widget> _childrenOfNav = [
    HomeScreen(),
    ShoppingCartScreen(),
    AccountScreen()
  ];

  _fetchSessionAndNavigate() async {
    _sharedPreferences = await _prefs;
    String authToken = AuthUtils.getToken(_sharedPreferences);
    var id = _sharedPreferences.getString(AuthUtils.userIdKey);
    var name = _sharedPreferences.getString(AuthUtils.nameKey);

    print("authtoken: $authToken");

//    _fetchProfile(authToken);

    setState(() {
      _authToken = authToken;
      _id = id;
      _name = name;
    });


  }

  void onNavItemsTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchSessionAndNavigate();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        key: _scaffoldKey,
        backgroundColor: Colors.white,

        title:
            Image.asset("assets/logo.jpg", width: 200,),
        actions: <Widget>[
//          IconButton(
//            icon: Icon(Icons.shopping_cart, color: Color(0xff333366),),
//            onPressed: () {
//            },
//          ),
          IconButton(
            icon: Icon(Icons.search, color: Color(0xff333366),),
            onPressed: () {
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _childrenOfNav,
      ),
      bottomNavigationBar: BottomNavigationBar(items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text('Home'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          title: Text('Carts'),
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Account')
        ),
      ],
      currentIndex: _currentIndex,
      onTap: onNavItemsTapped,),
    );
  }
}