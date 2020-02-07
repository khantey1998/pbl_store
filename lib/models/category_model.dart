import 'package:pbl_store/models/cat_assoc.dart';

class CategoryModel{
  String id;
  String relationShipId;
  String name;
  String idParent;
  String levelDept;
  String numberProductRecursive;
  String active;
  CatAsso associationModel;

  CategoryModel({this.id, this.name, this.idParent, this.relationShipId,
    this.levelDept, this.associationModel, this.numberProductRecursive, this.active});

  factory CategoryModel.fromJson(Map<String, dynamic> parsedJson) {

    return CategoryModel(
      id: parsedJson['id'].toString(),
      name: parsedJson['name'] ,
      idParent: parsedJson['id_parent'],
      levelDept: parsedJson['level_depth'],
      active: parsedJson['active'],
      numberProductRecursive: parsedJson['nb_products_recursive'].toString(),
      associationModel: CatAsso.fromJson(parsedJson['associations'])
    );
  }

}