import 'dart:async';

import 'package:pbl_store/bloc/BlocProvider.dart';
import 'package:pbl_store/models/product_model.dart';
import 'package:pbl_store/models/shopping_cart.dart';
//import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';
import 'package:pbl_store/utils/network_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pbl_store/utils/auth_utils.dart';
import 'package:pbl_store/models/association_model.dart';
import 'package:pbl_store/models/cart_rows.dart';

class ShoppingCartBloc implements BlocBase {
  static const String TAG = "ShoppingCartBloc";
  SharedPreferences _sharedPreferences;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  ShoppingCart cart = ShoppingCart();

  /// Sinks
  Sink<ProductModel> get addition => itemAdditionController.sink;
  final itemAdditionController = StreamController<ProductModel>();

  Sink<ProductModel> get subtraction => itemSubtractionController.sink;
  final itemSubtractionController = StreamController<ProductModel>();

  /// Streams
  final _cart = BehaviorSubject<ShoppingCart>();
  Stream<ShoppingCart> get cartStream => _cart.stream;


  ShoppingCartBloc() {
    getCartRow();
    itemAdditionController.stream.listen(handleItemAdd);
    itemSubtractionController.stream.listen(handleItemRem);
  }

  ///
  /// Logic for product added to shopping cart.
  ///
  void handleItemAdd(ProductModel item) {
    //Logger(TAG).info("Add product to the shopping cart");
    cart.addProduct(item);
    cart.calculate();
    _cart.add(cart);
    return;
  }

  ///
  /// Logic for product removed from shopping cart.
  ///
  void handleItemRem(ProductModel item) {
    //Logger(TAG).info("Remove product from the shopping cart");
    cart.remProduct(item);
    cart.calculate();
    _cart.add(cart);
    return;
  }

  ///
  /// Clears the shopping cart
  ///
  void clearCart() {
    cart.clear();
  }

  getCartRow() async{
    _sharedPreferences = await _prefs;
    String auth = AuthUtils.getToken(_sharedPreferences);
    if(auth!=null){
      ShoppingCart c = await NetworkUtils.getCart(_sharedPreferences.getString(AuthUtils.cartIDKey));
      if(c.association.cartRows!=null){
        for(CartRow r in c.association.cartRows){
          ProductModel p = await NetworkUtils.getSingleProduct(r.idProduct);
          p.amount = int.parse(r.quantity);
          handleItemAdd(p);
        }
      }
    }
  }


  @override
  void dispose() {
    itemAdditionController.close();
    itemSubtractionController.close();
  }
}