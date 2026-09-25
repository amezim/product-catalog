import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart';
import 'package:product_catalog/components/product_list.dart';
import 'package:product_catalog/models/product.dart';
import 'package:product_catalog/pages/product_details_page.dart';
import 'package:product_catalog/services/api_services.dart';
import 'package:product_catalog/services/debouncer.dart';
import 'package:product_catalog/controller/menu_controller.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {

  final ProductMenuController menuController = ProductMenuController();
  final ScrollController scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();

  // Fetch data for products list
  @override
  void initState() {
    super.initState();
    menuController.loadItems();
    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200 && 
        !menuController.isLoading && menuController.hasMore && !menuController.isSearching) {
        menuController.loadItems();
      }
    });
  }

  // Free up memory when an object is destroyed
  @override
  void dispose() {
    menuController.dispose();
    scrollController.dispose();
    searchController.dispose();
    super.dispose();
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
      backgroundColor: const Color.fromARGB(255, 205, 250, 150),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 125, 170, 75),
        title: Text(
          'Product Catalog',
          style: TextStyle(
            color: const Color.fromARGB(255, 25, 55, 25),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListenableBuilder(
        listenable: menuController,
        builder: (context, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Field
              Container(
                margin: EdgeInsets.only(top: 15, bottom: 5, right: 15, left: 15),
                child: TextField(
                  controller: searchController,
                  onChanged: (query) => menuController.searchInput(query),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromARGB(255, 235, 255, 235),
                    hintText: 'Search',
                    hintStyle: TextStyle(
                      color: const Color.fromARGB(255, 35, 105, 35),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(135, 35, 105, 35),
                        width: 2,
                      ),
                    ),
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
                    color: const Color.fromARGB(255, 255, 255, 235),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Sort By:',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 105, 105, 35),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  
                      DropdownButton<String>(
                        value: menuController.selectedSort,
                        underline: const SizedBox(),
                        dropdownColor: const Color.fromARGB(255, 245, 245, 200),
                        style: TextStyle(
                          color: const Color.fromARGB(255, 105, 105, 35),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        items: [
                          DropdownMenuItem(value: 'default', child: Text('Default')),
                          DropdownMenuItem(value: 'title asc', child: Text('Title ASC')),
                          DropdownMenuItem(value: 'title desc', child: Text('Title DESC')),
                          DropdownMenuItem(value: 'price asc', child: Text('Price ASC')),
                          DropdownMenuItem(value: 'price desc', child: Text('Price DESC')),
                        ],
                        onChanged: (newSort) => menuController.sortChanged(newSort),
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
                    color: const Color.fromARGB(255, 22, 84, 22),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          
              // Product List
              Expanded(
                child: switch (menuController.state) {
                  
                  ViewState.success => RefreshIndicator(
                    onRefresh: () async {
                      searchController.clear();
                      await menuController.refreshItem();
                    },
                    child: ListView.builder(
                      controller: scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: menuController.loadProducts.length + 
                        (menuController.hasMore && !menuController.isSearching ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == menuController.loadProducts.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                    
                        final item = menuController.loadProducts[index];
                    
                        return ProductList(
                          products: item,
                          onTap: () => navigateProductDetails(item),
                        );
                      }
                    ),
                  ),
                  
                  ViewState.loading => const Center(
                    child: CircularProgressIndicator(),
                  ),

                  ViewState.empty => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.inbox, 
                          color: const Color.fromARGB(255, 35, 105, 35),
                          size: 48
                        ),
                        SizedBox(height: 8),
                        Text(
                          'No Products Found',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 35, 105, 35),
                          ),
                        ),
                      ],
                    ),
                  ),

                  ViewState.error => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, color: Colors.red, size: 48),
                        const SizedBox(height: 8),
                        Text(
                          'There is an error',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 35, 105, 35),
                          ),
                        ),
                        SizedBox(height: 15),
                        ElevatedButton(
                          onPressed: () => menuController.retry(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                }
              )
            ],
          );
        }
      ),
    );
  }
}