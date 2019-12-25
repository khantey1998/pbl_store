class OrderRow{
  String productId;
  String productAttributeID;
  String productQuantity;
  String productName;
  String productPrice;

  OrderRow({this.productId, this.productAttributeID, this.productQuantity, this.productName ,this.productPrice});

  factory OrderRow.fromJson(Map<String, dynamic> json){
    return OrderRow(
      productAttributeID: json["product_attribute_id"],
      productId: json["product_id"],
      productQuantity: json["product_quantity"],
      productName: json["product_name"],
      productPrice: json["product_price"]
    );
  }

  Map toMap() {
    var map = Map<String, dynamic>();
    map["product_id"] = this.productId;
    map["product_quantity"] = this.productQuantity;
    map["product_attribute_id"] = this.productAttributeID;
    map["product_name"] = this.productName;
    return map;
  }
}