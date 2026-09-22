import 'package:flutter/material.dart';
import 'package:product_catalog/components/product_list.dart';
import 'package:product_catalog/models/product.dart';
import 'package:product_catalog/pages/product_details_page.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {

  final List<Product> productItem = Product.tempProduct;

  void navigateProductDetails(int index) {
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => ProductDetailsPage(
          products: productItem[index],
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 215, 215, 215),
        title: 
        Text(
          'Product Catalog',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Field
          Container(
            margin: EdgeInsets.only(top: 30, right: 20, left: 20),
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color.fromARGB(255, 220, 220, 220),
                hintText: 'Search',
                hintStyle: TextStyle(
                  color: const Color.fromARGB(255, 155, 155, 155),
                  fontSize: 15,
                  // fontWeight: FontWeight.bold,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                )
              ),
            ),
          ),

          // Text
          Padding(
            padding: EdgeInsets.only(top: 15, bottom: 5, left: 20),
            child: Text(
              "List of Products",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Product List
          Expanded(
            child: 
              ListView.builder (
                itemCount: productItem.length,
                itemBuilder: (context, index) => ProductList(
                  products: productItem[index],
                  onTap: () => navigateProductDetails(index),
                ),
              ),
          ),

        ],
      ),
    );
  }
}