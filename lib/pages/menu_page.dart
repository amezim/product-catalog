import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:product_catalog/components/product_list.dart';
import 'package:product_catalog/models/product.dart';
import 'package:product_catalog/pages/product_details_page.dart';
import 'package:product_catalog/services/api_services.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {

  // final List<Product> productItem = Product.tempProduct;
  late Future<List<Product>?> productFuture;

  // Fetch data for products list
  @override
  void initState() {
    super.initState();
    productFuture = APIServices().fetchProducts(1, 20);
  }

  // Handle search input
  void searchInput(String query) {
    setState(() {
      productFuture = APIServices().searchProducts(query);
    });
  }

  // Navigate screen to product details page
  void navigateProductDetails(Product selected) {
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => ProductDetailsPage(
          products: selected,
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
              onChanged: searchInput,
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

          // Header Text
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

          // Product List + Future Builder
          Expanded(
            child: FutureBuilder<List<Product>?>(
              future: productFuture,
              builder: (context, snapshot) {
                // Waiting
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Error
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error loading products: ${snapshot.error}'),
                  );
                }

                // Success
                if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
                  final products = snapshot.data!;
                  return ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final item = products[index];
                      return ProductList(
                        products: item,
                        onTap: () => navigateProductDetails(item),
                      );
                    },
                  );
                }
                return const Center(child: Text("No products found"));
              }
            ),
          )

          /*
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
          */

        ],
      ),
    );
  }
}