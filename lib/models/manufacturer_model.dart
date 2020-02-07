import 'package:pbl_store/models/association_model.dart';
class ManufacturerModel{
  String id;
  String name;
  String shortDescription;

  ManufacturerModel({this.id, this.name, this.shortDescription});
  factory ManufacturerModel.fromJson(Map<String, dynamic> parsedJson) {

    return ManufacturerModel(
      id: parsedJson['id'].toString(),
      name: parsedJson['name'],
      shortDescription: parsedJson['short_description']
    );
  }

}