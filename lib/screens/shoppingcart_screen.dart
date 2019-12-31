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
import 'package:pbl_store/models/order_model.dart';
import 'package:pbl_store/models/order_row.dart';
import 'package:pbl_store/models/association_model.dart';
import 'package:pbl_store/models/address_model.dart';
import 'package:pbl_store/screens/order_screen.dart';
import 'dart:convert';

class ShoppingCartScreen extends StatefulWidget {
  ShoppingCartScreen();

  @override
  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCartScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String baseUrl = "http://3Q49Q5T8GNBFV7MPR7HG9FT4EP92Q4ZB@pblstore.com/api";
  SharedPreferences _sharedPreferences;
  List<OrderRow> orderRowList;
  var _authToken, _id, _name, _homeResponse;
  bool _isLoading = false;
  ShoppingCart cart;
  Stream<ShoppingCart> streamCart;
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
  }

  @override
  void initState() {
    super.initState();
    _fetchSessionAndNavigate();
    streamCart = BlocProvider.of<GlobalBloc>(context).shoppingCartBloc.cartStream;
    orderRowList = List();
  }

  @override
  Widget build(BuildContext context) {

    void _onLoading() {
      if(_isLoading){
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Dialog(
              child: Container(
                width: double.infinity,
                height: 200,
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    new CircularProgressIndicator(),
                    new Text("Loading"),
                  ],
                ),
              ),
            );
          },
        );
      }
    }
    return Scaffold(
      key: _scaffoldKey,
      body: StreamBuilder(
          stream:
              streamCart,
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
                width: double.infinity,
                height: double.infinity,
                child: Stack(
                  children: <Widget>[
                    SingleChildScrollView(
                      padding: EdgeInsets.all(4),
                      child: Column(children: [
                        Card(
                          child: ListTile(
                            leading: Text("All Products",
                                style: Theme.of(context).textTheme.subhead),
                            trailing: Text("${cart.products.length}",
                                style: Theme.of(context).textTheme.headline),
                          ),
                        ),
                        Card(
                          child: Column(
                            children: getProductTiles(),
                            mainAxisSize: MainAxisSize.min,
                          ),
                        ),
                        Card(
                          child: ListTile(
                            leading: Text("Total Price",
                                style: Theme.of(context).textTheme.subhead),
                            trailing: Text(cart.totalPrice.toString() + "\$",
                                style: Theme.of(context).textTheme.headline),
                          ),
                        ),
                        FutureBuilder(
                          future: getAddress(_id),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              List<AddressModel> address = snapshot.data;
                              return Card(
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(8, 16, 8, 16),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          "Shipping Address: ",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          "${address[0].address1}, ${address[0].city}, ${address[0].postalCode}, ${address[0].phone}",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: GestureDetector(
                                          child: Icon(Icons.edit),
                                          onTap: () {},
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return Card(
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(8, 16, 8, 16),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          "Shipping Address: ",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: GestureDetector(
                                          child: Text(
                                            "Add new address",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Address(),),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                        Card(
                          child: Column(
                            children: <Widget>[
                              Container(
                                child: ListTile(
                                  title: Text(
                                    "Cash on Delivery",
                                  ),
                                  leading: Icon(Icons.check_box),
                                ),
                              ),
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
                                    "30-day Payback Warranty",
                                  ),
                                  leading: Icon(Icons.compare_arrows),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 60,
                        ),
                      ]),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 4,
                      right: 4,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: ButtonTheme(
                          minWidth: double.infinity,
                          height: 50,
                          child: FlatButton(
                            color: Colors.blueGrey,
                            onPressed: () async {
                              List<AddressModel> responseJson =
                                  await NetworkUtils.getAddress(_id);
                              if (responseJson == null) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: Text(
                                            "Address haven't added yet. Do you want to add your address now?"),
                                        actions: <Widget>[
                                          FlatButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("No"),
                                          ),
                                          FlatButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Address(),),
                                              );
                                            },
                                            child: Text("Yes"),
                                          ),
                                        ],
                                      );
                                    });
                              } else if (responseJson.length > 0) {
                                AddressModel address = responseJson[0];
                                AssociationModel association =
                                    AssociationModel(orderRows: orderRowList);
                                OrderModel newOrder = OrderModel(
                                  idCart: _sharedPreferences
                                      .getString(AuthUtils.cartIDKey),
                                  idCustomer: _id,
                                  idShop: "1",
                                  idAddressDelivery: address.id,
                                  idShopGroup: "1",
                                  idCurrency: "2",
                                  idAddressInvoice: address.id,
                                  idCarrier: "3",
                                  idLang: "1",
                                  totalPaidReal: cart.totalPrice.toString(),
                                  totalPaid: cart.totalPrice.toString(),
                                  totalPaidTaxExcl: cart.totalPrice.toString(),
                                  totalPaidTaxIncl: cart.totalPrice.toString(),
                                  totalProducts: cart.totalPrice.toString(),
                                  totalProductWt: cart.totalPrice.toString(),
                                  roundType: "2",
                                  roundMode: "2",
                                  payment: "Cash on delivery (COD)",
                                  module: "ps_cashondelivery",
                                  association: association,
                                  conversionRate: "1",
                                  currentState: "3",
                                  secureKey: _authToken,
                                  valid: "1",
                                );
                                var orderBody = {};
                                orderBody["order"] = newOrder.orderMap();
                                String strOrder = json.encode(orderBody);
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: Text("Make order?"),
                                        actions: <Widget>[
                                          FlatButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text("Cancel"),
                                          ),
                                          FlatButton(
                                            onPressed: () async {
                                              _showLoading();
                                              _onLoading();
                                              var result = await NetworkUtils.createOrder(body: strOrder);
                                              if(result == "NetworkError"){
                                                NetworkUtils.showSnackBar(_scaffoldKey, "Network Error");
                                              }
                                              else{
                                                _hideLoading();
                                                Navigator.pop(context);
                                                BlocProvider.of<GlobalBloc>(context).shoppingCartBloc.clearCart();
                                                ShoppingCart newCart = ShoppingCart(
                                                    secureKey: _sharedPreferences.getString(AuthUtils.authTokenKey),
                                                    idCurrency: "2",
                                                    idCustomer: _sharedPreferences.getString(AuthUtils.userIdKey),
                                                    idLanguage: "1",
                                                    idShop: "1",
                                                    idShopGroup: "1",
                                                    idAddressDelivery: address.id,
                                                    idAddressInvoice: address.id,
                                                    idCarrier: "3");
                                                var cartBody = {};
                                                cartBody["carts"] = newCart.toMap();
                                                String strCart = json.encode(cartBody);
                                                ShoppingCart k = await NetworkUtils.createCart(body: strCart);
                                                _sharedPreferences.setString(AuthUtils.cartIDKey, k.id);
                                                List<OrderModel> orderList = await NetworkUtils.getLatestOrder();
                                                OrderModel latestOrder = orderList[0];
                                                OrderModel updateOder = newOrder;
                                                updateOder.reference = latestOrder.reference;
                                                updateOder.deliveryDate = latestOrder.deliveryDate;
                                                updateOder.invoiceDate = latestOrder.invoiceDate;
                                                updateOder.id = latestOrder.id;
                                                updateOder.deliveryNumber = latestOrder.deliveryNumber;
                                                updateOder.invoiceNumber = latestOrder.invoiceNumber;
                                                var updateOrderBody = {};
                                                updateOrderBody["order"] = updateOder.updateOrderMap();
                                                String updateStrOrder = json.encode(updateOrderBody);
                                                await NetworkUtils.updateOrder(body: updateStrOrder);
                                                Navigator.pop(context);
                                                setState(() {
                                                  streamCart = BlocProvider.of<GlobalBloc>(context).shoppingCartBloc.cartStream;

                                                });
                                              }
                                            },
                                            child: Text("Yes !"),
                                          ),
                                        ],
                                      );
                                    });
                              }
                            },
                            child: Text(
                              'Order',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }
  getAddress(String id) async {
    return await NetworkUtils.getAddress(id);
  }
  List<Widget> getProductTiles() {
    List<Widget> list = [];
    if (cart != null) {
      for (ProductModel p in cart.products) {
        OrderRow orderRow = OrderRow(
            productId: p.id,
            productName: p.name,
            productPrice: p.price,
            productQuantity: p.amount.toString(),
            productAttributeID: "0");
        orderRowList.add(orderRow);
        String name = p.name;
        String price = p.price.toString();
        int amount = p.amount;
        list.add(
          Card(
            borderOnForeground: true,
            margin: const EdgeInsets.all(4),
            elevation: 1.0,
            //shape: Border(left: BorderSide(color: Colors.blue, width: 4)),
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
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: double.infinity,
                              child: Text(
                                name,
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                            Row(
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
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
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
