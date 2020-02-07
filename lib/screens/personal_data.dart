import 'package:flutter/material.dart';
import 'package:pbl_store/components/email_field.dart';
import 'package:pbl_store/components/password_field.dart';
import 'package:pbl_store/components/error_box.dart';
import 'package:pbl_store/components/input_field.dart';
import 'package:pbl_store/validators/email_validator.dart';

class Data extends StatefulWidget {
  @override
  _DataState createState() => _DataState();
}
class _DataState extends State<Data>{

  DateTime selectedDate = DateTime.now();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
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
  TextEditingController _emailController, _passwordController, _nPasswordController, _firstNameController, _lastNameController;
  String _errorText, _emailError, _passwordError, _inputError, _nPasswordError;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isError = false;
  bool _obscureText = true;
  bool _nObscureText = true;
  bool _isLoading = false;

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
    } else if(_passwordController.text.length < 6 || _nPasswordController.text.length < 6) {
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

  @override
  void initState() {
    _emailController = new TextEditingController();
    _passwordController = new TextEditingController();
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
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        onPressed: (){

        },
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
    final nPasswordField = PasswordField(
      passwordController: _passwordController,
      obscureText: _obscureText,
      passwordError: _passwordError,
      togglePassword: _togglePassword,
    );
    final dateOfBirth = InputField(
      inputController: _lastNameController,
      inputError: _inputError,
      inputLabel: "Date of Birth",
      inputHint: "Optional",
    );
    return MaterialApp(
      home: Scaffold(
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
        body: Container(
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
                        SizedBox(width: 20),
                        Expanded(
                            child: nPasswordField
                        ),
                      ],
                    ),

                    dateOfBirth,
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text("${selectedDate.toLocal()}".split(' ')[0]),
                          SizedBox(height: 20.0,),
                          RaisedButton(
                            onPressed: () => _selectDate(context),
                            child: Text('Select date'),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: <Widget>[
                        Text("(E.g.: 05/31/1970)"),
                      ],
                    ),

                    SizedBox(height: 20,),
                    saveButton,
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
