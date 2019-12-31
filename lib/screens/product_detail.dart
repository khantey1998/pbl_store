import 'package:flutter/material.dart';
import 'package:pbl_store/models/product_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pbl_store/models/stock_available_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:pbl_store/screens/main_home.dart';
import 'package:pbl_store/bloc/BlocProvider.dart';
import 'package:pbl_store/bloc/GlobalBloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pbl_store/utils/auth_utils.dart';
import 'package:pbl_store/screens/shoppingcart_screen.dart';
import 'package:flutter_html/flutter_html.dart';


class ProductDetailPage extends StatefulWidget {
  final ProductModel product;
  ProductDetailPage({Key key, @required this.product}) : super(key: key);
  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage>
    with TickerProviderStateMixin {
  SharedPreferences _sharedPreferences;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var _authToken, _id, _name, _homeResponse;

  String baseUrl = "http://3Q49Q5T8GNBFV7MPR7HG9FT4EP92Q4ZB@pblstore.com/api";
  StockAvailableModel stock = StockAvailableModel();
  int _n = 1;

  @override
  void initState() {
    _getRelatedProducts();
    _getAuth();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: Color(0xff333366),
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.search,
              color: Color(0xff333366),
            ),
            onPressed: () {},
          ),
        ],
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
        title: Text(
          widget.product.name,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: _buildProductDetailsPage(context),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  _getAuth() async {
    _sharedPreferences = await _prefs;
    String authToken = AuthUtils.getToken(_sharedPreferences);
    var id = _sharedPreferences.getString(AuthUtils.userIdKey);
    setState(() {
      _authToken = authToken;
      _id = id;
    });
  }

  _buildProductDetailsPage(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return ListView(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(4.0),
          child: Card(
            elevation: 4.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildProductImagesWidgets(),
                _buildProductTitleWidget(),
                SizedBox(height: 12.0),
                _buildShortDescriptionWidgets(),
                SizedBox(height: 12.0),
                _buildPriceWidgets(),
                SizedBox(height: 12.0),
                _buildDivider(screenSize),
                SizedBox(height: 12.0),
                _buildFurtherInfoWidget(),
                SizedBox(height: 12.0),
                _buildDivider(screenSize),
                SizedBox(height: 12.0),
                _buildDetailsAndMaterialWidgets(),
                SizedBox(height: 12.0),
                _buildDivider(screenSize),
                SizedBox(height: 20.0),
                _buildMoreInfoHeader(),
                SizedBox(height: 6.0),
                SizedBox(height: 4.0),
                _buildMoreInfoData(),
                SizedBox(height: 24.0),
                _buildRelatedProducts(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _buildDivider(Size screenSize) {
    return Column(
      children: <Widget>[
        Container(
          color: Colors.grey[600],
          width: screenSize.width,
          height: 0.25,
        ),
      ],
    );
  }

  _buildProductImagesWidgets() {
    TabController imagesController = TabController(
        length: widget.product.associations.images.length, vsync: this);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 250.0,
        child: Center(
          child: DefaultTabController(
            length: widget.product.associations.images.length,
            child: Stack(
              children: <Widget>[
                TabBarView(
                    controller: imagesController,
                    children: widget.product.associations.images
                        .map(
                          (image) => CachedNetworkImage(
                            imageUrl:
                                '$baseUrl/images/products/${widget.product.id.toString()}/${image.id}',
                            placeholder: (context, url) =>
                                Image.asset('assets/p.png'),
                            fit: BoxFit.fitHeight,
                            width: 100,
                          ),
                        )
                        .toList()),
                Container(
                  alignment: FractionalOffset(0.5, 0.95),
                  child: TabPageSelector(
                    controller: imagesController,
                    selectedColor: Colors.grey,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildProductTitleWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Center(
        child: Text(
          widget.product.name,
          style: TextStyle(fontSize: 16.0, color: Colors.black),
        ),
      ),
    );
  }

  _buildPriceWidgets() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(
            "\$${double.parse(widget.product.price)}",
            style: TextStyle(fontSize: 20.0, color: Colors.blue),
          ),
          SizedBox(
            width: 8.0,
          ),
//          Text(
//            "\$1299",
//            style: TextStyle(
//              fontSize: 12.0,
//              color: Colors.grey,
//              decoration: TextDecoration.lineThrough,
//            ),
//          ),
//          SizedBox(
//            width: 8.0,
//          ),
//          Text(
//            "30% Off",
//            style: TextStyle(
//              fontSize: 12.0,
//              color: Colors.blue[700],
//            ),
//          ),
        ],
      ),
    );
  }

  _buildFurtherInfoWidget() {
    return FutureBuilder(
      future: _getStock(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          stock = snapshot.data;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.local_offer,
                  color: Colors.grey[500],
                ),
                SizedBox(
                  width: 12.0,
                ),
                Text(
                  "In Stock ${stock.quantity}  items",
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }

  Future<StockAvailableModel> _getStock() async {
    var res = await http.get(
        '$baseUrl/stock_availables/${widget.product.associations.stockAvailable[0].id}');
    if (res.statusCode == 200) {

      final response = json.decode(res.body)['stock_available'];
      return StockAvailableModel.fromJson(response);
    } else
      return StockAvailableModel();
  }

  _buildShortDescriptionWidgets() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: widget.product.shortDescription.isEmpty
          ? Text("")
          : Html(
              data: """${widget.product.shortDescription}""",
            ),
    );
  }

  _buildDetailsAndMaterialWidgets() {
    TabController tabController = new TabController(length: 2, vsync: this);
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TabBar(
            controller: tabController,
            tabs: <Widget>[
              Tab(
                child: Text(
                  "DETAILS",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  "REVIEW",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
            height: MediaQuery.of(context).size.height * 0.4,
            child: TabBarView(
              controller: tabController,

              children: <Widget>[
                SingleChildScrollView(
                  child: Html(
                    data: """${widget.product.description}""",
                  ),
                ),
                SingleChildScrollView(
                  child: Center(
                    child: Text("No Reviews For This product yet"),
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildMoreInfoHeader() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 12.0,
      ),
      child: Text(
        "FREE SHIPPING",
        style: TextStyle(
          color: Colors.grey[800],
        ),
      ),
    );
  }

  _buildMoreInfoData() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 12.0,
      ),
      child: Text(
        "In Phnom Penh. Usually take up to 2 days",
        style: TextStyle(
          color: Colors.grey[600],
        ),
      ),
    );
  }

  _getRelatedProducts() async {
    List<ProductModel> relatedProductList = List();
    if (widget.product.associations.relatedProducts.length > 0) {
      for (int i = 0;
          i < widget.product.associations.relatedProducts.length;
          i++) {
        var res = await http.get(
            '$baseUrl/products/${widget.product.associations.relatedProducts[i].id}');
        if (res.statusCode == 200) {
          final response = json.decode(res.body)['product'];
          ProductModel relatedProduct = ProductModel.fromJson(response);
          relatedProductList.add(relatedProduct);
        }
      }
    }
    return relatedProductList;
  }
  _buildRelatedProducts() {
    return FutureBuilder(
      future: _getRelatedProducts(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<ProductModel> pList = snapshot.data;
          return Column(
            children: <Widget>[
              _buildDivider(MediaQuery.of(context).size),
              SizedBox(height: 24.0),
              Text(
                "RELATED PRODUCTS",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 24,
              ),
              Container(
                height: 230,
                child: ListView.builder(
                  itemCount: pList.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.all(2.0),
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black26,
                          width: 0.5,
                        ),
                      ),
                      child: GestureDetector(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            CachedNetworkImage(
                              imageUrl:
                                  '$baseUrl/images/products/${pList[index].id.toString()}/${pList[index].idDefaultImage}',
                              placeholder: (context, url) =>
                                  Image.asset('assets/p.png'),
                              width: 150,
                              fit: BoxFit.fitHeight,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(pList[index].name),
                            Text("\$${double.parse(pList[index].price)}"),
                          ],
                        ),
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailPage(
                                product: pList[index],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }

  onClose() {
    Navigator.of(context).pop();
  }

  _buildBottomNavigationBar() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50.0,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Flexible(
            flex: 1,
            child: RaisedButton(
              color: Colors.white,
              child: Center(
                child: Icon(
                  Icons.home,
                  color: Colors.red,
                ),
              ),
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => MainHomePage()));
              },
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            flex: 3,
            child: RaisedButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          widget.product.name,
                          style: TextStyle(fontSize: 16),
                        ),
                        content: StatefulBuilder(
                          builder:
                              (BuildContext context, StateSetter setState) {
                            return Container(
                              width: double.maxFinite,
                              child: ListView(
                                padding: EdgeInsets.all(5),
                                children: <Widget>[
                                  Divider(),
                                  Text("Price "),
                                  Text(
                                    "\$${double.parse(widget.product.price)}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Divider(),
                                  Text("Quantity"),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Flex(
                                    direction: Axis.horizontal,
                                    children: <Widget>[
                                      Container(
                                        width: 30,
                                        height: 30,
                                        child: RawMaterialButton(
                                          onPressed: _n > 0
                                              ? () {
                                                  setState(() {
                                                    if (_n != 0) _n--;
                                                  });
                                                }
                                              : null,
                                          shape: CircleBorder(
                                              side: BorderSide(
                                                  color: _n == 0
                                                      ? Colors.grey
                                                      : Colors.black54,
                                                  width: 0.8)),
                                          child: Icon(
                                              const IconData(0xe15b,
                                                  fontFamily: 'MaterialIcons'),
                                              color: _n == 0
                                                  ? Colors.grey
                                                  : Colors.black),
                                          elevation: 0.0,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Text('$_n',
                                          style: TextStyle(fontSize: 20.0)),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Container(
                                        width: 30,
                                        height: 30,
                                        child: RawMaterialButton(
                                          onPressed: () {
                                            setState(() {
                                              _n++;
                                            });
                                          },
                                          elevation: 0.0,
                                          child: Icon(
                                              const IconData(0xe145,
                                                  fontFamily: 'MaterialIcons'),
                                              color: Colors.black),
                                          shape: CircleBorder(
                                              side: BorderSide(
                                                  color: Colors.black54,
                                                  width: 0.8)),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      int.parse(stock.quantity) > 0
                                          ? Text("${stock.quantity} available")
                                          : Text("Not available")
                                    ],
                                  ),
                                  Divider(),
                                  _buildMoreInfoHeader(),
                                  _buildMoreInfoData()
                                ],
                              ),
                            );
                          },
                        ),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("Cancel"),
                          ),
                          FlatButton(
                            onPressed: () async {
                              widget.product.amount = _n;

                              BlocProvider.of<GlobalBloc>(context)
                                  .shoppingCartBloc
                                  .addition
                                  .add(widget.product);
                              Fluttertoast.showToast(
                                  msg: "Product added to cart!",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIos: 1,
                                  fontSize: 16.0);

                              _n = 1;
                              Navigator.of(context).pop();
                            },
                            child: Text("Add"),
                          ),
                        ],
                      );
                    });
              },
              color: Color(0xffffdde2),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.add_shopping_cart,
                      color: Colors.red,
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    Text(
                      "ADD TO CART",
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Flexible(
            flex: 3,
            child: RaisedButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ShoppingCartScreen()));
              },
              color: Colors.pinkAccent,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 4.0,
                    ),
                    Text(
                      "BUY NOW",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
