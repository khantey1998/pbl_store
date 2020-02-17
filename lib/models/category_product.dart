import 'dart:convert';

CategoryModel categoryModelFromJson(String str) => CategoryModel.fromJson(json.decode(str));

String categoryModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
  List<CategoryModelCategory> categories;

  CategoryModel({
    this.categories,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    categories: List<CategoryModelCategory>.from(json["categories"].map((x) => CategoryModelCategory.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
  };
}

class CategoryModelCategory {
  int id;
  String idParent;
  String levelDepth;
  String nbProductsRecursive;
  String active;
  String idShopDefault;
  String isRootCategory;
  String position;
  String dateAdd;
  String dateUpd;
  String name;
  String linkRewrite;
  String description;
  String metaTitle;
  String metaDescription;
  String metaKeywords;
  Associations associations;

  CategoryModelCategory({
    this.id,
    this.idParent,
    this.levelDepth,
    this.nbProductsRecursive,
    this.active,
    this.idShopDefault,
    this.isRootCategory,
    this.position,
    this.dateAdd,
    this.dateUpd,
    this.name,
    this.linkRewrite,
    this.description,
    this.metaTitle,
    this.metaDescription,
    this.metaKeywords,
    this.associations,
  });

  factory CategoryModelCategory.fromJson(Map<String, dynamic> json) => CategoryModelCategory(
    id: json["id"],
    idParent: json["id_parent"],
    levelDepth: json["level_depth"],
    nbProductsRecursive: json["nb_products_recursive"],
    active: json["active"],
    idShopDefault: json["id_shop_default"],
    isRootCategory: json["is_root_category"],
    position: json["position"],
    dateAdd: json["date_add"],
    dateUpd: json["date_upd"],
    name: json["name"],
    linkRewrite: json["link_rewrite"],
    description: json["description"],
    metaTitle: json["meta_title"],
    metaDescription: json["meta_description"],
    metaKeywords: json["meta_keywords"],
    associations: Associations.fromJson(json["associations"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "id_parent": idParent,
    "level_depth": levelDepth,
    "nb_products_recursive": nbProductsRecursive,
    "active": active,
    "id_shop_default": idShopDefault,
    "is_root_category": isRootCategory,
    "position": position,
    "date_add": dateAdd,
    "date_upd": dateUpd,
    "name": name,
    "link_rewrite": linkRewrite,
    "description": description,
    "meta_title": metaTitle,
    "meta_description": metaDescription,
    "meta_keywords": metaKeywords,
    "associations": associations.toJson(),
  };
}

class Associations {
  List<ProductElement> categories;
  List<ProductElement> products;

  Associations({
    this.categories,
    this.products,
  });

  factory Associations.fromJson(Map<String, dynamic> json) => Associations(
    categories: List<ProductElement>.from(json["categories"].map((x) => ProductElement.fromJson(x))),
    products: List<ProductElement>.from(json["products"].map((x) => ProductElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
    "products": List<dynamic>.from(products.map((x) => x.toJson())),
  };
}

class ProductElement {
  String id;

  ProductElement({
    this.id,
  });

  factory ProductElement.fromJson(Map<String, dynamic> json) => ProductElement(
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
  };
}