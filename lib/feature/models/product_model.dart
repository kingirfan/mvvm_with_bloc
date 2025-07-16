import 'package:equatable/equatable.dart';

import 'category_model.dart';

class ProductModel extends Equatable {
  String? id;
  String? title;
  String? description;
  double? price;
  String? unit;
  String? picture;
  CategoryModel? category;

  ProductModel({
    this.id,
    this.title,
    this.description,
    this.price,
    this.unit,
    this.picture,
    this.category,
  });

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    price = (json['price'] != null) ? (json['price'] as num).toDouble() : null;
    unit = json['unit'];
    picture = json['picture'];
    category = json['category'] != null
        ? CategoryModel.fromJson(json['category'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['price'] = price;
    data['unit'] = unit;
    data['picture'] = picture;
    if (category != null) {
      data['category'] = category!.toJson();
    }
    return data;
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    price,
    unit,
    picture,
    category,
  ];
}
