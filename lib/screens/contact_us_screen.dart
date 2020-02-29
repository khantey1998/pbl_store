import 'package:flutter/material.dart';
import 'package:pbl_store/components/error_box.dart';
import 'package:pbl_store/components/email_field.dart';
import 'package:pbl_store/components/input_field.dart';
import 'package:pbl_store/utils/network_utils.dart';
import 'package:pbl_store/models/contact_model.dart';
import 'package:pbl_store/models/order_model.dart';
import 'package:pbl_store/models/customer_message_model.dart';
import 'package:pbl_store/models/customer_thread_model.dart';
import 'dart:convert';
import 'package:random_string_one/constants.dart';
import 'package:random_string_one/random_string.dart';
import 'package:pbl_store/models/customer.dart';

class ContactUs extends StatefulWidget {
  final String userId;
  ContactUs({Key key, @required this.userId}) : super(key: key);
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<ContactModel> _allContacts = List();
  String _selectedContact;
  List<OrderModel> _orderReferences = List();
  String _selectedOrderReference;
  TextEditingController _emailController, _messageController;
  String _errorText, _emailError, _inputError;
  bool _isError = false;
  bool _isLoading = false;

  _fetch(String id)async{

    Customer customer = await NetworkUtils.fetchByID(id);
    setState(() {
      _emailController.text = customer.email;

    });
  }

  _getContact() async {
    _allContacts = await NetworkUtils.getAllContact();
    return _allContacts;
  }

  _getOrders(String id) async {
    return await NetworkUtils.getOrders(id);
  }

  _sendMessage() async {
    _showLoading();
    if (_valid()) {
      CustomerMessageModel customerMessageModel = CustomerMessageModel(
        message: _messageController.text.toString(),
      );
      if (_selectedOrderReference != null) {
        for (OrderModel o in _orderReferences) {
          if (_selectedOrderReference == o.reference) {
            var customerMessage = {};
            var checkCustomerThread = await NetworkUtils.getCustomerThread(o.id);
            if(checkCustomerThread == null){
              final token = randomString(
                12,
                includeSymbols: false,
                includeNumbers: false
              );
              CustomerThreadModel customerThreadModel = CustomerThreadModel(
                idCustomer: widget.userId,
                idShop: "1",
                idLang: "1",
                email: _emailController.text,
                status: "open",
                idOrder: o.id,
                token: token,
              );

              for(ContactModel c in _allContacts){
                if(c.name.contains(_selectedContact)){
                  customerThreadModel.idContact = c.id;
                }
              }
              var customerThread = {};
              customerThread["customer_thread"] = customerThreadModel.threadMap();
              String threadMap = json.encode(customerThread);
              var threadResult = await NetworkUtils.createCustomerThread(body: threadMap);
              customerMessageModel.idCustomerThread = threadResult.id;
              customerMessage["customer_message"] = customerMessageModel.msgMap();
              String messageMap = json.encode(customerMessage);
              var messageResult = await NetworkUtils.createCustomerMessage(body: messageMap);
              if(messageResult != null){
                _hideLoading();
                NetworkUtils.showSnackBar(_scaffoldKey, "Profile Updated");
                Navigator.pop(context);
              }
            }
            else if(checkCustomerThread != null){
              List<CustomerThreadModel> thread = checkCustomerThread;
              customerMessageModel.idCustomerThread = thread[0].id;
              customerMessage["customer_message"] = customerMessageModel.msgMap();
              String messageMap = json.encode(customerMessage);
              var messageResult = await NetworkUtils.createCustomerMessage(body: messageMap);
            }
          }
        }
      }


    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  _valid() {
    bool valid = true;
    if (_emailController.text.isEmpty) {
      valid = false;
      _emailError = "Email can't be blank!";
    }

    if (_messageController.text.isEmpty) {
      valid = false;
      _inputError = "Requires!";
    }
    if (_selectedContact == null) {
      NetworkUtils.showSnackBar(_scaffoldKey, "Please Choose a topic");
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

  @override
  void initState() {
    _fetch(widget.userId);
    _emailController = TextEditingController();
    _messageController = TextEditingController();
    super.initState();
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
    final errorBox = ErrorBox(isError: _isError, errorText: _errorText);
    final email =
        EmailField(emailController: _emailController, emailError: _emailError);
    final message = InputField(
      inputController: _messageController,
      inputError: _inputError,
      inputLabel: "Message",
    );

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Contact Us",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _isLoading? _loadingScreen():Container(
        padding: EdgeInsets.all(15),
        child: ListView(
          children: <Widget>[
            FutureBuilder(
              future: _getContact(),
              builder: (BuildContext context, AsyncSnapshot snapShot) {
                if (snapShot.hasData) {
                  _allContacts = snapShot.data;
                  List<String> contactNames = List();
                  for (ContactModel contact in _allContacts) {
                    contactNames.add(contact.name);
                  }
                  return DropdownButton(
                    hint: Text(
                        'Please choose a topic'), // Not necessary for Option 1
                    value: _selectedContact,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedContact = newValue;
                      });
                    },
                    items: contactNames.map((contact) {
                      return DropdownMenuItem(
                        child: Text(contact),
                        value: contact,
                      );
                    }).toList(),
                  );
                } else {
                  return DropdownButton(
                    hint: Text(
                        'Please choose a topic'), // Not necessary for Option 1
                    value: _selectedContact,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedContact = newValue;
                      });
                    },
                    items: _allContacts.map((contact) {
                      return DropdownMenuItem(
                        child: Text(contact.name),
                        value: contact,
                      );
                    }).toList(),
                  );
                }
              },
            ),
            SizedBox(
              height: 5,
            ),
            errorBox,
            email,
            SizedBox(
              height: 10,
            ),
            FutureBuilder(
              future: _getOrders(widget.userId),
              builder: (BuildContext context, AsyncSnapshot snapShot) {
                if (snapShot.hasData) {
                  _orderReferences = snapShot.data;
                  List<String> allOrderReference = List();
                  for (OrderModel order in _orderReferences) {
                    allOrderReference.add(order.reference);
                  }
                  return DropdownButton(
                    hint: Text(
                        'Please select an Order Reference (Optional)'), // Not necessary for Option 1
                    value: _selectedOrderReference,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedOrderReference = newValue;
                      });
                    },
                    items: allOrderReference.map((reference) {
                      return DropdownMenuItem(
                        child: Text(reference),
                        value: reference,
                      );
                    }).toList(),
                  );
                } else {
                  return DropdownButton(
                    hint: Text(
                        'Please select an Order Reference (Optional)'), // Not necessary for Option 1
                    value: _selectedOrderReference,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedContact = newValue;
                      });
                    },
                    items: _orderReferences.map((reference) {
                      return DropdownMenuItem(
                        child: Text(reference.reference),
                        value: reference,
                      );
                    }).toList(),
                  );
                }
              },
            ),
            SizedBox(
              height: 10,
            ),
            message,
            SizedBox(
              height: 10,
            ),
            Material(
              elevation: 3.0,
              borderRadius: BorderRadius.circular(5.0),
              color: Colors.green,
              child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width,
                onPressed: () {
                  _sendMessage();
                },
                child: Text(
                  "Send Message",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
