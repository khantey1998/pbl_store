import 'package:pbl_store/models/product_model.dart';
import 'package:pbl_store/models/association_model.dart';
import 'package:pbl_store/models/cart_rows.dart';
import 'package:pbl_store/utils/network_utils.dart';
import 'dart:convert';
import 'package:pbl_store/utils/auth_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ShoppingCart {
  List<ProductModel> products = List();
  double totalPrice;
  String id;
  String idAddressDelivery;
  String idAddressInvoice;
  String idCurrency;
  String idCustomer;
  String idLanguage;
  String secureKey;
  String idShopGroup;
  String idShop;
  String idCarrier;
  AssociationModel association;
  SharedPreferences _sharedPreferences;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var _authToken, _id, _name, _homeResponse;


  ShoppingCart({this.totalPrice, this.idShopGroup, this.id, this.idShop,
    this.idAddressDelivery, this.idAddressInvoice, this.idCurrency,
    this.idCustomer, this.idLanguage, this.secureKey, this.association, this.idCarrier});

  factory ShoppingCart.fromJson(Map<String, dynamic> parsedJson) {

    return ShoppingCart(
        id: parsedJson['id'].toString(),
        association: parsedJson['associations']!=null ? AssociationModel.fromJson(parsedJson['associations']):AssociationModel()
    );
  }


  void addProduct(ProductModel p) async{
    products.add(p);
    _sharedPreferences = await _prefs;
    if(products.length>0){
      List<CartRow> cartRows = List();
      for(ProductModel product in products){
        cartRows.add(CartRow(idProduct: product.id, quantity: product.amount.toString(), idAddressDelivery: "0", idProductAttribute: "0"));
      }
      AssociationModel cartAsso = AssociationModel(cartRows: cartRows);
      ShoppingCart cart = ShoppingCart(
        id: _sharedPreferences.getString(AuthUtils.cartIDKey),
        association: cartAsso,
        idCustomer: _sharedPreferences.getString(AuthUtils.userIdKey),
        idCurrency: "2",
        idLanguage: "1",
        idShop: "1",
        idShopGroup: "1",
        secureKey: AuthUtils.getToken(_sharedPreferences),
      );
      //print(cart.toMap());
      var cartBody = {};
      cartBody["carts"] = cart.toMap();
      String strCart = json.encode(cartBody);
      var result = await NetworkUtils.updateCart(body: strCart);
      if(result == "success"){

      }
    }
  }

  void remProduct(ProductModel p) {
    products.remove(p);
  }

  void calculate() {
    totalPrice = 0;
    products.forEach((p) {
      print("amount: ${p.amount}");
      print("price: ${double.parse(p.price)}");
      totalPrice += p.amount*double.parse(p.price);
//      priceNet += p.priceNet;
//      priceGross += p.priceGross;
//      vatAmount += p.vatAmount;
    });
  }

  void clear() {
    products = [];
  }

  Map toMap(){
    var map = Map<String, dynamic>();
    map["id_currency"] = this.idCurrency;
    map["id_customer"] = this.idCustomer;
    map["id_lang"] = this.idLanguage;
    map["secure_key"] = this.secureKey;
    map["id"] = this.id;
    map["id_address_delivery"] = this.idAddressDelivery;
    map["id_address_invoice"] = this.idAddressInvoice;
    map["id_carrier "] = this.idCarrier;
    map["id_shop"] = this.idShop;
    map["id_shop_group"] = this.idShopGroup;
    map["associations"] = association != null ? this.association.cartMap(): "";
    return map;
  }
}