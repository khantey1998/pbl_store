import 'package:pbl_store/models/product_in_category.dart';

class CatAsso{
  List<ProductInCategory> filterPs;

  CatAsso({this.filterPs});
  factory CatAsso.fromJson(Map<String, dynamic> parsedJson) {
    var product = parsedJson['products'] as List;
    List<ProductInCategory> filteredProductList = List();


    if(product != null){
      print(product);
      //filteredProductList = List<ProductInCategory>.from(product.map<ProductInCategory>((i) => ProductInCategory.fromJson(i)));
      filteredProductList = (product).map((data) => ProductInCategory.fromJson(data))
          .toList();
    }
    return CatAsso(
        filterPs: parsedJson["products"]!=null?List<ProductInCategory>.from(parsedJson["products"].map((x) => ProductInCategory.fromJson(x))):List<ProductInCategory>(),

    );
  }
}