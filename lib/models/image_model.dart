class ImageModel{
  String id;

  ImageModel({this.id});

  factory ImageModel.fromJson(Map<String, dynamic> parsedJson) {
    return ImageModel(
      id: parsedJson['id'],
    );
  }

}