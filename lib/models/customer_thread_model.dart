class CustomerThreadModel{
  String id;
  String idLang;
  String idShop;
  String idCustomer;
  String idOrder;
  String idContact;
  String email;
  String token;
  String status;

  CustomerThreadModel({this.id, this.idLang, this.idShop, this.idCustomer,
      this.idOrder, this.idContact, this.email, this.token, this.status});

  factory CustomerThreadModel.fromJson(Map<String, dynamic> parsedJson) {
    return CustomerThreadModel(
      id: parsedJson['id'].toString(),
      idOrder: parsedJson['id_order']
    );
  }
  Map threadMap() {
    var map = Map<String, dynamic>();
    map["id_lang"] = this.idLang;
    map["id_shop"] = this.idShop;
    map["id_customer"] = this.idCustomer;
    map["id_order"] = this.idOrder;
    map["id_contact"] = this.idContact;
    map["email"] = this.email;
    map["token"] = this.token;
    map["status"] = this.status;
    return map;
  }
}