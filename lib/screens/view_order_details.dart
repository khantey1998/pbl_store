import 'package:flutter/material.dart';
import 'package:pbl_store/models/order_model.dart';
import 'package:pbl_store/models/order_status.dart';
import 'package:pbl_store/utils/network_utils.dart';
import 'package:pbl_store/utils/other_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pbl_store/utils/auth_utils.dart';
import 'package:pbl_store/models/address_model.dart';
import 'package:pbl_store/models/order_row.dart';
//import 'package:cached_network_image/cached_network_image.dart';

class ViewOrderDetail extends StatefulWidget {
  final OrderModel order;
  ViewOrderDetail({Key key, @required this.order}) : super(key: key);
  @override
  _ViewOrderDetailState createState() => _ViewOrderDetailState();
}

class _ViewOrderDetailState extends State<ViewOrderDetail> {
  var _id;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;

  _fetchSessionAndNavigate() async {
    _sharedPreferences = await _prefs;
    String authToken = AuthUtils.getToken(_sharedPreferences);
    var id = _sharedPreferences.getString(AuthUtils.userIdKey);
    var name = _sharedPreferences.getString(AuthUtils.nameKey);

    setState(() {
      _id = id;
    });
  }

  _getAllStatus(String idOrder) async {
    return await NetworkUtils.getAllOrderStatus(idOrder);
  }

  _getAddress(String idAddress) async {
    return await NetworkUtils.getOneAddress(idAddress);
  }

  @override
  void initState() {
    _fetchSessionAndNavigate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<OrderRow> orderRows = widget.order.association.orderRows;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Order Details", style: TextStyle(color: Colors.black),),
        leading: GestureDetector(
          child: Icon(Icons.arrow_back, color: Colors.black,),
          onTap: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Card(
                  child: Container(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: new Container(
                                margin: const EdgeInsets.only(
                                    left: 10.0, right: 20.0),
                                child: Text("Reference: ",style: TextStyle(fontSize: 15),),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: new Container(
                                margin: const EdgeInsets.only(
                                    left: 20.0, right: 10.0),
                                child: Text(
                                  widget.order.reference,
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Color(0xff000080),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: new Container(
                                margin: const EdgeInsets.only(
                                    left: 10.0, right: 20.0),
                                child: Text("Date Order: ",style: TextStyle(fontSize: 15),),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: new Container(
                                margin: const EdgeInsets.only(
                                    left: 20.0, right: 10.0),
                                child: Text(
                                  widget.order.dateAdded.split(' ')[0],
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Color(0xff000080),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Container(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: new Container(
                                margin: const EdgeInsets.only(
                                    left: 10.0, right: 20.0),
                                child: Text("Carrier: "),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: new Container(
                                margin: const EdgeInsets.only(
                                    left: 20.0, right: 10.0),
                                child: Text(
                                  "Free delivery",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Color(0xff000080),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: new Container(
                                margin: const EdgeInsets.only(
                                    left: 10.0, right: 20.0),
                                child: Text("Payment Method: "),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: new Container(
                                margin: const EdgeInsets.only(
                                    left: 20.0, right: 10.0),
                                child: Text(
                                  widget.order.payment,
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Color(0xff000080),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left: 20, top: 15, bottom: 15),
                        child: Text(
                          "FOLLOW YOUR ORDER STATUS STAEP-BY-STEP",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      FutureBuilder(
                        future: _getAllStatus(widget.order.id),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            List<OrderStatus> orderStatus = snapshot.data;
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: orderStatus.length,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  padding: EdgeInsets.all(15),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 1,
                                        child: new Container(
                                          margin: const EdgeInsets.only(
                                              left: 20.0, right: 10.0),
                                          child: Text(
                                            orderStatus[index]
                                                .dateChangeStatus
                                                .split(' ')[0],
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                          flex: 2,
                                          child: Container(
                                            child: Container(
                                              padding: EdgeInsets.all(6),
                                              color: OtherUtils.hexToColor(
                                                  orderStatus[index].color),
                                              child: Text(
                                                "${orderStatus[index].status}"
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16),
                                              ),
                                            ),
                                          )),
                                    ],
                                  ),
                                );
                              },
                            );
                          } else {
                            return Container(
                              padding: EdgeInsets.all(20),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                        },
                      )
                    ],
                  ),
                ),
                Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left: 20, top: 15, bottom: 15),
                        child: Text(
                          "DELIVERY ADDRESS",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      FutureBuilder(
                        future: _getAddress(widget.order.idAddressDelivery),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            AddressModel address = snapshot.data;
                            return Container(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Icon(Icons.pin_drop),
                                  ),
                                  Expanded(
                                    flex: 6,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                            "${address.lastName}, ${address.firstName}, ${address.phone}",
                                            style: TextStyle(fontSize: 18),),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "${address.city}\n${address.address1}, KH, ${address.postalCode}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return Container(
                              padding: EdgeInsets.all(15),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left: 20, top: 15, bottom: 15),
                        child: Text(
                          "INVOICE ADDRESS",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      FutureBuilder(
                        future: _getAddress(widget.order.idAddressDelivery),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            AddressModel address = snapshot.data;
                            return Container(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Icon(Icons.pin_drop),
                                  ),
                                  Expanded(
                                    flex: 6,
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "${address.lastName}, ${address.firstName}, ${address.phone}",
                                          style: TextStyle(fontSize: 18),),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "${address.city}\n${address.address1}, KH, ${address.postalCode}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return Container(
                              padding: EdgeInsets.all(15),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Card(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: orderRows.length,
                    itemBuilder: (BuildContext context, int index) {
                      String price =
                          orderRows[index].productPrice.split(".")[0];
                      int subtotal =
                          int.parse(orderRows[index].productQuantity) *
                              int.parse(price);
                      return Container(
                        padding: EdgeInsets.only(left: 20, top: 15, bottom: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              child: Text(
                                orderRows[index].productName,
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "US \$${double.parse(orderRows[index].productPrice)}",
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.black,
                                        ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "${orderRows[index].productQuantity}",
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.blueAccent),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    "US \$$subtotal",
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.black,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Card(
                  child: Container(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              flex: 3,
                              child: new Container(
                                margin: const EdgeInsets.only(
                                    left: 10.0, right: 20.0),
                                child: Text("Subtotal Total: ",style: TextStyle(fontSize: 15),),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: new Container(
                                margin: const EdgeInsets.only(
                                    left: 20.0, right: 10.0),
                                child: Text(
                                  "\$${double.parse(widget.order.totalPaidReal)}",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Color(0xff000080),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              flex: 3,
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: 10.0, right: 20.0),
                                child: Text("Shipping and Handling: ",style: TextStyle(fontSize: 15),),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: new Container(
                                margin: const EdgeInsets.only(
                                    left: 20.0, right: 10.0),
                                child: Text(
                                  "Free",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Color(0xff000080),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 3,
                              child: new Container(
                                margin: const EdgeInsets.only(
                                    left: 10.0, right: 20.0),
                                child: Text("Total Price: ",style: TextStyle(fontSize: 15),),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: new Container(
                                margin: const EdgeInsets.only(
                                    left: 20.0, right: 10.0),
                                child: Text(
                                  "\$${double.parse(widget.order.totalPaidReal)}",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Color(0xff000080),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
