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
        brand: json['brand'] ?? '',
        thumbnail: json['thumbnail'] ?? '',
      );
    }

    /*
    // Temporary before implementing DummyJSON
    static List<Product> tempProduct = [
      Product(
        id: 1, 
        name: "Essence Mascara Lash Princess", 
        description: "The Essence Mascara Lash Princess is a popular mascara known for its volumizing and lengthening effects. Achieve dramatic lashes with this long-lasting and cruelty-free formula.", 
        category: "beauty", 
        price: 9.99, 
        rating: 2.56, 
        stock: 99, 
        image: "https://cdn.dummyjson.com/product-images/beauty/essence-mascara-lash-princess/1.webp",
      ),
      Product(
        id: 2, 
        name: "Eyeshadow Palette with Mirror", 
        description: "The Eyeshadow Palette with Mirror offers a versatile range of eyeshadow shades for creating stunning eye looks. With a built-in mirror, it's convenient for on-the-go makeup application.", 
        category: "beauty", 
        price: 19.99, 
        rating: 2.86, 
        stock: 34, 
        image: "https://cdn.dummyjson.com/product-images/beauty/eyeshadow-palette-with-mirror/1.webp",
      ),
    ];
    */

}