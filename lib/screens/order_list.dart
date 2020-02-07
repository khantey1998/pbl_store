import 'package:flutter/material.dart';
import 'package:pbl_store/utils/network_utils.dart';
import 'package:pbl_store/models/order_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pbl_store/utils/auth_utils.dart';
import 'package:pbl_store/models/order_status.dart';
import 'package:pbl_store/utils/other_utils.dart';
import 'package:pbl_store/screens/view_order_details.dart';


// This app is a stateful, it tracks the user's current choice.
class ListOrder extends StatefulWidget {
  @override
  _ListOrderState createState() => _ListOrderState();
}
class _ListOrderState extends State<ListOrder> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;

  var _authToken, _id, _name, _homeResponse;
  Choice _selectedChoice = choices[0]; // The app's "state".

  void _select(Choice choice) {
    // Causes the app to rebuild with the new _selectedChoice.
    setState(() {
      _selectedChoice = choice;
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
  _getOrders(String id)async{
    return await NetworkUtils.getOrders(id);
  }
  _getStatus(String idOrder)async{
    return await NetworkUtils.getAllOrderStatus(idOrder);
  }

  @override
  void initState() {
    _fetchSessionAndNavigate();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final  comFirmOrderRecieveButon= Material(
      elevation: 1.0,
      borderRadius: BorderRadius.circular(1.0),
      color: Colors.red,
      child: MaterialButton(
//        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {},
        child: Text(
          "Comfirm Order Recieve".toUpperCase(),style: TextStyle(color: Colors.white,),
          textAlign: TextAlign.center,
        ),
      ),

    );
    final  statusButon= Material(
      elevation: 1.0,
      borderRadius: BorderRadius.circular(1.0),
      color: Color(0xffffcccc),
      child: MaterialButton(
//        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {},
        child: Text(
          "Processing in progress".toUpperCase(),style: TextStyle(color: Colors.redAccent,),
          textAlign: TextAlign.center,
        ),
      ),

    );
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            "Order History",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          leading: GestureDetector(
            child: Icon(Icons.arrow_back, color: Colors.black,),
            onTap: (){
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[
            // action button
          ],

        ),
        body: FutureBuilder(
          future: _getOrders(_id),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if(snapshot.hasData){List<OrderModel> orderList = snapshot.data;
              return ListView.builder(
                itemCount: orderList.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index){

                  return Container(
                    child: Column(
                      children: <Widget>[
                        FutureBuilder(
                          future: _getStatus(orderList[index].id),
                          builder: (BuildContext context, AsyncSnapshot snapshot){
                            if(snapshot.hasData){
                              List<OrderStatus> orderStatus = snapshot.data;
                              return GestureDetector(
                                onTap: (){
                                  Navigator.push(context,
                                    MaterialPageRoute(builder: (context)=>ViewOrderDetail(order: orderList[index]))
                                  );
                                },
                                child:Card(
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 1,
                                            child: new Container(
                                              margin:
                                              const EdgeInsets.only(left: 10.0, right: 20.0),
                                              child: Text("Reference: "),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: new Container(
                                              margin:
                                              const EdgeInsets.only(left: 20.0, right: 10.0),
                                              child: Text(orderList[index].reference, style: TextStyle(fontSize: 16, color: Color(0xff000080), fontWeight: FontWeight.bold),),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 1,
                                            child: new Container(
                                              margin:
                                              const EdgeInsets.only(left: 10.0, right: 20.0),
                                              child: Text("Date Order: "),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: new Container(
                                              margin:
                                              const EdgeInsets.only(left: 20.0, right: 10.0),
                                              child: Text(orderList[index].dateAdded.split(' ')[0], style: TextStyle(fontSize: 16, color: Color(0xff000080), fontWeight: FontWeight.bold),),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 1,
                                            child: new Container(
                                              margin:
                                              const EdgeInsets.only(left: 10.0, right: 20.0),
                                              child: Text("Total Price: "),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: new Container(
                                              margin:
                                              const EdgeInsets.only(left: 20.0, right: 10.0),
                                              child: Text("\$${double.parse(orderList[index].totalPaidReal)}", style: TextStyle(fontSize: 16, color: Color(0xff000080), fontWeight: FontWeight.bold),),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 6,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: <Widget>[
                                          Expanded(
                                            flex: 2,
                                            child: new Container(

                                              child: RaisedButton(
                                                color:OtherUtils.hexToColor(orderStatus.first.color),
                                                onPressed: (){
                                                  Navigator.push(context,
                                                      MaterialPageRoute(builder: (context)=>ViewOrderDetail(order: orderList[index])));
                                                  },
                                                child: Text("${orderStatus.first.status}".toUpperCase(), style: TextStyle(color: Colors.white, fontSize: 16),),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                            else{
                              return Padding(
                                padding: EdgeInsets.all(40),
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        )
                      ],
                    )
                  );
                },
              );
            }
            else{
//              return Container(
//                padding: EdgeInsets.all(50),
//                child: Center(
//                  child: CircularProgressIndicator(),
//                ),);
              return Center(
                child: Text("You haven't made any order yet!",style: TextStyle(fontWeight: FontWeight.bold),),
              );
            }
          },
        )
      );
  }
}


class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(icon: Icons.arrow_back),
  const Choice(icon: Icons.search),

];

