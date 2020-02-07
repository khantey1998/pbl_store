class OrderStatus{
  String status;
  String orderId;
  String idStatus;
  String color;
  String dateChangeStatus;


  OrderStatus({this.status, this.orderId, this.color, this.dateChangeStatus});

  factory OrderStatus.fromJson(Map<String, dynamic> json){
    return OrderStatus(
      status: json["name"],
      color: json["color"]
    );
  }
}