import 'package:flutter/material.dart';
import 'package:pbl_store/models/address_model.dart';
import 'package:pbl_store/utils/network_utils.dart';
import 'package:pbl_store/utils/auth_utils.dart';
import 'package:pbl_store/components/input_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:pbl_store/components/error_box.dart';


// This app is a stateful, it tracks the user's current choice.
class Address extends StatefulWidget {
  @override
  _AddressState createState() => _AddressState();
}
class _AddressState extends State<Address> {

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;
  String _inputError, _errorText;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController fNameController, lNameController, companyController, phoneController,
      vatController, address1Controller, address2Controller, postCodeController, cityController;
  bool _isError = false;

  Choice _selectedChoice = choices[0]; // The app's "state".
  void _select(Choice choice) {
    // Causes the app to rebuild with the new _selectedChoice.
    setState(() {
      _selectedChoice = choice;
    });
  }
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 18.0);
  String dropdownValue = 'Cambodia';
  bool checkVal = true;
  bool _isLoading = false;

  @override
  void initState() {

    fNameController = TextEditingController();
    lNameController = TextEditingController();
    companyController = TextEditingController();
    phoneController = TextEditingController();
    vatController = TextEditingController();
    address1Controller = TextEditingController();
    address2Controller = TextEditingController();
    postCodeController = TextEditingController();
    cityController = TextEditingController();
    super.initState();
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
  _valid() {
    bool valid = true;
    if(fNameController.text.isEmpty || lNameController.text.isEmpty || address1Controller.text.isEmpty || postCodeController.text.isEmpty) {
      valid = false;
      _inputError = "Requires";
    }
    return valid;
  }

  _createAddress()async{
    _showLoading();
    if(_valid()) {
      _sharedPreferences = await _prefs;
      AddressModel newAddress = AddressModel(
          firstName: fNameController.text.toString(),
          lastName: lNameController.text.toString(),
          address1: address1Controller.text.toString(),
          alias: "My Address",
          vatNumber: vatController.text.toString(),
          company: companyController.text.toString(),
          city: cityController.text.toString(),
          idCountry: "63",
          phone: phoneController.text.toString(),
          postalCode: postCodeController.text.toString(),
          idCustomer: _sharedPreferences.getString(AuthUtils.userIdKey),
          address2: address2Controller.text.toString()
      );
      var addressBody = {};
      addressBody["address"] = newAddress.toMap();
      String strAddress = json.encode(addressBody);
      var a = await NetworkUtils.createAddress(body: strAddress);

      if(a!=null){
        print("$a success");
        NetworkUtils.showSnackBar(_scaffoldKey, "New Address Added!");
        Navigator.pop(context);
        _hideLoading();
      }

    } else {
      setState(() {
        _isLoading = false;

      });
    }
  }
  @override
  Widget build(BuildContext context) {
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
    final errorBox =  ErrorBox(isError: _isError, errorText: _errorText);
    final fName = InputField( inputLabel: "First Name", inputController: fNameController, inputError: _inputError,);
    final lName = InputField( inputLabel: "Last Name", inputController: lNameController,inputError: _inputError,);
    final company = InputField(inputLabel: "Company", inputController: companyController,inputError: _inputError,);
    final vatNum = InputField(inputLabel: "VAT Number", inputHint: "optional", inputController: vatController,inputError: _inputError,);
    final address = InputField(inputLabel: "Address", inputController: address1Controller,inputError: _inputError,);
    final addressCom = InputField(inputLabel: "Address Complement", inputHint: "optional", inputController: address2Controller,);
    final zipCode = InputField(inputLabel: "Zip/Pastal Code", inputController: postCodeController,inputError: _inputError,);
    final city = InputField(inputLabel: "City", inputController: cityController,);
    final phone = InputField(inputLabel: "Phone", inputHint: "optional", inputController: phoneController,);
    final saveButton = Material(
      elevation: 3.0,
      borderRadius: BorderRadius.circular(5.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        onPressed: _createAddress,
        child: Text(
            "Save",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),

    );
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            "Add New Address",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          leading: IconButton(
            icon: Icon(
              choices[0].icon,
              size: 25.0,
              color: Colors.grey,
            ),
            onPressed: () {
              _select(choices[0]);
            },

          ),

        ),
        body: _isLoading? _loadingScreen() :  ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[

            Container(
              padding: EdgeInsets.all(10.0),
              child: Text("The selected address will be used both as your personal address (for invoice) and as your delivery address."),
            ),
            Container(
              padding: EdgeInsets.all(5.0),
              child: Column(
                children: <Widget>[
                  errorBox,
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: fName
                      ),
                      SizedBox(width: 20),
                      Expanded(
                          child: lName
                      ),
                    ],
                  ),
                  phone,
                  Row(
                    children: <Widget>[
                      Expanded(
                          child:  company,
                      ),
                      SizedBox(width: 20),
                      Expanded(
                          child: vatNum,
                      ),
                    ],
                  ),
                  address,
                  addressCom,
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: zipCode
                      ),
                      SizedBox(width: 20),
                      Expanded(
                          child: city
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child:  Container(
                          child: DropdownButton<String>(
                            value: dropdownValue,
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 30,
                            onChanged: (String newValue) {
                              setState(() {
                                dropdownValue = newValue;
                              });
                            },
                            isExpanded: true,
                            elevation: 1,
                            underline: Container(
                              height: 1,
                              color: Colors.grey,
                            ),
                            items: <String>['-- please choose --','Cambodia',]
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(width: 20),
                                    Expanded(
                                        child: Text(value),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                          Checkbox(
                            value: checkVal,
                            onChanged: (bool value) {
                              setState(() {
                                checkVal = value;
                              });
                            },
                          ),
                          Text("Use this address for invoice too"),
                        ],

                  ),
                  saveButton,

                ],
              ),
            ),

          ],


        ),
      ),
    );
  }
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(icon: Icons.close),

];

