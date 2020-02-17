import 'package:pbl_store/models/product_in_category.dart';

class CatAsso{
  List<ProductInCategory> filterPs;

  CatAsso({this.filterPs});
  factory CatAsso.fromJson(Map<String, dynamic> parsedJson) {
    var product = parsedJson['products'];
    List<ProductInCategory> filteredProductList = List();


    if(product != null){
      print(product);
      filteredProductList = List<ProductInCategory>.from(product.map<ProductInCategory>((i) => ProductInCategory.fromJson(i)));
      //filteredProductList = (product).map((data) => ProductInCategory.fromJson(data)).toList();
    }
    return CatAsso(
      filterPs: filteredProductList,
    );
  }
}