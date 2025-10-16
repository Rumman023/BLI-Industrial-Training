//lib/pages/ecommerce_home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../main.dart';
import '../widgets/cart_sidebar.dart';
import '../widgets/product_card.dart';
import '../providers/cart_notifier.dart';
import 'profile_page.dart';
import 'login_page.dart';

class EcommerceHomePage extends ConsumerStatefulWidget {
  const EcommerceHomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<EcommerceHomePage> createState() => _EcommerceHomePageState();
}

class _EcommerceHomePageState extends ConsumerState<EcommerceHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String? _selectedCategory;
  List<String> _categories = [];
  List<Map<String, dynamic>> _products = [];
  Map<String, dynamic>? _profile;
  bool _isLoading = true;
  bool _showCartSidebar = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await Future.wait([
        _loadCategories(),
        _loadProfile(),
        _loadProducts(),
      ]);
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load data: ${e.toString()}';
      });
      debugPrint('Error loading data: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadCategories() async {
    try {
      final response =
          await supabase.from('products').select('category').order('category');

      final categories = <String>{};
      for (var item in response as List) {
        if (item['category'] != null &&
            item['category'].toString().isNotEmpty) {
          categories.add(item['category'].toString());
        }
      }

      if (mounted) {
        setState(() {
          _categories = categories.toList()..sort();
        });
      }
    } catch (e) {
      debugPrint('Error loading categories: $e');
      rethrow;
    }
  }

  Future<void> _loadProducts() async {
    try {
      var query = supabase.from('products').select();

      if (_selectedCategory != null) {
        query = query.eq('category', _selectedCategory!);
      }

      final response = await query.order('created_at', ascending: false);

      if (mounted) {
        setState(() {
          _products = (response as List)
              .map((item) => Map<String, dynamic>.from(item))
              .toList();
        });

        debugPrint('Loaded ${_products.length} products');
        if (_products.isNotEmpty) {
          debugPrint('First product: ${_products[0]}');
        }
      }
    } catch (e) {
      debugPrint('Error loading products: $e');
      rethrow;
    }
  }

  Future<void> _loadProfile() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return;

      final data =
          await supabase.from('profiles').select().eq('id', user.id).single();

      if (mounted) {
        setState(() {
          _profile = data;
        });
      }
    } catch (e) {
      debugPrint('Error loading profile: $e');
      // Don't rethrow - profile is not critical
    }
  }

  void _onCategorySelected(String? category) {
    setState(() {
      _selectedCategory = category;
    });
    _loadProducts();
    Navigator.pop(context);
  }

  Future<void> _addToCart(Map<String, dynamic> product) async {
    final price = _getPrice(product);
    final cartNotifier = ref.read(cartProvider.notifier);
    final int productId = product['id'] as int;
    int stock = (product['stock'] is int) ? product['stock'] as int : -1;
    final currentQty = ref.read(cartProvider).items[productId]?.quantity ?? 0;

    Future<void> _performAdd() async {
      cartNotifier.addItem( 
        productId,
        product['title'] as String,
        price,
        product['thumbnail'] as String? ?? '',
      );

      setState(() {
        _showCartSidebar = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${product['title']} added to cart'),
          duration: const Duration(seconds: 1),
          backgroundColor: Colors.green,
        ),
      );
    }

    // If stock is unknown, query the backend
    if (stock < 0) {
      try {
        final resp = await supabase.from('products').select('stock').eq('id', productId).maybeSingle();
        stock = resp != null && resp['stock'] is int ? resp['stock'] as int : -1;
      } catch (e) {
        debugPrint('Error fetching stock: $e');
      }
    }

    if (stock == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product is out of stock'), backgroundColor: Colors.red),
      );
      return;
    }

    if (stock > 0 && currentQty + 1 > stock) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Only $stock left in stock'), backgroundColor: Colors.orange),
      );
      return;
    }

    await _performAdd();
  }

  double _getPrice(Map<String, dynamic> product) {
    final price = product['price'];
    if (price == null) return 0.0;
    if (price is num) return price.toDouble();
    if (price is String) return double.tryParse(price) ?? 0.0;
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          _selectedCategory == null ? 'Shop' : _selectedCategory!,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          Consumer(
            builder: (context, ref, _) {
              final cart = ref.watch(cartProvider);
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined),
                    onPressed: () {
                      setState(() {
                        _showCartSidebar = !_showCartSidebar;
                      });
                    },
                  ),
                  if (cart.totalQuantity > 0)
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
                          '${cart.totalQuantity}',
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
              );
            },
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: Stack(
        children: [
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline,
                              size: 64, color: Colors.red[300]),
                          const SizedBox(height: 16),
                          Text(
                            'Error',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Text(
                              _errorMessage!,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: _loadData,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadData,
                      child: _products.isEmpty
                          ? ListView(
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height - 200,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.shopping_bag_outlined,
                                            size: 64, color: Colors.grey[400]),
                                        const SizedBox(height: 16),
                                        Text(
                                          'No products found',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          _selectedCategory != null
                                              ? 'Try selecting a different category'
                                              : 'Please add products to your database',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : GridView.builder(
                              padding: const EdgeInsets.all(16),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.75,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                              itemCount: _products.length,
                              itemBuilder: (context, index) {
                                return ProductCard(
                                  product: _products[index],
                                  onAddToCart: () =>
                                      _addToCart(_products[index]),
                                );
                              },
                            ),
                    ),
          if (_showCartSidebar)
            GestureDetector(
              onTap: () {
                setState(() {
                  _showCartSidebar = false;
                });
              },
              child: Container(
                color: Colors.black.withOpacity(0.3),
              ),
            ),
          if (_showCartSidebar)
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: CartSidebar(
                onClose: () {
                  setState(() {
                    _showCartSidebar = false;
                  });
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    final user = supabase.auth.currentUser;

    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade700, Colors.blue.shade500],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.store, size: 48, color: Colors.white),
                  const SizedBox(height: 12),
                  const Text(
                    'Shop by Category',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const Icon(Icons.grid_view),
                  title: const Text('All Products'),
                  selected: _selectedCategory == null,
                  selectedTileColor: Colors.blue.shade50,
                  onTap: () => _onCategorySelected(null),
                  trailing: _selectedCategory == null
                      ? Icon(Icons.check, color: Colors.blue.shade700)
                      : null,
                ),
                const Divider(),
                if (_categories.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'No categories available',
                      style: TextStyle(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  )
                else
                  ..._categories.map((category) {
                    return ListTile(
                      leading: _getCategoryIcon(category),
                      title: Text(category),
                      selected: _selectedCategory == category,
                      selectedTileColor: Colors.blue.shade50,
                      onTap: () => _onCategorySelected(category),
                      trailing: _selectedCategory == category
                          ? Icon(Icons.check, color: Colors.blue.shade700)
                          : null,
                    );
                  }).toList(),
              ],
            ),
          ),
          const Divider(height: 1),
          InkWell(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfilePage()),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _profile?['avatar_url'] != null
                        ? NetworkImage(_profile!['avatar_url'])
                        : null,
                    child: _profile?['avatar_url'] == null
                        ? Icon(Icons.person, color: Colors.grey[600])
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _profile?['full_name'] ?? 'User',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          user?.email ?? '',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Icon _getCategoryIcon(String category) {
    final categoryLower = category.toLowerCase();
    if (categoryLower.contains('smartphone') ||
        categoryLower.contains('phone')) {
      return const Icon(Icons.phone_android);
    } else if (categoryLower.contains('laptop')) {
      return const Icon(Icons.laptop);
    } else if (categoryLower.contains('cloth') ||
        categoryLower.contains('fashion')) {
      return const Icon(Icons.checkroom);
    } else if (categoryLower.contains('beauty')) {
      return const Icon(Icons.face);
    } else if (categoryLower.contains('furniture')) {
      return const Icon(Icons.weekend);
    } else if (categoryLower.contains('groceries')) {
      return const Icon(Icons.shopping_basket);
    }
    return const Icon(Icons.category);
  }
}
