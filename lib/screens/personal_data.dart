import 'package:flutter/material.dart';
import 'package:pbl_store/components/email_field.dart';
import 'package:pbl_store/components/password_field.dart';
import 'package:pbl_store/components/error_box.dart';
import 'package:pbl_store/components/input_field.dart';
import 'package:pbl_store/validators/email_validator.dart';
import 'package:pbl_store/utils/network_utils.dart';
import 'package:pbl_store/models/customer.dart';
import 'package:intl/intl.dart';
import 'package:pbl_store/models/group.dart';
import 'package:pbl_store/models/association_model.dart';
import 'dart:convert';
import 'package:pbl_store/utils/auth_utils.dart';

class Data extends StatefulWidget {
  final String id;
  Data({Key key, @required this.id}) : super(key: key);
  @override
  _DataState createState() => _DataState();
}
class _DataState extends State<Data>{
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  DateFormat inputFormat = DateFormat("yyyy-MM-dd");
  String idDefaultGroup = "3";
  String firstName, lastName, email, dateOfBirth;
  DateTime selectedDate;
  _fetch(String id)async{

    Customer customer = await NetworkUtils.fetchByID(id);
    setState(() {
      firstName = customer.firstName;
      lastName = customer.lastName;
      email = customer.email;
      dateOfBirth = customer.birthday;
      dateOfBirth.contains("0000-00-00")? selectedDate = DateTime.now():selectedDate = inputFormat.parse(dateOfBirth);

      _emailController.text = email;
      _firstNameController.text = firstName;
      _lastNameController.text = lastName;

    });
  }
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900, 0,0),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 18.0);
  bool check1Val = true;
  bool check2Val = true;
  bool check3Val = true;
  TextEditingController _emailController, _passwordController,
      _firstNameController, _lastNameController;
  String _errorText, _emailError, _passwordError, _inputError;
  bool _isError = false;
  bool _obscureText = true;
  bool _isLoading = false;

  _valid() {
    bool valid = true;
    if(_emailController.text.isEmpty) {
      valid = false;
      _emailError = "Email can't be blank!";
    }
    if(_passwordController.text.isEmpty) {
      valid = false;
      _passwordError = "Password can't be blank!";
    } else if(_passwordController.text.length < 6 ) {
      valid = false;
      _passwordError = "Password is invalid!";
    }
    if(_firstNameController.text.isEmpty || _lastNameController.text.isEmpty) {
      valid = false;
      _inputError = "Requires!";
    }
    return valid;
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
  _togglePassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
  _updaterUser() async {
    _showLoading();
    if(_valid()) {
      setState(() {
        dateOfBirth = selectedDate.toString();
      });
      List<Group> groups = List();
      var resBody = {};
      groups.add(Group(id: idDefaultGroup));
      AssociationModel association = AssociationModel(group: groups);
      Customer newCustomer = Customer(
        id: widget.id,
        firstName: _firstNameController.text.toString(),
        lastName: _lastNameController.text.toString(),
        email: _emailController.text.toString(),
        password: _passwordController.text.toString(),
        birthday: dateOfBirth.split(" ")[0],
        idDefaultGroup: idDefaultGroup,
        active: "1",
        associationModel: association,
        idLang: "1",
        idShop: "1",
      );
      resBody["customer"] = newCustomer.updateMap();

      String str = json.encode(resBody);
      var updateRes = await NetworkUtils.updateUser(body: str);

      if(updateRes == 200){
        _hideLoading();
        NetworkUtils.showSnackBar(_scaffoldKey, "Profile Updated");
        Navigator.pop(context);
      }


    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    _fetch(widget.id);
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
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
      color: Colors.green,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        onPressed: (){
          _updaterUser();
        },
        child: Text(
            "Save",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),

    );
    final cancelButton = Material(
      elevation: 3.0,
      borderRadius: BorderRadius.circular(5.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        onPressed: (){
          Navigator.pop(context);
        },
        child: Text(
            "Cancel",
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

    Text dob = selectedDate!=null?Text("$selectedDate".split(" ")[0], style: TextStyle(fontSize: 20),):Text("Date of Birth");

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
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: _isLoading? _loadingScreen():Container(
          color: Color(0xfc0c0c0),
          child: ListView(
            scrollDirection: Axis.vertical,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20.0),
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
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: passwordField,
                        ),
                      ],
                    ),

                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: dob,
                        ),
                        Expanded(
                          flex: 3,
                          child: RaisedButton(
                            onPressed: () => _selectDate(context),
                            child: Text('Select Date of Birth'),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),

                    SizedBox(height: 20,),
                    Row(
                      children: <Widget>[
                        Expanded(
                            flex: 4,
                            child: saveButton),
                        Expanded(
                          flex: 1,
                          child: SizedBox(),
                        ),
                        Expanded(
                            flex: 4,
                            child: cancelButton),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      ),
    );
  }

}
