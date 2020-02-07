class ProductInCategory{
  String id;

  ProductInCategory({this.id});

  factory ProductInCategory.fromJson(Map<String, dynamic> parsedJson){
    return ProductInCategory(
        id: parsedJson['id'].toString()
    );
  }
}