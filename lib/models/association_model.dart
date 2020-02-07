import 'package:pbl_store/models/cat_id.dart';
import 'package:pbl_store/models/stock_available_model.dart';
import 'package:pbl_store/models/image_model.dart';
import 'package:pbl_store/models/accessory_model.dart';
import 'package:pbl_store/models/group.dart';
import 'package:pbl_store/models/order_row.dart';
import 'package:pbl_store/models/cart_rows.dart';

class AssociationModel{
  List<ImageModel> images;
  List<StockAvailableModel> stockAvailable;
  List<CategoryID> categories;
  List<AccessoriesModel> relatedProducts;
  List<Group> group;
  List<CartRow> cartRows;
  List<OrderRow> orderRows;


  AssociationModel({this.orderRows, this.images, this.stockAvailable, this.categories,
    this.relatedProducts, this.group, this.cartRows});

  factory AssociationModel.fromJson(Map<String, dynamic> parsedJson) {
    var imageListRaw = parsedJson['images'];
    var stockListRaw = parsedJson['stock_availables'];
    var categoryListRaw = parsedJson['categories'];
    var relatedProduct  = parsedJson['accessories'];
    var group = parsedJson['groups'];
    var cart = parsedJson['cart_rows'];
    var orderRow = parsedJson['order_rows'];

    List<CartRow> cartRowList = List();
    List<Group> groupList = List();
    List<AccessoriesModel> relatedProductList = List();


    List<ImageModel> imageList = List();
    List<StockAvailableModel> stockList = List();
    List<CategoryID> categoryList = List();
    List<OrderRow> orderRowList = List();

    if(orderRow !=null){
      orderRowList = List<OrderRow>.from(orderRow.map<OrderRow>((i) => OrderRow.fromJson(i)));
    }
    if(relatedProduct != null){
      relatedProductList = List<AccessoriesModel>.from(relatedProduct.map<AccessoriesModel>((i) => AccessoriesModel.fromJson(i)));
    }

    if(cart != null){
      cartRowList = List<CartRow>.from(cart.map<CartRow>((i) => CartRow.fromJson(i)));
    }
    if(group != null){
      groupList = List<Group>.from(group.map<Group>((i) => Group.fromJson(i)));
    }
    if(imageListRaw != null){
      imageList = List<ImageModel>.from(imageListRaw.map<ImageModel>((i) => ImageModel.fromJson(i)));
    }
    if(stockListRaw != null){
      stockList = List<StockAvailableModel>.from(stockListRaw.map<StockAvailableModel>((i) => StockAvailableModel.fromJson(i)));
    }
    if(categoryListRaw != null){
      categoryList = List<CategoryID>.from(categoryListRaw.map<CategoryID>((i) => CategoryID.fromJson(i)));
    }
    return AssociationModel(
      cartRows: cartRowList,
      group: groupList,
      images: imageList,
      stockAvailable: stockList,
      categories: categoryList,
      relatedProducts: relatedProductList,
      orderRows: orderRowList,
    );
  }
  Map groupMap(){
    var map = Map<String, dynamic>();
    map["groups"] = group!=null? group.map((g)=>g.toMap()).toList(): "";
    return map;
  }

  Map cartMap(){
    var map = Map<String, dynamic>();
    map["cart_rows"] = cartRows!=null? cartRows.map((cr)=>cr.toMap()).toList():"";
    return map;
  }

  Map orderMap(){
    var map = Map<String, dynamic>();
    map["order_rows"] = orderRows!=null? orderRows.map((or)=>or.toMap()).toList():"";
    return map;
  }
}