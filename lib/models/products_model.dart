import 'dart:convert';

class ProductsModel {
  List<Menu> menu;
  int vat;
  String note;

  ProductsModel({
    required this.menu,
    required this.vat,
    required this.note,
  });

  factory ProductsModel.fromRawJson(String str) => ProductsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProductsModel.fromJson(Map<String, dynamic> json) => ProductsModel(
    menu: List<Menu>.from(json["menu"].map((x) => Menu.fromJson(x))),
    vat: json["vat"],
    note: json["note"],
  );

  Map<String, dynamic> toJson() => {
    "menu": List<dynamic>.from(menu.map((x) => x.toJson())),
    "vat": vat,
    "note": note,
  };
}

class Menu {
  int id;
  String name;
  String slug;
  String image;
  String description;
  int price;
  int discountPrice;

  Menu({
    required this.id,
    required this.name,
    required this.slug,
    required this.image,
    required this.description,
    required this.price,
    required this.discountPrice,
  });

  factory Menu.fromRawJson(String str) => Menu.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Menu.fromJson(Map<String, dynamic> json) => Menu(
    id: json["id"],
    name: json["name"].toString(),
    slug: json["slug"].toString(),
    image: json["image"].toString(),
    description: json["description"].toString(),
    price: json["price"],
    discountPrice: json["discount_price"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "slug": slug,
    "image": image,
    "description": description,
    "price": price,
    "discount_price": discountPrice,
  };
}
