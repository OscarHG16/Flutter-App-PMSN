import 'package:flutter/material.dart';
import 'package:pmsn20252/data/products_ps5_data.dart';
import 'package:pmsn20252/widgets/navbar_products_ps5.dart';
import 'package:pmsn20252/widgets/product_ps5_widget.dart';

class PlaystationStoreScreen extends StatefulWidget {
  const PlaystationStoreScreen({super.key});

  @override
  State<PlaystationStoreScreen> createState() => _PlaystationStoreScreenState();
}

class _PlaystationStoreScreenState extends State<PlaystationStoreScreen> {
  String? selectedProductId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                constraints: const BoxConstraints(
                  minHeight: 140,
                  maxHeight: 200,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _roundedSquareButton(Icons.menu),
                    Expanded(
                      child: Container(
                        height: 100,
                        child: Image.network(
                          "https://static.vecteezy.com/system/resources/previews/019/909/663/non_2x/paytm-transparent-paytm-free-free-png.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    _roundedSquareButton(Icons.settings),
                  ],
                ),
              ),
            ),
            // GRIDVIEW
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: products.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 0.56,
                  ),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ProductCard(
                      product: product,
                      isSelected: selectedProductId == product.id, 
                      onTap: () {
                        setState(() {
                          if (selectedProductId == product.id) {
                            selectedProductId = null;
                          } else {
                            selectedProductId = product.id;
                          }
                        });
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomNavBar(),
    );
  }

  Widget _roundedSquareButton(IconData icon) {
    return Container(
      margin: const EdgeInsets.all(6),
      padding: const EdgeInsets.all(10),
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(2, 3),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.9),
            blurRadius: 6,
            offset: const Offset(-2, -3),
          ),
        ],
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Icon(
        icon,
        color: Colors.black87,
        size: 20,
      ),
    );
  }
}