class OrderHistory{
  String idOrderStatus;
  String dateChangeStatus;

  OrderHistory({this.idOrderStatus, this.dateChangeStatus});
  factory OrderHistory.fromJson(Map<String, dynamic> json){
    return OrderHistory(
      idOrderStatus: json["id_order_state"],
      dateChangeStatus: json["date_add"]
    );
  }
}