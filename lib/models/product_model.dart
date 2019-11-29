import 'package:pbl_store/models/association_model.dart';
import 'dart:convert';

class ProductModel{
  String name;
  String id;
  String idDefaultImage;
  String price;
  AssociationModel associations;
  String idCategoryDefault;
  String description;
  String shortDescription;
  int amount = 0;


  ProductModel({this.amount, this.id, this.name, this.idDefaultImage, this.price, this.associations, this.idCategoryDefault, this.description, this.shortDescription});
  factory ProductModel.fromJson(Map<String, dynamic> parsedJson) {


    return ProductModel(
        id: parsedJson['id'].toString(),
        name: parsedJson['name'],
        idDefaultImage: parsedJson['id_default_image'],
        price: parsedJson['price'],
        idCategoryDefault: parsedJson['id_category_default'],
        description: parsedJson['description'],
        shortDescription: parsedJson['description_short'],
        associations: AssociationModel.fromJson(parsedJson['associations'])
    );
  }
}