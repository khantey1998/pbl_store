import 'package:flutter/material.dart';
import 'package:pbl_store/components/email_field.dart';
import 'package:pbl_store/components/password_field.dart';
import 'package:pbl_store/components/error_box.dart';
import 'package:pbl_store/components/input_field.dart';
import 'package:pbl_store/validators/email_validator.dart';
import 'package:pbl_store/models/customer.dart';
import 'package:pbl_store/models/association_model.dart';
import 'package:pbl_store/models/group.dart';
import 'dart:convert';
import 'package:pbl_store/utils/auth_utils.dart';
import 'package:pbl_store/utils/network_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pbl_store/screens/main_home.dart';
import 'package:pbl_store/models/shopping_cart.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}
class _RegisterState extends State<Register>{
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isError = false;
  bool _obscureText = true;
  SharedPreferences _sharedPreferences;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool _isLoading = false;
  TextEditingController _emailController, _passwordController, _firstNameController, _lastNameController;
  String _errorText, _emailError, _passwordError, _inputError;
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 18.0);
  bool check1Val = false;
  bool check2Val = false;
  bool check3Val = false;
  String idDefaultGroup = "3";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emailController = new TextEditingController();
    _passwordController = new TextEditingController();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
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
  _registerUser() async {
    _showLoading();
    if(_valid()) {
      List<Group> groups = List();
      var resBody = {};
      groups.add(Group(id: idDefaultGroup));
      AssociationModel association = AssociationModel(group: groups);
      Customer newCustomer = Customer(
          firstName: _firstNameController.text.toString(),
          lastName: _lastNameController.text.toString(),
          email: _emailController.text.toString(),
          password: _passwordController.text.toString(),
          idDefaultGroup: idDefaultGroup,
          active: "1",
          associationModel: association,
          idLang: "1",
          idShop: "1"
      );
      resBody["customer"] = newCustomer.toMap();
      String str = json.encode(resBody);
      var responseJson = await NetworkUtils.checkExistingEmail(_emailController.text.toString());
      if(responseJson == null) {
        var registerRes = await NetworkUtils.registerUser(body: str);
        _sharedPreferences = await _prefs;
        if(registerRes == "success"){
          List<Customer> responseJson = await NetworkUtils.fetch(_emailController.text);

          ShoppingCart newCart = ShoppingCart(
              secureKey: responseJson[0].securityKey,
              idCurrency: "2",
              idCustomer: responseJson[0].id.toString(),
              idLanguage: "1",
              idShop: "1",
              idShopGroup: "1",
              idCarrier: "3"
          );
          var cartBody = {};
          cartBody["carts"] = newCart.toMap();
          String strCart = json.encode(cartBody);
          var k = await NetworkUtils.createCart(body: strCart);
          AuthUtils.insertDetails(_sharedPreferences, responseJson, k);
          Navigator.pushReplacement(_scaffoldKey.currentContext, MaterialPageRoute(builder: (context)=> MainHomePage()));
        }
        else{
          NetworkUtils.showSnackBar(_scaffoldKey, 'Error Signing Up, Try again');
        }
      } else if(responseJson == 'NetworkError') {
        NetworkUtils.showSnackBar(_scaffoldKey, 'NetworkError');
      } else {
        _emailError = "Email already Exist!";
      }
      _hideLoading();

    } else {
      setState(() {
        _isLoading = false;

      });
    }
  }
  _valid() {
    bool valid = true;
    if(_emailController.text.isEmpty) {
      valid = false;
      _emailError = "Email can't be blank!";
    } else if(!_emailController.text.contains(EmailValidator.regex)) {
      valid = false;
      _emailError = "Enter valid email!";
    }
    if(_passwordController.text.isEmpty) {
      valid = false;
      _passwordError = "Password can't be blank!";
    } else if(_passwordController.text.length < 6) {
      valid = false;
      _passwordError = "Password is invalid!";
    }
    if(_firstNameController.text.isEmpty || _lastNameController.text.isEmpty) {
      valid = false;
      _inputError = "Requires!";
    }
    return valid;
  }

  @override
  Widget build(BuildContext context) {
    _togglePassword() {
      setState(() {
        _obscureText = !_obscureText;
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
    final fName = InputField(
      inputController: _firstNameController,
      inputError: _inputError,
      inputLabel: "First Name",
    );
    final lName = InputField(
      inputController: _lastNameController,
      inputError: _inputError,
      inputLabel: "Last Name",
    );
    final errorBox =  ErrorBox(
        isError: _isError,
        errorText: _errorText
    );
    final email = EmailField(
        emailController: _emailController,
        emailError: _emailError
    );
    final saveButton = Material(
      elevation: 3.0,
      borderRadius: BorderRadius.circular(5.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        onPressed: _registerUser,
        child: Text(
            "Register",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),

    );
    final passwordField = PasswordField(
      passwordController: _passwordController,
      obscureText: _obscureText,
      passwordError: _passwordError,
      togglePassword: _togglePassword,
    );
    final nPasswordField = TextField(
      obscureText: true,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "optional",
          labelText: "New Password",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
    );
    final dofbirth = TextField(
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          labelText: "Date of Birth",
          hintText: "optional",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))
      ),
    );
    return MaterialApp(
      home: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.white,
            title: Text(
              "Your Personal Information",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                size: 25.0,
                color: Colors.grey,
              ),
              onPressed: () {
              },

            ),

          ),
          body:  _isLoading ? _loadingScreen() : ListView(
            scrollDirection: Axis.vertical,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[


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
                    errorBox,
                    email,
                    SizedBox(height: 20,),
                    passwordField,
                    SizedBox(height: 20,),
                    dofbirth,
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: <Widget>[
                        Text(" (E.g.: 05/31/1970)"),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Checkbox(
                          value: check1Val,
                          onChanged: (bool value) {
                            setState(() {
                              check1Val = value;
                            });
                          },
                        ),
                        Text("Receive offers from our partners"),
                      ],

                    ),
                    Row(
                      children: <Widget>[
                        Checkbox(
                          value: check2Val,
                          onChanged: (bool value) {
                            setState(() {
                              check2Val = value;
                            });
                          },
                        ),
                        Container(
                          child: Text("Sign up for our newsletter You may unsubscribe at any moment. For that purpose, please find our contact info in the legal notice."),
                          width: MediaQuery.of(context).size.width*0.8,
                        )
                      ],
                    ),
                    SizedBox(height: 20,),
                    saveButton,
                  ],
                ),
              ),
            ],
          )
      ),
    );
  }

}
