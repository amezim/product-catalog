import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart';
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

  final ScrollController scrollController = ScrollController();

  List<Product> loadProducts = [];

  String selectedSort = 'default';
  bool isLoading = false;
  bool isSearching = false;
  bool isFilterActive = false;
  bool hasMore = true;
  int itemSkip = 0;
  int itemLimit = 10;

  // Fetch data for products list
  @override
  void initState() {
    super.initState();
    loadItems();
    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200 && !isLoading && hasMore && !isSearching) {
        loadItems();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<void> loadItems() async {
    if (isLoading || !hasMore)
      return;

    setState(() => isLoading = true);

    try {
      String? sort;
      String? order;

      if (selectedSort == 'title') {
        sort = 'title';
        order = 'asc';
      } else if (selectedSort == 'price') {
        sort = 'price';
        order = 'asc';
      }

      final nextProducts = await APIServices().fetchProducts(
        limit: itemLimit,
        skip: itemSkip,
        sortBy: sort,
        sortOrder: order,
      );

      setState(() {
        itemSkip += itemLimit;
        isLoading = false;

        if (nextProducts.length < itemLimit) {
          hasMore = false; 
        }

        loadProducts.addAll(nextProducts);
      });
    } catch (e) {
      setState(() => isLoading = false);
      print('Error loading items: $e');
    }
  }

  void sortChanged(String? newSort) {
    if (newSort == null || newSort == selectedSort) return;

    setState(() {
      selectedSort = newSort;
      loadProducts.clear(); 
      itemSkip = 0;         
      hasMore = true;
    });

    loadItems();
  }

  // Handle search input
  Future<void> searchInput(String query) async {
    final trimmed = query.trim();

    if (trimmed.isEmpty) {
      setState(() {
        isSearching = false;
        loadProducts.clear();
        itemSkip = 0;
        hasMore = true;
      });
      loadItems();
      return;
    }

    setState(() {
      isSearching = true;
      isLoading = true;
    });

    try {
      final searchResults = await APIServices().searchProducts(trimmed);
      setState(() {
        loadProducts = searchResults;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      print('Search error: $e');
    }
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

  // User Interface
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
            margin: EdgeInsets.only(top: 15, bottom: 5, right: 15, left: 15),
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

          // Dropdown for Sorting
          Padding(
            padding: EdgeInsetsGeometry.only(top: 5, bottom: 5, left: 15, right: 15),
            child: Container(
              margin: EdgeInsets.only(top: 5, bottom: 5),
              padding: EdgeInsets.only(left: 15, right: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.amber,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Sort By:',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              
                  DropdownButton<String>(
                    value: selectedSort,
                    underline: const SizedBox(),
                    items: [
                      DropdownMenuItem(value: 'default', child: Text('Default')),
                      DropdownMenuItem(value: 'title', child: Text('Title')),
                      DropdownMenuItem(value: 'price', child: Text('Price')),
                    ],
                    onChanged: sortChanged,
                  )
                ],
              ),
            ),
          ),

          // Header Text
          Padding(
            padding: EdgeInsets.only(bottom: 5, left: 20),
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
            child: Builder(
              builder: (context) {
                if (loadProducts.isEmpty && isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (loadProducts.isEmpty) {
                  return const Center(child: Text("No Products Found"));
                }
                return ListView.builder(
                  controller: scrollController,
                  itemCount: loadProducts.length + (hasMore && !isSearching ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == loadProducts.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final item = loadProducts[index];

                    return ProductList(
                      products: item,
                      onTap: () => navigateProductDetails(item),
                    );
                  }
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}