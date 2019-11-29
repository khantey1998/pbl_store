class Group{
  String id;

  Group({this.id});

  factory Group.fromJson(Map<String, dynamic> parsedJson) {
    return Group(
        id: parsedJson['id'].toString(),
    );
  }


  Map toMap(){
    var map = Map<String, dynamic>();
    map["id"] = this.id;
    return map;
  }
}