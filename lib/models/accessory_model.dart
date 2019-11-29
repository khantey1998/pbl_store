class AccessoriesModel{
  String id;

  AccessoriesModel({this.id});

  factory AccessoriesModel.fromJson(Map<String, dynamic> parsedJson){
    return AccessoriesModel(
      id: parsedJson['id'].toString()
    );
  }


}