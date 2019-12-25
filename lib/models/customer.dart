import 'package:pbl_store/models/association_model.dart';
class Customer{
  String firstName;
  String lastName;
  String email;
  String id;
  String idShop;
  String idLang;
  String password;
  String securityKey;
  String active;
  String idDefaultGroup;
  AssociationModel associationModel;


  Customer({this.idShop, this.idLang,this.firstName, this.lastName, this.idDefaultGroup, this.id, this.password, this.securityKey, this.email, this.active, this.associationModel});
  factory Customer.fromJson(Map<String, dynamic> parsedJson) {
    return Customer(
        firstName: parsedJson['firstname'] as String,
        lastName: parsedJson['lastname'] as String,
        id: parsedJson['id'].toString(),
        password: parsedJson['passwd'],
        email: parsedJson['email'],
        securityKey: parsedJson['secure_key'],
        idDefaultGroup: parsedJson['id_default_group']
    );
  }
  Map toMap(){
    var map = Map<String, dynamic>();
    map["firstname"] = this.firstName;
    map["lastname"] = this.lastName;
    map["passwd"] = this.password;
    map["email"] = this.email;
    map["active"] = this.active;
    map["id"] = this.id;
    map["id_shop"] = this.idShop;
    map["id_lang"] = this.idLang;
    //map["associations"] = this.associationModel;
    map["associations"] = associationModel.groupMap();
    map["id_default_group"] = this.idDefaultGroup;
    return map;
  }
}