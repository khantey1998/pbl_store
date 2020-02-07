import 'package:flutter/material.dart';
import 'package:pbl_store/utils/auth_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pbl_store/utils/network_utils.dart';
import 'package:pbl_store/models/address_model.dart';
import 'package:pbl_store/screens/address_screen.dart';
class AddressList extends StatefulWidget {
  @override
  _AddressListState createState() => _AddressListState();
}

class _AddressListState extends State<AddressList> {


  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;
  var _authToken, _id, _name, _homeResponse;
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
    _fetchSessionAndNavigate();
    super.initState();
  }

  _getAddresses(String id) async{
    List<AddressModel> addresses = await NetworkUtils.getAddress(id);
    return addresses;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Your addresses", style: TextStyle(color: Colors.black),),
        leading: GestureDetector(
          child: Icon(Icons.arrow_back, color: Colors.black,),
          onTap: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.hasData){
            List<AddressModel> addressList = snapshot.data;
            return ListView.builder(
              itemCount: addressList.length,
              itemBuilder: (context, int index){
                return Card(
                    child: Container(
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("${addressList[index].firstName}, ${addressList[index].phone}", style: TextStyle(fontSize: 16)),
                                Text("${addressList[index].city}\n${addressList[index].address1}, KH, ${addressList[index].postalCode}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                                GestureDetector(
                                  child: Text("Edit",style: TextStyle(fontSize: 16, color: Colors.blue)),
                                  onTap: (){

                                  },
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
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
        future: _getAddresses(_id),
      ),

      bottomNavigationBar: Container(
        height: 50,
        child: RaisedButton(
          color: Colors.green,
          child: Text("Add New Address", style: TextStyle(color: Colors.white, fontSize: 16),),
          onPressed: (){
            Navigator.push(context,
                MaterialPageRoute(
                builder: (context) =>Address()
            ),);
          },
        ),
      )
    );
  }
}
