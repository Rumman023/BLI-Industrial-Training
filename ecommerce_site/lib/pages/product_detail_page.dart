//lib/pages/product_detail_page.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../main.dart';
import '../providers/cart_notifier.dart';

class ProductDetailPage extends ConsumerStatefulWidget {
  final int productId;

  const ProductDetailPage({
    Key? key,
    required this.productId,
  }) : super(key: key);

  @override
  ConsumerState<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends ConsumerState<ProductDetailPage> {
  Map<String, dynamic>? _product;
  bool _isLoading = true;
  String? _errorMessage;
  int _quantity = 1;
  int _selectedImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await supabase
          .from('products')
          .select()
          .eq('id', widget.productId)
          .single();

      if (mounted) {
        setState(() {
          _product = response;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load product: ${e.toString()}';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _addToCart() async {
    if (_product == null) return;

    final price = (_product!['price'] as num?)?.toDouble() ?? 0.0;
    final discountPercentage =
        (_product!['discount_percentage'] as num?)?.toDouble() ?? 0.0;
    final discountedPrice = discountPercentage > 0
        ? price - (price * discountPercentage / 100)
        : price;

    final cartNotifier = ref.read(cartProvider.notifier);
    final productId = _product!['id'] as int;
    final stock = (_product!['stock'] is int) ? _product!['stock'] as int : -1;
    final currentQty = ref.read(cartProvider).items[productId]?.quantity ?? 0;

    // If stock unknown, fetch from DB
    int dbStock = stock;
    if (dbStock < 0) {
      try {
        final resp = await supabase.from('products').select('stock').eq('id', productId).maybeSingle();
        dbStock = resp != null && resp['stock'] is int ? resp['stock'] as int : dbStock;
      } catch (e) {
        debugPrint('Error fetching stock: $e');
      }
    }

    if (dbStock == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product is out of stock'), backgroundColor: Colors.red),
      );
      return;
    }

    if (dbStock > 0 && currentQty + _quantity > dbStock) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Only $dbStock left in stock'), backgroundColor: Colors.orange),
      );
      return;
    }

    for (int i = 0; i < _quantity; i++) {
      cartNotifier.addItem(
        productId,
        _product!['title'],
        discountedPrice,
        _product!['thumbnail'] ?? '',
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added $_quantity ${_quantity > 1 ? 'items' : 'item'} to cart'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'VIEW CART',
          textColor: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  List<String> _getProductImages() {
    if (_product == null) return [];
    
    List<String> images = [];
    
    // Add thumbnail
    if (_product!['thumbnail'] != null) {
      images.add(_product!['thumbnail']);
    }
    
    // Add additional images from jsonb array
    if (_product!['images'] != null) {
      try {
        if (_product!['images'] is List) {
          images.addAll((_product!['images'] as List).cast<String>());
        }
      } catch (e) {
        debugPrint('Error parsing images: $e');
      }
    }
    
    return images;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Product Details'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null || _product == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Product Details'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
              const SizedBox(height: 16),
              Text(
                _errorMessage ?? 'Product not found',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    final price = (_product!['price'] as num?)?.toDouble() ?? 0.0;
    final discountPercentage =
        (_product!['discount_percentage'] as num?)?.toDouble() ?? 0.0;
    final rating = (_product!['rating'] as num?)?.toDouble() ?? 0.0;
    final stock = _product!['stock'] as int? ?? 0;
    final discountedPrice = discountPercentage > 0
        ? price - (price * discountPercentage / 100)
        : price;
    final images = _getProductImages();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              if (ref.watch(cartProvider).totalQuantity > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${ref.watch(cartProvider).totalQuantity}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Gallery
                  Container(
                    height: 350,
                    color: Colors.grey[100],
                    child: Column(
                      children: [
                        Expanded(
                          child: PageView.builder(
                            itemCount: images.isNotEmpty ? images.length : 1,
                            onPageChanged: (index) {
                              setState(() {
                                _selectedImageIndex = index;
                              });
                            },
                            itemBuilder: (context, index) {
                              if (images.isEmpty) {
                                return _buildPlaceholder();
                              }
                              return Image.network(
                                images[index],
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return _buildPlaceholder();
                                },
                              );
                            },
                          ),
                        ),
                        if (images.length > 1)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                images.length,
                                (index) => Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _selectedImageIndex == index
                                        ? Colors.blue
                                        : Colors.grey[400],
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Brand and Stock
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (_product!['brand'] != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue[50],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  _product!['brand'],
                                  style: TextStyle(
                                    color: Colors.blue[700],
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: stock > 0 ? Colors.green[50] : Colors.red[50],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                stock > 0 ? 'In Stock ($stock)' : 'Out of Stock',
                                style: TextStyle(
                                  color: stock > 0 ? Colors.green[700] : Colors.red[700],
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Title
                        Text(
                          _product!['title'] ?? 'No Title',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Rating
                        Row(
                          children: [
                            Row(
                              children: List.generate(
                                5,
                                (index) => Icon(
                                  index < rating.floor()
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: Colors.amber[700],
                                  size: 20,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${rating.toStringAsFixed(1)} / 5.0',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Price
                        Row(
                          children: [
                            if (discountPercentage > 0) ...[
                              Text(
                                '\$${price.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '-${discountPercentage.toStringAsFixed(0)}%',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '\$${discountedPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Description
                        if (_product!['description'] != null) ...[
                          const Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _product!['description'],
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],

                        // Category
                        if (_product!['category'] != null) ...[
                          const Text(
                            'Category',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _product!['category'],
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Bar - Add to Cart
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  // Quantity Selector
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: _quantity > 1
                              ? () {
                                  setState(() {
                                    _quantity--;
                                  });
                                }
                              : null,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            '$_quantity',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: _quantity < stock
                              ? () {
                                  setState(() {
                                    _quantity++;
                                  });
                                }
                              : null,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Add to Cart Button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: stock > 0 ? _addToCart : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: const Icon(Icons.shopping_cart),
                      label: Text(
                        stock > 0 ? 'Add to Cart' : 'Out of Stock',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
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
    );
  }

  Widget _buildPlaceholder() {
    IconData icon = Icons.shopping_bag;
    Color iconColor = Colors.grey;
    final category = _product?['category']?.toString().toLowerCase() ?? '';

    if (category.contains('smartphone') || category.contains('phone')) {
      icon = Icons.smartphone;
      iconColor = Colors.blue;
    } else if (category.contains('laptop')) {
      icon = Icons.laptop;
      iconColor = Colors.purple;
    }

    return Container(
      color: iconColor.withOpacity(0.1),
      child: Center(
        child: Icon(icon, size: 100, color: iconColor.withOpacity(0.5)),
      ),
    );
  }
}