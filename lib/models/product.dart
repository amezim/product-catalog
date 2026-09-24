import 'package:flutter/rendering.dart';

class Product {

    int id;
    String name;
    String description;
    String category;
    double price;
    double rating;
    int stock;
    String? brand;
    String? thumbnail;

    Product({
      required this.id,
      required this.name,
      required this.description,
      required this.category,
      required this.price,
      required this.rating,
      required this.stock,
      this.brand,
      this.thumbnail,
    });

    factory Product.fromJson(Map<String, dynamic> json) {
      return Product(
        id: json['id'] ?? 0, 
        name: json['title'] ?? '', 
        description: json['description'] ?? '', 
        category: json['category'] ?? '', 
        price: (json['price'] as num)?.toDouble() ?? 0.0, 
        rating: (json['rating'] as num)?.toDouble() ?? 0.0, 
        stock: json['stock'] ?? 0,
        brand: json['brand'] ?? '[No Brands Available]',
        thumbnail: json['thumbnail'] ?? '',
      );
    }

}