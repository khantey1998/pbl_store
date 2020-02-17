class ContactModel{
  String name;
  String id;

  ContactModel({this.name, this.id});

  factory ContactModel.fromJson(Map<String, dynamic> parsedJson) {

    return ContactModel(
      name: parsedJson['name'],
      id: parsedJson['id'].toString()
    );
  }
}