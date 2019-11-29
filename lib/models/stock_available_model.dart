class StockAvailableModel{
  String id;
  String idProductAttribute;
  String quantity;

  StockAvailableModel({this.id, this.idProductAttribute, this.quantity});

  factory StockAvailableModel.fromJson(Map<String, dynamic> parsedJson) {
    return StockAvailableModel(
      id: parsedJson['id'].toString(),
      idProductAttribute: parsedJson['id_product_attribute'],
      quantity: parsedJson['quantity']
    );
  }

}