//import 'package:advanced_flutter_example/DefaultAppBar.dart';
import 'package:pbl_store/bloc/BlocProvider.dart';
import 'package:pbl_store/screens/main_home.dart';
import 'package:pbl_store/bloc/GlobalBloc.dart';
import 'package:pbl_store/models/product_model.dart';
import 'package:pbl_store/models/shopping_cart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:pbl_store/screens/main_home.dart';
import 'package:pbl_store/utils/auth_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pbl_store/utils/network_utils.dart';
import 'package:pbl_store/screens/address_screen.dart';
import 'dart:async';


class ShoppingCartScreen extends StatefulWidget {
  ShoppingCartScreen();

  @override
  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCartScreen> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String baseUrl = "http://3Q49Q5T8GNBFV7MPR7HG9FT4EP92Q4ZB@pblstore.com/api";
  SharedPreferences _sharedPreferences;
  var _authToken, _id, _name, _homeResponse;
  bool _isLoading = false;
  ShoppingCart cart;
  static TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 16.0);
  final loginButton = Material(
    elevation: 1.0,
    borderRadius: BorderRadius.circular(5.0),
    color: Color(0xff01A0C7),
    child: MaterialButton(
//        minWidth: MediaQuery.of(context).size.width,
      padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
      onPressed: () {},
      child: Text(
        "Sign In",
        textAlign: TextAlign.center,
        style: style.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    ),
  );

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

  @override
  void initState() {
    super.initState();
    _fetchSessionAndNavigate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream:
              BlocProvider.of<GlobalBloc>(context).shoppingCartBloc.cartStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return ListView(
                padding: const EdgeInsets.all(32),
                scrollDirection: Axis.vertical,
                children: <Widget>[
                  Container(
                    child: Icon(
                      Icons.shopping_cart,
                      size: 100,
                      color: Colors.black12,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text("There currently are no items in your shopping cart."),
                  SizedBox(
                    height: 20.0,
                  ),
                  _authToken == null
                      ? Container(
                          child: loginButton,
                        )
                      : RaisedButton(
                          child: Text("Go Shopping"),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MainHomePage()),
                            );
                          },
                        ),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              );
            } else {
              cart = snapshot.data;
              if (cart.products.length == 0) {
                return ListView(
                  padding: const EdgeInsets.all(32),
                  scrollDirection: Axis.vertical,
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.shopping_cart,
                        size: 100,
                        color: Colors.black12,
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                        "There currently are no items in your shopping cart. "),
                    SizedBox(
                      height: 20.0,
                    ),
                    _authToken == null
                        ? Container(
                            child: loginButton,
                          )
                        : RaisedButton(
                            child: Text("Go Shopping"),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MainHomePage()),
                              );
                            },
                          ),
                    SizedBox(
                      height: 20.0,
                    ),
                  ],
                );
              }
              return Container(
                padding: EdgeInsets.all(4),
                child: Column(children: [
                  Card(
                    child: ListTile(
                      leading: Text("Total Price",
                          style: Theme.of(context).textTheme.subhead),
                      trailing: Text(cart.totalPrice.toString() + "\$",
                          style: Theme.of(context).textTheme.headline),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: ListView(

                      children: <Widget>[
                        Card(
                          child: ExpansionTile(
                              title: Text("Products (" +
                                  cart.products.length.toString() +
                                  ")"),
                              children: getProductTiles()),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Card(
                      child: Column(
                        children: <Widget>[
//                          Container(
//                            child: ListTile(
//                              title: Text(
//                                "Secured Information Signing Up",
//                              ),
//                              leading: Icon(Icons.check_box),
//                            ),
//                          ),
                          Container(
                            child: ListTile(
                              title: Text(
                                " Free Delivery for Phnom Penh",
                              ),
                              leading: Icon(Icons.directions_car),
                            ),
                          ),
                          Container(
                            child: ListTile(
                              title: Text(
                                " 30-day Payback Warranty",
                              ),
                              leading: Icon(Icons.compare_arrows),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                   SizedBox(
                      width: double.infinity,
                      child: RaisedButton(
                        color: Colors.blueGrey,
                        child: Text("Order now!", style: TextStyle(color: Colors.white70),),
                        onPressed: () async{

                          var responseJson = await NetworkUtils.checkAddress(_id);

                          if(responseJson == null) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context){
                                return AlertDialog(
                                  content: Text("Address haven't added yet. Do you want to add your address now?"),
                                  actions: <Widget>[
                                    FlatButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("No"),
                                    ),
                                    FlatButton(
                                      onPressed: (){
                                        Navigator.of(context).pop();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Address()),
                                        );
                                      },
                                      child: Text("Yes"),
                                    ),
                                  ],
                                );
                              }
                            );

                          }
                          else{

                            showDialog(
                                context: context,
                                builder: (BuildContext context){
                                  return AlertDialog(
                                    content: Text("Order Complete !"),
                                    actions: <Widget>[
                                      FlatButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => MainHomePage()),
                                          );
                                        },
                                        child: Text("OKAY"),
                                      ),

                                    ],
                                  );
                                }
                            );

                          }


//                          BlocProvider.of<GlobalBloc>(context)
//                              .shoppingCartBloc
//                              .clearCart();
//                          Scaffold.of(context).showSnackBar(
//                              SnackBar(content: Text("Order completed!")));
//                          Navigator.push(
//                            context,
//                            MaterialPageRoute(
//                                builder: (context) => MainHomePage()),
//                          );
                        },
                      ),
                    ),
                ]),
              );
            }
          }),
    );
  }
  _showLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  _hideLoading() {
    setState(() {
      _isLoading = false;
    });
  }
  Widget _loadingScreen() {
    return new Container(
        margin: const EdgeInsets.only(top: 100.0),
        child: new Center(
            child: new Column(
              children: <Widget>[
                new CircularProgressIndicator(
                    strokeWidth: 4.0
                ),
                new Container(
                  padding: const EdgeInsets.all(8.0),
                  child: new Text(
                    'Please Wait',
                    style: new TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 16.0
                    ),
                  ),
                )
              ],
            )
        )
    );
  }
  List<Widget> getProductTiles() {
    List<Widget> list = [];
    if (cart != null) {
      for (ProductModel p in cart.products) {
        String name = p.name;
        String price = p.price.toString();
        int amount = p.amount;
        list.add(
          Card(
            borderOnForeground: true,
            margin: const EdgeInsets.all(0.5),
            elevation: 1.0,
            shape: Border(left: BorderSide(color: Colors.blue, width: 4)),
//              color: Colors.white70,
            child: Row(
              children: <Widget>[
//                Radio(
//                  value: 1,
//                  groupValue: '',
//                ),
                CachedNetworkImage(
                  imageUrl:
                  '$baseUrl/images/products/${p.id.toString()}/${p.idDefaultImage}',
                  placeholder: (context, url) =>
                      Image.asset('assets/product.jpg'),
                  fit: BoxFit.fitHeight,
                  width: 100,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        elevation: 0.0,
                        borderOnForeground: false,
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: ListTile(
                          title: Text(
                            name,
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Text(
                                "US \$${double.parse(price)}",
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 8.0,
                              ),
//                            Text(
//                              "US \$33",
//                              style: TextStyle(
//                                fontSize: 12.0,
//                                color: Colors.grey,
//                                decoration: TextDecoration.lineThrough,
//                              ),
//                            ),
//                            SizedBox(
//                              width: 8.0,
//                            ),
//                            Text(
//                              "30% Off",
//                              style: TextStyle(
//                                fontSize: 12.0,
//                                color: Colors.red,
//                              ),
//                            ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  "Free Shipping",
                                  style: TextStyle(color: Colors.blue),
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(5.0),
                            child: Row(
                              children: <Widget>[
                                new FloatingActionButton(
                                  onPressed: () {},
                                  mini: true,
                                  heroTag: "${p.price}",
                                  child: new Icon(
                                      const IconData(0xe15b,
                                          fontFamily: 'MaterialIcons'),
                                      color: Colors.black),
                                  backgroundColor: Colors.white70,

                                ),
                                Text("$amount",
                                    style: new TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.blueAccent)),
                                FloatingActionButton(
                                  heroTag: "${p.id}",
                                  onPressed: () {},
                                  child: new Icon(
                                    Icons.add,
                                    color: Colors.black,
                                  ),
                                  mini: true,
                                  backgroundColor: Colors.white70,
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }
    return list;
  }
}
