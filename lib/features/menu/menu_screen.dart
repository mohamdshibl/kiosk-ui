import 'dart:async';
import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../cart/cart_screen.dart';
import '../product_detail/product_detail_screen.dart';
import '../tap_to_order/tap_to_order_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int _selectedCategoryIndex = 1;
  final Map<int, int> _cartItems = {};
  double _totalPrice = 0.0;

  // Kiosk timeout
  Timer? _inactivityTimer;
  Timer? _countdownTimer;
  OverlayEntry? _overlayEntry;
  int _countdownValue = 10;
  static const int _inactivitySeconds = 30;
  static const int _countdownSeconds = 10;

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Appetizers', 'icon': Icons.fastfood_outlined},
    {'name': 'Main Dishes', 'icon': Icons.set_meal_outlined},
    {'name': 'Pizzas', 'icon': Icons.local_pizza_outlined},
    {'name': 'Dessert', 'icon': Icons.cake_outlined},
    {'name': 'Hot Drinks', 'icon': Icons.coffee_outlined},
    {'name': 'Cold Drinks', 'icon': Icons.local_drink_outlined},
  ];

  final List<Map<String, dynamic>> _products = [
    {
      'name': 'Main Dish 1',
      'price': 140.00,
      'image': 'assets/images/paneer.png',
    },
    {
      'name': 'Main Dish 2',
      'price': 140.00,
      'image': 'assets/images/paneer.png',
    },
    {
      'name': 'Main Dish 3',
      'price': 140.00,
      'image': 'assets/images/paneer.png',
    },
    {
      'name': 'Main Dish 4',
      'price': 140.00,
      'image': 'assets/images/paneer.png',
    },
    {
      'name': 'Main Dish 5',
      'price': 140.00,
      'image': 'assets/images/paneer.png',
    },
    {
      'name': 'Main Dish 6',
      'price': 140.00,
      'image': 'assets/images/paneer.png',
    },
  ];

  // ── Cart helpers ──────────────────────────────────────

  void _addToCart(int productIndex) {
    setState(() {
      _cartItems[productIndex] = (_cartItems[productIndex] ?? 0) + 1;
      _updateTotal();
    });
  }

  void _removeFromCart(int productIndex) {
    setState(() {
      if (_cartItems.containsKey(productIndex) &&
          _cartItems[productIndex]! > 0) {
        _cartItems[productIndex] = _cartItems[productIndex]! - 1;
        if (_cartItems[productIndex] == 0) {
          _cartItems.remove(productIndex);
        }
      }
      _updateTotal();
    });
  }

  void _updateTotal() {
    _totalPrice = 0.0;
    _cartItems.forEach((productIndex, quantity) {
      _totalPrice += _products[productIndex]['price'] * quantity;
    });
  }

  int _getCartItemCount() {
    int count = 0;
    _cartItems.forEach((_, quantity) => count += quantity);
    return count;
  }

  void _checkout() {
    if (_cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add items to cart before checkout'),
          duration: Duration(milliseconds: 1500),
        ),
      );
      return;
    }
    final List<Map<String, dynamic>> itemsForCart = [];
    _cartItems.forEach((index, quantity) {
      final item = Map<String, dynamic>.from(_products[index]);
      item['quantity'] = quantity;
      itemsForCart.add(item);
    });
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => CartScreen(items: itemsForCart)));
  }

  // ── Kiosk timeout ─────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _resetInactivityTimer();
  }

  @override
  void dispose() {
    _inactivityTimer?.cancel();
    _countdownTimer?.cancel();
    _overlayEntry?.remove();
    super.dispose();
  }

  void _resetInactivityTimer() {
    _inactivityTimer?.cancel();
    _overlayEntry?.remove();
    _overlayEntry = null;
    _inactivityTimer = Timer(
      const Duration(seconds: _inactivitySeconds),
      _showTimeoutOverlay,
    );
  }

  void _showTimeoutOverlay() {
    _countdownValue = _countdownSeconds;
    _overlayEntry = OverlayEntry(
      builder: (ctx) => _TimeoutOverlay(
        countdownValue: _countdownValue,
        onTouch: () {
          _countdownTimer?.cancel();
          _overlayEntry?.remove();
          _overlayEntry = null;
          _resetInactivityTimer();
        },
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);

    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _countdownValue--;
      _overlayEntry?.markNeedsBuild();
      if (_countdownValue <= 0) {
        timer.cancel();
        _overlayEntry?.remove();
        _overlayEntry = null;
        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const TapToOrderScreen()),
            (route) => false,
          );
        }
      }
    });
  }

  // ── Build ─────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => _resetInactivityTimer(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCategoriesSidebar(),
                    Expanded(child: _buildProductsGrid()),
                  ],
                ),
              ),
              _buildBottomBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: const BoxDecoration(color: Colors.white),
      child: Image.asset(
        'assets/images/banner.png',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const Center(
          child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildCategoriesSidebar() {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        physics: const BouncingScrollPhysics(),
        itemCount: _categories.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategoryIndex == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategoryIndex = index),
            child: Container(
              height: 90,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withOpacity(0.1)
                    : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : const Color(0xFFEEEEEE),
                  width: isSelected ? 1.5 : 1,
                ),
                boxShadow: isSelected
                    ? []
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    category['icon'],
                    size: 32,
                    color: isSelected ? AppColors.primary : Colors.grey[600],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category['name'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: isSelected
                          ? FontWeight.w800
                          : FontWeight.w700,
                      color: isSelected
                          ? Colors.black87
                          : const Color(0xFF555555),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductsGrid() {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(8, 16, 20, 100),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.72,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _products.length,
      itemBuilder: (context, index) {
        final product = _products[index];
        final quantity = _cartItems[index] ?? 0;
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ProductDetailScreen(product: product),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9F9F9),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    child: Center(
                      child: Image.asset(
                        product['image'],
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.fastfood,
                              size: 60,
                              color: Colors.grey,
                            ),
                      ),
                    ),
                  ),
                ),
                // Product Info
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product['name'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2D2D2D),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'EGP ${product['price'].toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary.withOpacity(0.8),
                            ),
                          ),
                          // Qty controls
                          if (quantity == 0)
                            GestureDetector(
                              onTap: () => _addToCart(index),
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            )
                          else
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => _removeFromCart(index),
                                  child: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF2F2F2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.remove,
                                      size: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                  ),
                                  child: Text(
                                    '$quantity',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => _addToCart(index),
                                  child: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.add,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Cart icon with badge
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.shopping_cart_outlined,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              if (_getCartItemCount() > 0)
                Positioned(
                  top: -6,
                  right: -6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${_getCartItemCount()}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
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
          const SizedBox(width: 24),
          Expanded(
            child: ElevatedButton(
              onPressed: _checkout,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Checkout',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Kiosk Timeout Overlay ─────────────────────────────────
class _TimeoutOverlay extends StatelessWidget {
  final int countdownValue;
  final VoidCallback onTouch;

  const _TimeoutOverlay({required this.countdownValue, required this.onTouch});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTouch,
      child: Container(
        color: Colors.black.withOpacity(0.75),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Touch anywhere to continue ordering',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'The order will be cancelled in ....',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                '$countdownValue',
                style: const TextStyle(
                  fontSize: 80,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
