class CustomerMessageModel {
  String id;
  String idCustomerThread;
  String message;

  CustomerMessageModel({this.id, this.idCustomerThread, this.message});
  factory CustomerMessageModel.fromJson(Map<String, dynamic> parsedJson) {
    return CustomerMessageModel(
      id: parsedJson['id'].toString(),
    );
  }

  Map msgMap() {
    var map = Map<String, dynamic>();
    map["id_customer_thread"] = this.idCustomerThread;
    map["message"] = this.message;
    return map;
  }
}
