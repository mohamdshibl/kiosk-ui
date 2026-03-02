import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../payment/payment_screen.dart';

class CartScreen extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  const CartScreen({super.key, required this.items});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late List<Map<String, dynamic>> _cartItems;

  @override
  void initState() {
    super.initState();
    _cartItems = List.from(widget.items);
  }

  double get _totalPrice {
    return _cartItems.fold(
      0,
      (sum, item) => sum + (item['price'] * item['quantity']),
    );
  }

  void _incrementQuantity(int index) {
    setState(() {
      _cartItems[index]['quantity']++;
    });
  }

  void _decrementQuantity(int index) {
    if (_cartItems[index]['quantity'] > 1) {
      setState(() {
        _cartItems[index]['quantity']--;
      });
    }
  }

  void _removeItem(int index) {
    _showDeleteConfirmation(index);
  }

  void _showDeleteConfirmation(int index) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.priority_high,
                  color: Colors.orange,
                  size: 30,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Are you sure you want to\ndelete this item?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFFFFFFF),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _cartItems[index]['name'],
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF777777),
                    ),
                  ),
                  Text(
                    '${_cartItems[index]['price'].toStringAsFixed(2)} EGP',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: Color(0xFFE5E5E5)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Color(0xFF999999)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _performDelete(index);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Delete'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _performDelete(int index) {
    setState(() {
      _cartItems.removeAt(index);
    });
    _showDeleteSuccess();
  }

  void _showDeleteSuccess() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.green, size: 30),
              ),
              const SizedBox(height: 20),
              const Text(
                'Item deleted',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2D2D2D),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Done'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: Column(
        children: [
          // Header
          _buildHeader(),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.black54,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Your Cart',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF2D2D2D),
                  ),
                ),
              ],
            ),
          ),

          // Cart List
          Expanded(
            child: _cartItems.isEmpty
                ? const Center(
                    child: Text(
                      'Your cart is empty',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    itemCount: _cartItems.length,
                    itemBuilder: (context, index) {
                      return _buildCartItemCard(index);
                    },
                  ),
          ),

          // Bottom Bar
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: const BoxDecoration(color: Colors.white),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/banner.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Center(
                child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItemCard(int index) {
    final item = _cartItems[index];
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Row(
            children: [
              // Product Image
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F9F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(8),
                child: Image.asset(
                  item['image'],
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.fastfood, color: Colors.grey),
                ),
              ),
              const SizedBox(width: 16),
              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          item['name'],
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF2D2D2D),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.edit_note,
                          size: 20,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'EGP ${item['price'].toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF777777),
                      ),
                    ),
                  ],
                ),
              ),
              // Quantity Selector
              Row(
                children: [
                  _buildQtyCircleBtn(
                    Icons.remove,
                    () => _decrementQuantity(index),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      '${item['quantity']}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  _buildQtyCircleBtn(
                    Icons.add,
                    () => _incrementQuantity(index),
                    isPrimary: true,
                  ),
                ],
              ),
            ],
          ),
          // Delete Icon (small orange circle with X)
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: () => _removeItem(index),
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(2),
                child: const Icon(Icons.close, color: Colors.white, size: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQtyCircleBtn(
    IconData icon,
    VoidCallback onTap, {
    bool isPrimary = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          color: isPrimary ? AppColors.primary : const Color(0xFFF2F2F2),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 14,
          color: isPrimary ? Colors.white : Colors.black54,
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: const BoxDecoration(
        color: Color(0xFFEAEAEA),
        border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.home,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF999999),
                    ),
                  ),
                  Text(
                    '${_totalPrice.toStringAsFixed(2)} EGP',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) =>
                      PaymentScreen(items: _cartItems, total: _totalPrice),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Proceed to payment',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
