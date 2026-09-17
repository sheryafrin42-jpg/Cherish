import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  void _showSuccessDialog(BuildContext context, CartProvider cart) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Color(0xFFFF8DA1), size: 28),
            SizedBox(width: 8),
            Text(
              'Pembayaran Berhasil',
              style: TextStyle(
                color: Color(0xFF5D1229),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: Text(
          'Terima kasih telah berbelanja di Cherish!\nTotal pembayaran: Rp ${cart.totalAmount.toStringAsFixed(0)}',
          style: const TextStyle(fontSize: 14, color: Color(0xFF5D1229)),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF8DA1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              cart.clearCart();
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final cartItemsList = cart.cartItems.values.toList();
    final cartKeysList = cart.cartItems.keys.toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFFF7F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF5D1229)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Keranjang Belanja',
          style: TextStyle(
            color: Color(0xFF5D1229),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFFFB2C9), width: 1.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Pembayaran',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5D1229),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF9EB1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Rp ${cart.totalAmount.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: cartItemsList.isEmpty
                ? const Center(
                    child: Text(
                      'Keranjang belanja masih kosong',
                      style: TextStyle(color: Color(0xFFFF8DA1), fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: cartItemsList.length,
                    itemBuilder: (ctx, i) {
                      final item = cartItemsList[i];
                      final productId = cartKeysList[i];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFFFB2C9), width: 1.5),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                width: 50,
                                height: 50,
                                color: const Color(0xFFFFF0F3),
                                child: Image.asset(
                                  item.imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.image_not_supported,
                                          color: Color(0xFFFF8DA1)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Color(0xFF5D1229),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Total: Rp ${(item.price * item.quantity).toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      color: Color(0xFF9E0038),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => cart.removeSingleItem(productId),
                                  child: const Text(
                                    '—',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF5D1229),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    '${item.quantity} x',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF5D1229),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    cart.addSingleItem(productId);
                                  },
                                  child: const Text(
                                    '+',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF5D1229),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Color(0xFFFFB2C9), width: 1.5),
              ),
            ),
            child: ElevatedButton(
              onPressed: cart.cartItems.isEmpty || cart.totalAmount == 0
                  ? null
                  : () => _showSuccessDialog(context, cart),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF8DA1),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Bayar Sekarang',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}