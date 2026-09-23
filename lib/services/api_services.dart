import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:product_catalog/models/product.dart';

class APIServices {
  final baseURL = Uri.parse('https://dummyjson.com/products/');  

  // function to GET products
  Future<List<Product>> fetchProducts({required int limit, required int skip, String? sortBy, String? sortOrder}) async {
    String url = 'https://dummyjson.com/products?limit=$limit&skip=$skip';
    if (sortBy != null && sortOrder != null) {
      url += '&sortBy=$sortBy&order=$sortOrder';
    } 
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List productData = data['products'] ?? [];
      return productData.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to Load Products');
    }
  }

  // function to Search products
  Future<List<Product>> searchProducts(String query) async {
    final response = await http.get(Uri.parse('https://dummyjson.com/products/search?q=$query'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data != null && data['products'] != null) {
        final List productList = data['products'];
        return productList.map((json) => Product.fromJson(json)).toList();
      } 
      return [];
    } else {
      throw Exception('Failed to search products');
    }
  }

}