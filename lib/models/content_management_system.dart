class ContentManagementSystem{
  String metaDescription;
  String content;
  String metaTitle;

  ContentManagementSystem({this.metaDescription, this.content, this.metaTitle});

  factory ContentManagementSystem.fromJson(Map<String, dynamic> parsedJson) {
    return ContentManagementSystem(
      metaDescription: parsedJson['meta_description'],
      metaTitle: parsedJson['meta_title'],
      content: parsedJson['content']
    );
  }
}