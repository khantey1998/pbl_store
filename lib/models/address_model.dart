class AddressModel{
  String id;
  String idCustomer;
  String company;
  String vatNumber;
  String address1;
  String address2;
  String postalCode;
  String city;
  String phone;
  String firstName;
  String lastName;
  String alias;
  String idCountry;

  AddressModel({this.id, this.idCustomer, this.company, this.vatNumber, this.address1,this.idCountry,
    this.postalCode, this.city, this.phone, this.firstName, this.lastName, this.alias, this.address2});

  factory AddressModel.fromJson(Map<String, dynamic> parsedJson) {
    return AddressModel(
        firstName: parsedJson['firstname'] as String,
        lastName: parsedJson['lastname'] as String,
        id: parsedJson['id'].toString(),
        idCustomer: parsedJson['id_customer'],
        postalCode: parsedJson['postcode'],
        city: parsedJson['city'],
        address1: parsedJson['address1'],
        company: parsedJson['company'],
        vatNumber: parsedJson['vat_number'],
        phone: parsedJson['phone']

    );
  }
  Map toMap(){
    var map = Map<String, dynamic>();
    map["firstname"] = this.firstName;
    map["lastname"] = this.lastName;
    map["id_customer"] = this.idCustomer;
    map["postcode"] = this.postalCode;
    map["city"] = this.city;
    map["address1"] = this.address1;
    map["address2"] = this.address2;
    map["id_country"] = this.idCountry;
    map["company"] = this.company;
    map["vat_number"] = this.vatNumber;
    map["phone"] = this.phone;
    map["alias"] = this.alias;

    return map;
  }


}