//lib/widgets/product_card.dart
import 'package:flutter/material.dart';
import '../pages/product_detail_page.dart';

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final VoidCallback onAddToCart;

  const ProductCard({
    Key? key,
    required this.product,
  required this.onAddToCart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final price = (product['price'] as num?)?.toDouble() ?? 0.0;
    final discountPercentage =
        (product['discount_percentage'] as num?)?.toDouble() ?? 0.0;
    final rating = (product['rating'] as num?)?.toDouble() ?? 0.0;
    final stock = product['stock'] as int? ?? 0;

    final discountedPrice = discountPercentage > 0
        ? price - (price * discountPercentage / 100)
        : price;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailPage(
                productId: product['id'],
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  child: SizedBox(
                    height: constraints.maxHeight * 0.5,
                    width: double.infinity,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        product['thumbnail'] != null ? Image.network(
                                product['thumbnail'],
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, progress)
                                {
                                  if (progress == null) return child;
                                  return const Center(child: CircularProgressIndicator());
                                },
                                errorBuilder: (context, error, stack) =>_buildPlaceholder(),
                              )
                            : _buildPlaceholder(),
                        if (discountPercentage > 0)
                          Positioned(
                            top: 6,
                            right: 6,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text('-${discountPercentage.toStringAsFixed(0)}%',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        if (stock <= 5 && stock > 0)
                          Positioned(
                            top: 6,
                            left: 6,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text('Only $stock left',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              ),
                           ),
                      ],
                      ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(product['title'] ?? 'No Title',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (product['brand'] != null)  ... 
                              [
                                const SizedBox(height: 2),
                                Text(
                                  product['brand'],
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey[600],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.star,size: 12, color: Colors.amber[700]),
                                  const SizedBox(width: 2),
                                  Text(
                                    rating.toStringAsFixed(1),
                                    style:const TextStyle(fontSize: 10),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (discountPercentage > 0)
                                    Text('\$${price.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 9,
                                        color: Colors.grey[600],
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  Text('\$${discountedPrice.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                 ],
                              ),
                            ),
                            const SizedBox(width: 4),
                            SizedBox(
                              height: 28,
                              child: ElevatedButton(
                                onPressed: stock > 0
                                    ? () {onAddToCart();}:null,
                                style: ElevatedButton.styleFrom(
                                  padding:const EdgeInsets.symmetric(horizontal: 8),
                                  minimumSize: const Size(32, 28),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6),),
                                ),
                                child: stock > 0
                                    ? const Icon(Icons.add_shopping_cart,
                                        size: 14)
                                    : const Text('Out',style: TextStyle(fontSize: 9)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    IconData icon = Icons.shopping_bag;
    Color iconColor = Colors.grey;
    final category = product['category']?.toString().toLowerCase() ?? '';

    if (category.contains('smartphone') || category.contains('phone')) {
      icon = Icons.smartphone;
      iconColor = Colors.blue;
    } else if (category.contains('laptop')) {
      icon = Icons.laptop;
      iconColor = Colors.purple;
    } return Container(
      color: iconColor.withOpacity(0.1),
      child: Center(
        child: Icon(icon, size: 50, color: iconColor.withOpacity(0.5)),
      ),
    );
  }
}