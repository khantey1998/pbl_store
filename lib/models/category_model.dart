class CategoryModel{
  String id;
  String relationShipId;
  String name;
  String idParent;

  CategoryModel({this.id, this.name, this.idParent, this.relationShipId});

  factory CategoryModel.fromJson(Map<String, dynamic> parsedJson) {

    return CategoryModel(
        id: parsedJson['id'].toString(),
        name: parsedJson['name'],
        idParent: parsedJson['id_parent'],
    );
  }

}