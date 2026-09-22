import 'package:flutter/material.dart';

class MenuPage extends StatefulWidget {
  const new({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                )
              ),
            ),
          ),

          // Text
          Padding(
            padding: EdgeInsetsDirectional.all(20),
            child: Text(
              "List of Products",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          )

          // Product List

        ],
      ),
    );
  }
}