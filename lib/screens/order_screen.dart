import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pbl_store/models/order_row.dart';
import 'package:pbl_store/models/order_model.dart';
import 'package:pbl_store/models/shopping_cart.dart';
import 'package:pbl_store/utils/auth_utils.dart';
import 'package:pbl_store/models/product_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pbl_store/models/address_model.dart';
import 'package:pbl_store/models/association_model.dart';
import 'dart:convert';
import 'package:pbl_store/bloc/BlocProvider.dart';
import 'package:pbl_store/bloc/GlobalBloc.dart';

class OrderScreen extends StatefulWidget {
  final ShoppingCart cart;
  final List<AddressModel> addressList;
  final String cartID;
  OrderScreen({Key key, @required this.cart, this.addressList, this.cartID})
      : super(key: key);
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String baseUrl = "http://3Q49Q5T8GNBFV7MPR7HG9FT4EP92Q4ZB@pblstore.com/api";
  SharedPreferences _sharedPreferences;
  List<OrderRow> orderRowList;
  var _authToken, _id, _name, _homeResponse;
  bool _isLoading = false;
  ShoppingCart _cart;

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

  Widget body() {
    AddressModel address = widget.addressList[0];
    AssociationModel association = AssociationModel(orderRows: orderRowList);
    OrderModel newOrder = OrderModel(
      idCart: widget.cartID,
      idCustomer: _id,
      idShop: "1",
      idAddressDelivery: address.id,
      idShopGroup: "1",
      idCurrency: "2",
      idAddressInvoice: address.id,
      idCarrier: "14",
      idLang: "2",
      totalPaidReal: widget.cart.totalPrice.toString(),
      totalPaid: widget.cart.totalPrice.toString(),
      totalPaidTaxExcl: widget.cart.totalPrice.toString(),
      totalPaidTaxIncl: widget.cart.totalPrice.toString(),
      totalProducts: widget.cart.totalPrice.toString(),
      totalProductWt: widget.cart.totalPrice.toString(),
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

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Card(
            child: Container(
              padding: EdgeInsets.all(8),
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
                      "${address.address1}, ${address.city}, ${address.postalCode}, ${address.phone}",
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
          ),
          Column(
            children: getProductTiles(),
          ),
          SizedBox(
            height: 10,
          ),
          Card(
            child: Column(
              children: <Widget>[
                Text(
                  "Order Summery",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Divider(),
                Container(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(child: Text("Subtotal: ")),
                      SizedBox(width: 20),
                      Expanded(
                          child:
                              Text("US\$${widget.cart.totalPrice.toString()}")),
                    ],
                  ),
                ),
                Divider(),
                Container(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(child: Text("Total: ")),
                      SizedBox(width: 20),
                      Expanded(
                          child:
                              Text("US\$${widget.cart.totalPrice.toString()}")),
                    ],
                  ),
                ),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> getProductTiles() {
    List<Widget> list = [];
    if (_cart != null) {
      for (ProductModel p in _cart.products) {
        OrderRow orderRow = OrderRow(
            productId: p.id,
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
            margin: const EdgeInsets.all(0.5),
            elevation: 1.0,
            shape: Border(left: BorderSide(color: Colors.blue, width: 4)),
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
                      ),
                      Divider(),
                      Container(
                        padding: EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text("Subtotal: "),
                            Text("${double.parse(p.price)*p.amount}"),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text("Shipping: "),
                            Text("\$0.00"),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text("Total: ", style: TextStyle(fontWeight: FontWeight.bold),),
                            Text("${double.parse(p.price)*p.amount}", style: TextStyle(fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ),
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

  @override
  void initState() {
    _fetchSessionAndNavigate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Order Information", style: TextStyle(color: Color(0xff333366)),),),
      body: StreamBuilder(
        stream: BlocProvider.of<GlobalBloc>(context).shoppingCartBloc.cartStream,
        builder: (context, snapshot){
          if(snapshot.hasData){
            _cart = snapshot.data;
            return Container(
              child: body(),
            );
          }
          return Container();
        },)
    );
  }
}
