import 'package:flutter/material.dart';
import 'package:product_catalog/models/product.dart';

class ProductList extends StatelessWidget {
  final Product products;
  const ProductList({
    super.key,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromARGB(255, 197, 197, 197),
      ),
      child: Row(
        children: [
          // Image
          Container(
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(15),
              child: Image.network(
                products.image ?? '',
                width: 100,
                height: 100,
              ),
            ),
          ),

          SizedBox(width: 15),

          // Name and Price
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  products.name,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),

                SizedBox(height: 2),

                Text(
                  'RM' + products.price.toString(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}