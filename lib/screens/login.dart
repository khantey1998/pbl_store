//import 'package:flutter/material.dart';
//import '../blocs/bloc.dart';
//import '../blocs/provider.dart';
//
//class LogInPage extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    final bloc = Provider.of(context);
//
//    return Scaffold(
//      body: SingleChildScrollView(
//        child: Container(
//          height: MediaQuery.of(context).size.height,
//          margin: EdgeInsets.all(16.0),
//          child: Column(
//            mainAxisSize: MainAxisSize.max,
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: <Widget>[
//              Image.asset(
//                'assets/logo1.png',
//                width: 300,
//              ),
//              emailField(bloc),
//              SizedBox(height: 20,),
//              passwordField(bloc),
//              Container(margin: EdgeInsets.only(top: 30.0)),
//              submitButton(bloc),
//            ],
//          ),
//        ),
//      )
//    );
//  }
//
//  Widget emailField(bloc) {
//    return StreamBuilder(
//      stream: bloc.email,
//      builder: (context, snapshot) {
//        return TextField(
//          onChanged: bloc.changeEmail,
//          keyboardType: TextInputType.emailAddress,
//          decoration: InputDecoration(
//            border: OutlineInputBorder(),
//            hintText: 'you@example.com',
//            labelText: 'Email Address',
//            errorText: snapshot.error,
//          ),
//        );
//      },
//    );
//  }
//
//  Widget passwordField(bloc) {
//    return StreamBuilder(
//      stream: bloc.password,
//      builder: (context, snapshot) {
//        return TextField(
//          onChanged: bloc.changePassword,
//          decoration: InputDecoration(
//              border: OutlineInputBorder(),
//              hintText: 'Must contain 8 characters',
//              labelText: 'Password',
//              errorText: snapshot.error
//          ),
//          obscureText: true,
//        );
//      },
//    );
//  }
//
//  Widget submitButton(bloc) {
//    return StreamBuilder(
//      stream: bloc.submitValid,
//      builder: (context, snapshot) {
//        return RaisedButton(
//          child: Text('Login'),
//          color: Color(0xffa78066),
//          textColor: Colors.white,
//          onPressed: snapshot.hasData
//              ? bloc.submit
//              : null,
//        );
//      },
//    );
//  }
//}


import 'dart:async';
import 'package:pbl_store/screens/main_home.dart';
import 'package:pbl_store/utils/auth_utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pbl_store/utils/network_utils.dart';
import 'package:pbl_store/validators/email_validator.dart';
import 'package:pbl_store/components/error_box.dart';
import 'package:pbl_store/components/email_field.dart';
import 'package:pbl_store/components/password_field.dart';
import 'package:pbl_store/components/login_button.dart';
import 'package:pbl_store/models/customer.dart';
import 'package:pbl_store/screens/signup.dart';
import 'package:pbl_store/models/shopping_cart.dart';
import 'dart:convert';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 18.0);
  SharedPreferences _sharedPreferences;
  bool _isError = false;
  bool _obscureText = true;
  bool _isLoading = false;
  TextEditingController _emailController, _passwordController;
  String _errorText, _emailError, _passwordError;

  @override
  void initState() {
    super.initState();
    _fetchSessionAndNavigate();
    _emailController = new TextEditingController();
    _passwordController = new TextEditingController();
  }

  _fetchSessionAndNavigate() async {
    _sharedPreferences = await _prefs;
    String authToken = AuthUtils.getToken(_sharedPreferences);
    if(authToken != null) {
      Navigator.pushReplacement(_scaffoldKey.currentContext, MaterialPageRoute(builder: (context)=> MainHomePage()));
    }
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

  _authenticateUser() async {
    _showLoading();
    if(_valid()) {
      var responseJson = await NetworkUtils.verifyPassword(_emailController.text, _passwordController.text);
      if(responseJson == null) {
        NetworkUtils.showSnackBar(_scaffoldKey, 'Incorrect Email or Password!');
      } else if(responseJson == false) {
        NetworkUtils.showSnackBar(_scaffoldKey, 'Incorrect Email or Password!');

      } else if(responseJson == 'NetworkError') {
        NetworkUtils.showSnackBar(_scaffoldKey, 'NetworkError');
      } else {
        var responseJson = await NetworkUtils.fetch(_emailController.text);

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


        /**
         * Removes stack and start with the new page.
         * In this case on press back on HomePage app will exit.
         * **/
        Navigator.pushReplacement(_scaffoldKey.currentContext, MaterialPageRoute(builder: (context)=> MainHomePage()));
      }
      _hideLoading();
    } else {
      setState(() {
        _isLoading = false;
        _emailError;
        _passwordError;
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
    } else if(_passwordController.text.length < 5) {
      valid = false;
      _passwordError = "Password must be more than 4 characters!";
    }
    return valid;
  }
  Widget _loginScreen() {
    return new Container(
      child: new ListView(
        padding: const EdgeInsets.only(
            top: 16.0,
            left: 16.0,
            right: 16.0
        ),
        children: <Widget>[
          Image.asset(
            'assets/logo.png',
            width: 200,
            fit: BoxFit.fitHeight,
          ),
          new ErrorBox(
              isError: _isError,
              errorText: _errorText
          ),
          new EmailField(
              emailController: _emailController,
              emailError: _emailError
          ),
          new PasswordField(
            passwordController: _passwordController,
            obscureText: _obscureText,
            passwordError: _passwordError,
            togglePassword: _togglePassword,
          ),
          new LoginButton(onPressed: _authenticateUser),
          SizedBox(height: 10,),
          Center(
            child: GestureDetector(
              child: Text("Forgot Password"),
              onTap: (){
              },
            ),
          ),
          SizedBox(height: 10,),
          Row(children: <Widget>[
            Expanded(
              child: new Container(
                  margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                  child: Divider(
                    color: Colors.black,
                    height: 36,
                  )),
            ),
            Text("OR"),
            Expanded(
              child: new Container(
                  margin: const EdgeInsets.only(left: 20.0, right: 10.0),
                  child: Divider(
                    color: Colors.black,
                    height: 36,
                  )),
            ),
          ]),
          Material(
            elevation: 3.0,
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.green,
            child: MaterialButton(
              minWidth: MediaQuery.of(context).size.width,
              onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Register()));
              },
              child: Text(
                  "Create New Account",
                  textAlign: TextAlign.center,
                  style: style.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),

          ),
        ],
      ),
    );
  }
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
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        body: _isLoading ? _loadingScreen() : _loginScreen()
    );
  }
}
