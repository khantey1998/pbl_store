import 'package:flutter/material.dart';
import 'package:pbl_store/utils/network_utils.dart';
import 'package:pbl_store/models/order_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pbl_store/utils/auth_utils.dart';


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
          actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(choices[1].icon),
              color: Colors.grey,
              onPressed: () {
                _select(choices[1]);
              },
            ),

          ],

        ),
        body: FutureBuilder(
          future: _getOrders(_id),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if(snapshot.hasData){
              print(snapshot.data);
              List<OrderModel> orderList = snapshot.data;
              print(orderList[0].reference);
              return ListView.builder(
                itemCount: orderList.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index){
                  return Container(
                    child: Text("${orderList[index].reference}"),
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

