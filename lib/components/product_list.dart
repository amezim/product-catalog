import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:product_catalog/models/product.dart';

class ProductList extends StatelessWidget {
  final Product products;
  final void Function()? onTap;
  const ProductList({
    super.key,
    required this.products, 
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        padding: EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color.fromARGB(255, 247, 207, 240),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08), 
              blurRadius: 3, // Smooth glow
              spreadRadius: 1, // Slight expansion
              offset: const Offset(0, 3), // Pushes shadow downward
            ),
          ],
        ),
        child: Row(
          children: [
            // Image
            Container(
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(255, 252, 244, 251),
              ),
              child: ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(15),
                child: Image.network(
                  products.thumbnail ?? '',
                  width: 100,
                  height: 100,
                  errorBuilder: (context, error, StackTrace) => 
                  const SizedBox(
                    width: 100, 
                    height: 100, 
                    child: Icon(Icons.broken_image),
                  ),
                ),
              ),
            ),
      
            SizedBox(width: 15),
      
            // Name and Price
            Expanded(
              child: SizedBox(
                height: 90,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        Text(
                          products.name,
                          style: TextStyle(
                            color: const Color.fromARGB(255, 60, 15, 60),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          products.category,
                          style: TextStyle(
                            color: const Color.fromARGB(255, 60, 15, 60),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Text(
                            'RM' + products.price.toString(),
                            style: TextStyle(
                            color: const Color.fromARGB(255, 60, 15, 60),
                            fontWeight: FontWeight.bold,
                          ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}