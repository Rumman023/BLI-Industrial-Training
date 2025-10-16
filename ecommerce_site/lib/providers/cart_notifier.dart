// lib/providers/cart_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartItem {
  final int productId;
  final String title;
  final double price;
  final String thumbnail;
  int quantity;

  CartItem({
    required this.productId,
    required this.title,
    required this.price,
    required this.thumbnail,
    this.quantity = 1,
  });

  double get totalPrice => price * quantity;

  CartItem copyWith({int? quantity}) {
    return CartItem(
      productId: productId,
      title: title,
      price: price,
      thumbnail: thumbnail,
      quantity: quantity ?? this.quantity,
    );
  }
}

class CartState {
  final Map<int, CartItem> items;

  CartState({Map<int, CartItem>? items}) : items = {...?items};

  double get totalAmount => items.values.fold(0.0, (s, i) => s + i.totalPrice);
  int get totalQuantity => items.values.fold(0, (s, i) => s + i.quantity);
}

class CartNotifier extends StateNotifier<CartState> {
  CartNotifier(): super(CartState(items: {}));

  void addItem(int productId, String title, double price, String thumbnail) {
    final existing = state.items[productId];
    final newItems = {...state.items};
    if (existing != null) {
      newItems[productId] = existing.copyWith(quantity: existing.quantity + 1);
    } else {
      newItems[productId] = CartItem(
        productId: productId,
        title: title,
        price: price,
        thumbnail: thumbnail,
      );
    }
    state = CartState(items: newItems);
  }

  void removeItem(int productId) {
    final newItems = {...state.items};
    newItems.remove(productId);
    state = CartState(items: newItems);
  }

  void updateQuantity(int productId, int quantity) {
    final existing = state.items[productId];
    if (existing == null) return;
    final newItems = {...state.items};
    if (quantity <= 0) {
      newItems.remove(productId);
    } else {
      newItems[productId] = existing.copyWith(quantity: quantity);
    }
    state = CartState(items: newItems);
  }

  void clearCart() {
    state = CartState(items: {});
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});
