class CategoryID{
  String id;

  CategoryID({this.id});

  factory CategoryID.fromJson(Map<String, dynamic> parsedJson) {

    return CategoryID(
      id: parsedJson['id'].toString(),
    );
  }

}