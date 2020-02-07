import 'package:flutter/material.dart';
import 'package:pbl_store/models/order_model.dart';
import 'package:pbl_store/models/order_status.dart';
import 'package:pbl_store/utils/network_utils.dart';
import 'package:pbl_store/utils/other_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pbl_store/utils/auth_utils.dart';

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
  _getAllStatus(String idOrder) async{
    return await NetworkUtils.getAllOrderStatus(idOrder);
  }

  @override
  void initState() {
    _fetchSessionAndNavigate();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Card(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: new Container(
                                margin:
                                const EdgeInsets.only(left: 10.0, right: 20.0),
                                child: Text("Reference: "),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: new Container(
                                margin:
                                const EdgeInsets.only(left: 20.0, right: 10.0),
                                child: Text(
                                  widget.order.reference,
                                  style: TextStyle(
                                      fontSize: 16,
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
                                margin:
                                const EdgeInsets.only(left: 10.0, right: 20.0),
                                child: Text("Date Order: "),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: new Container(
                                margin:
                                const EdgeInsets.only(left: 20.0, right: 10.0),
                                child: Text(
                                  widget.order.dateAdded.split(' ')[0],
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xff000080),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
//                  Row(
//                  children: <Widget>[
//                    Expanded(
//                      flex: 1,
//                      child: new Container(
//                        margin:
//                        const EdgeInsets.only(left: 10.0, right: 20.0),
//                        child: Text("Total Price: "),
//                      ),
//                    ),
//                    Expanded(
//                      flex: 2,
//                      child: new Container(
//                        margin:
//                        const EdgeInsets.only(left: 20.0, right: 10.0),
//                        child: Text("\$${double.parse(widget.order.totalPaidReal)}", style: TextStyle(fontSize: 16, color: Color(0xff000080), fontWeight: FontWeight.bold),),
//                      ),
//                    ),
//                  ],
//                ),

                      ],
                    ),
                  )
                ),
                Card(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: new Container(
                                margin:
                                const EdgeInsets.only(left: 10.0, right: 20.0),
                                child: Text("Carrier: "),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: new Container(
                                margin:
                                const EdgeInsets.only(left: 20.0, right: 10.0),
                                child: Text("Free delivery",
                                  style: TextStyle(
                                      fontSize: 16,
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
                                margin:
                                const EdgeInsets.only(left: 10.0, right: 20.0),
                                child: Text("Payment Method: "),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: new Container(
                                margin:
                                const EdgeInsets.only(left: 20.0, right: 10.0),
                                child: Text(
                                  widget.order.payment,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xff000080),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ),
                Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left: 20, top: 8, bottom: 8),
                        child:Text("FOLLOW YOUR ORDER STATUS STAEP-BY-STEP",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                      ),
                      FutureBuilder(
                        future: _getAllStatus(widget.order.id),
                        builder: (BuildContext context, AsyncSnapshot snapshot){
                          if(snapshot.hasData) {
                            List<OrderStatus> orderStatus = snapshot.data;
                            for(var o in orderStatus){
                              print("${o.dateChangeStatus}${o.status}");
                            }
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: orderStatus.length,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (BuildContext context, int index){
                                return Container(
                                  padding: EdgeInsets.all(5),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 1,
                                        child: new Container(
                                          margin:
                                          const EdgeInsets.only(left: 20.0, right: 10.0),
                                          child: Text(
                                            orderStatus[index].dateChangeStatus.split(' ')[0],
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                          flex: 2,
                                          child: Container(child: Container(
                                            padding: EdgeInsets.all(6),
                                            color:OtherUtils.hexToColor(orderStatus[index].color),
                                            child: Text("${orderStatus[index].status}".toUpperCase(), style: TextStyle(color: Colors.white, fontSize: 16),),
                                          ),)
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          }
                          else{
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      )
                    ],
                  ),
                )
              ],),
          ),
        ),
      )
    );
  }
}
