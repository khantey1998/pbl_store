class CartRow{
  String idProduct;
  String idProductAttribute;
  String idAddressDelivery;
  String quantity;

  CartRow({this.idProduct, this.idProductAttribute, this.idAddressDelivery,
    this.quantity});

  factory CartRow.fromJson(Map<String, dynamic> parsedJson){
    return CartRow(
      idProductAttribute: parsedJson['id_product_attribute'],
      idAddressDelivery: parsedJson['id_address_delivery'],
      idProduct: parsedJson['id_product'],
      quantity: parsedJson['quantity']
    );
  }
  Map toMap(){
    var map = Map<String, dynamic>();
    map["id_product"] = this.idProduct;
    map["quantity"] = this.quantity;
    map["id_product_attribute"] = this.idProductAttribute;
    map["id_address_delivery"] = this.idAddressDelivery;
    return map;
  }
}