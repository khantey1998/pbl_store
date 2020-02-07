import 'package:pbl_store/models/association_model.dart';
class OrderModel{
  String id;
  String idAddressDelivery;
  String idAddressInvoice;
  String idCart;
  String idCurrency;
  String idLang;
  String idCustomer;
  String idCarrier;
  String currentState;
  String module;
  String invoiceNumber;
  String invoiceDate;
  String deliveryDate;
  String valid;
  String idShopGroup;
  String idShop;
  String secureKey;
  String payment;
  String totalPaid;
  String totalPaidTaxIncl;
  String totalPaidTaxExcl;
  String totalPaidReal;
  String totalProducts;
  String totalProductWt;
  String roundMode;
  String roundType;
  String conversionRate;
  String reference;
  String deliveryNumber;
  String dateAdded;
  AssociationModel association;
  String status;


  OrderModel({this.idAddressDelivery, this.idAddressInvoice, this.idCart,this.deliveryNumber,
    this.idCurrency, this.idLang, this.idCustomer, this.idCarrier, this.id,
    this.currentState, this.module, this.invoiceNumber, this.valid, this.status,
    this.idShopGroup, this.idShop, this.secureKey, this.payment, this.dateAdded,
    this.totalPaid, this.totalPaidTaxIncl, this.totalPaidTaxExcl, this.invoiceDate,
    this.totalPaidReal, this.totalProducts, this.totalProductWt, this.deliveryDate,
    this.roundMode, this.roundType, this.conversionRate, this.reference,
    this.association});

  factory OrderModel.fromJson(Map<String, dynamic> json){
    return OrderModel(
      dateAdded: json["date_add"],
      invoiceDate: json["invoice_date"],
      deliveryDate: json["delivery_date"],
      idAddressDelivery: json["id_address_delivery"],
      deliveryNumber: json["delivery_number"],
      id: json["id"].toString(),
      invoiceNumber: json["invoice_number"],
      idCart: json["id_cart"],
      payment: json["payment"],
      totalPaidReal: json["total_paid_real"],
      reference: json["reference"],
      association: json['associations']!=null ? AssociationModel.fromJson(json['associations']):AssociationModel()
    );
  }

  Map orderMap() {
    var map = Map<String, dynamic>();
    map["delivery_number"] = this.deliveryNumber;
    map["id_currency"] = this.idCurrency;
    map["id_lang"] = this.idLang;
    map["id_customer"] = this.idCustomer;
    map["id_carrier"] = this.idCarrier;
    map["current_state"] = this.currentState;
    map["module"] = this.module;
    map["invoice_number"] = this.invoiceNumber;
    map["valid"] = this.valid;
    map["id_shop_group"] = this.idShopGroup;
    map["id_shop"] = this.idShop;
    map["secure_key"] = this.secureKey;
    map["payment"] = this.payment;
    map["total_paid"] = this.totalPaid;
    map["total_paid_tax_incl"] = this.totalPaidTaxIncl;
    map["total_paid_tax_excl"] = this.totalPaidTaxExcl;
    map["total_paid_real"] = this.totalPaidReal;
    map["total_products"] = this.totalProducts;
    map["total_products_wt"] = this.totalProductWt;
    map["round_mode"] = this.roundMode;
    map["round_type"] = this.roundType;
    map["conversion_rate"] = this.conversionRate;
    map["associations"] = association != null ? this.association.orderMap(): "";
    map["id_address_delivery"] = this.idAddressDelivery;
    map["id_address_invoice"] = this.idAddressInvoice;
    map["id_cart"] = this.idCart;
    return map;
  }
  Map updateOrderMap() {
    var map = Map<String, dynamic>();
    map["invoice_date"] = this.invoiceDate;
    map["delivery_date"] = this.deliveryDate;
    map["id"] = this.id;
    map["delivery_number"] = this.deliveryNumber;
    map["id_currency"] = this.idCurrency;
    map["id_lang"] = this.idLang;
    map["id_customer"] = this.idCustomer;
    map["id_carrier"] = this.idCarrier;
    map["current_state"] = this.currentState;
    map["module"] = this.module;
    map["invoice_number"] = this.invoiceNumber;
    map["valid"] = this.valid;
    map["id_shop_group"] = this.idShopGroup;
    map["id_shop"] = this.idShop;
    map["secure_key"] = this.secureKey;
    map["payment"] = this.payment;
    map["total_paid"] = this.totalPaid;
    map["total_paid_tax_incl"] = this.totalPaidTaxIncl;
    map["total_paid_tax_excl"] = this.totalPaidTaxExcl;
    map["total_paid_real"] = this.totalPaidReal;
    map["total_products"] = this.totalProducts;
    map["total_products_wt"] = this.totalProductWt;
    map["round_mode"] = this.roundMode;
    map["round_type"] = this.roundType;
    map["conversion_rate"] = this.conversionRate;
    map["associations"] = association != null ? this.association.orderMap(): "";
    map["id_address_delivery"] = this.idAddressDelivery;
    map["id_address_invoice"] = this.idAddressInvoice;
    map["id_cart"] = this.idCart;
    map["reference"] = this.reference;
    return map;
  }
}