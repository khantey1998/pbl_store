class CategoryID{
  String id;
  String name;

  CategoryID({this.id, this.name});

  factory CategoryID.fromJson(Map<String, dynamic> parsedJson) {

    return CategoryID(
      id: parsedJson['id'].toString(),
      name: parsedJson['name'],
    );
  }
}