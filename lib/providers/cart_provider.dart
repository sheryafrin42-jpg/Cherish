import 'package:flutter/material.dart';
import '../models/product.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  final String imageUrl;
  int quantity;

  CartItem({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
  });
}

class CartProvider with ChangeNotifier {
  final List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Pink Cheongsam Blouse',
      price: 112000,
      imageUrl: 'assets/images/baju.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Lace Flare Jeans',
      price: 260000,
      imageUrl: 'assets/images/flare jeans.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Heels',
      price: 150000,
      imageUrl: 'assets/images/heels.jpg',
    ),
    Product(
      id: 'p4',
      title: 'Wallet',
      price: 85000,
      imageUrl: 'assets/images/wallet.jpg',
    ),
  ];

  final Map<String, CartItem> _cartItems = {};

  List<Product> get items => [..._items];
  Map<String, CartItem> get cartItems => {..._cartItems};

  int get itemCount {
    int total = 0;
    _cartItems.forEach((key, item) {
      total += item.quantity;
    });
    return total;
  }

  double get totalAmount {
    var total = 0.0;
    _cartItems.forEach((key, item) {
      total += item.price * item.quantity;
    });
    return total;
  }

  void addToCart(Product product) {
    if (_cartItems.containsKey(product.id)) {
      _cartItems.update(
        product.id,
        (existing) => CartItem(
          id: existing.id,
          title: existing.title,
          price: existing.price,
          imageUrl: existing.imageUrl,
          quantity: existing.quantity + 1,
        ),
      );
    } else {
      _cartItems.putIfAbsent(
        product.id,
        () => CartItem(
          id: product.id,
          title: product.title,
          price: product.price,
          imageUrl: product.imageUrl,
        ),
      );
    }
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_cartItems.containsKey(productId)) {
      return;
    }
    if (_cartItems[productId]!.quantity > 1) {
      _cartItems.update(
        productId,
        (existing) => CartItem(
          id: existing.id,
          title: existing.title,
          price: existing.price,
          imageUrl: existing.imageUrl,
          quantity: existing.quantity - 1,
        ),
      );
    } else {
      _cartItems.remove(productId);
    }
    notifyListeners();
  }

  void addSingleItem(String productId) {
    if (_cartItems.containsKey(productId)) {
      _cartItems.update(
        productId,
        (existing) => CartItem(
          id: existing.id,
          title: existing.title,
          price: existing.price,
          imageUrl: existing.imageUrl,
          quantity: existing.quantity + 1,
        ),
      );
      notifyListeners();
    }
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}