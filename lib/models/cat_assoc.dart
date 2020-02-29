import 'package:pbl_store/models/product_in_category.dart';

class CatAsso{
  List<ProductInCategory> filterPs;

  CatAsso({this.filterPs});
  factory CatAsso.fromJson(Map<String, dynamic> parsedJson) {
    var product = parsedJson['products'];
    List<ProductInCategory> filteredProductList = List();


    if(product != null){
      filteredProductList = List<ProductInCategory>.from(product.map<ProductInCategory>((i) => ProductInCategory.fromJson(i)));
    }
    return CatAsso(
      filterPs: filteredProductList,
    );
  }
}