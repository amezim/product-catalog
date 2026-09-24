import 'package:flutter/material.dart';
import 'package:product_catalog/models/product.dart';

class ProductDetailsPage extends StatefulWidget {
  final Product products;
  const ProductDetailsPage({
    super.key,
    required this.products,
  });

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 215, 215, 215),
        title: 
        Text(
          'Product Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Images
          Container(
            margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  )
                ],
                color: Colors.white,
              ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                widget.products.thumbnail ?? '',
                width: 300,
                height: 300,
              ),
            ),
          ),

          // Texts
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: 
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.products.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(
                  widget.products.brand ?? '[No Brands Available]',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),

                SizedBox(height: 5),

                Divider(
                  height: 15,
                  thickness: 2,
                ),

                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'RM' + widget.products.price.toString(),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.yellow,
                          ),
                          Text(
                            widget.products.rating.toString(),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 5),

                Text(
                  widget.products.description,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),

                SizedBox(height: 15),

                Text(
                  'Stocks Available: ' + widget.products.stock.toString(),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}