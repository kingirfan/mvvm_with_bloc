import 'package:bloc_with_mvvm/feature/models/product_model.dart';

class CartModel {
  String? id;
  int? quantity;
  ProductModel? productModel;

  CartModel({this.id, this.quantity, this.productModel});

  CartModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quantity = json['quantity'];
    productModel = json['product'] != null
        ? ProductModel.fromJson(json['product'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['quantity'] = quantity;
    if (productModel != null) {
      data['product'] = productModel!.toJson();
    }
    return data;
  }
}
