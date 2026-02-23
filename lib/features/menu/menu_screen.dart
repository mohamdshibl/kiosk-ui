import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../product_detail/product_detail_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int _selectedCategoryIndex = 1;
  final Map<int, int> _cartItems = {}; // Track quantity of each product
  double _totalPrice = 0.0;

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
    _cartItems.forEach((_, quantity) {
      count += quantity;
    });
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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Proceeding to checkout...'),
        duration: Duration(milliseconds: 1500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top Header
            _buildHeader(),

            // Main Content Area
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Categories Sidebar
                  _buildCategoriesSidebar(),

                  // Products Grid
                  Expanded(child: _buildProductsGrid()),
                ],
              ),
            ),

            // Bottom Bar
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: 160,
      color: Colors.white,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Orange Background with Wavy Bottom
          Positioned.fill(
            bottom: 0,
            child: CustomPaint(painter: _HeaderWavePainter()),
          ),

          // Header Content
          Positioned(
            left: 24,
            top: 40,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Fire Fresh',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Fresh & Healthy Food',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),

          // Header Image (Paneer)
          Positioned(
            right: -20,
            top: 10,
            child: Image.asset(
              'assets/images/baneer.png',
              height: 120,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox(
                  height: 120,
                  width: 150,
                  child: Center(
                    child: Icon(
                      Icons.fastfood,
                      size: 60,
                      color: Colors.white54,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesSidebar() {
    return Container(
      width: 100, // Fixed width for sidebar
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
            onTap: () {
              setState(() {
                _selectedCategoryIndex = index;
              });
            },
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
        return Stack(
          children: [
            // Main product card container
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailScreen(product: product),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFEEEEEE),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Image container (grey box)
                    Container(
                      height: 110,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF2F2F2),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                      margin: const EdgeInsets.all(4),
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          // The food plate overlapping boundaries
                          Positioned(
                            top: 10,
                            bottom: 0,
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: Container(
                                  color: Colors.white,
                                  padding: const EdgeInsets.all(4),
                                  child: ClipOval(
                                    child: Image.asset(
                                      product['image'],
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(
                                                Icons.fastfood,
                                                size: 40,
                                                color: Colors.grey,
                                              ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Product Info section
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product['name'],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF2D2D2D),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'EGP ${product['price'].toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF555555),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Floating add/remove button
            Positioned(
              bottom: 12,
              right: 12,
              child: quantity == 0
                  ? GestureDetector(
                      onTap: () => _addToCart(index),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: AppColors.primary,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () => _removeFromCart(index),
                            child: const SizedBox(
                              width: 24,
                              height: 28,
                              child: Icon(
                                Icons.remove,
                                size: 14,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          Container(
                            color: AppColors.primary.withOpacity(0.1),
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Text(
                              quantity.toString(),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _addToCart(index),
                            child: const SizedBox(
                              width: 24,
                              height: 28,
                              child: Icon(
                                Icons.add,
                                size: 14,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8), // Light slightly greyish background
        border: Border(
          top: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Cart icon with badge
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.shopping_cart_outlined,
                    color: AppColors.primary,
                    size: 28,
                  ),
                ),
                if (_getCartItemCount() > 0)
                  Positioned(
                    top: -4,
                    right: -4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        _getCartItemCount().toString(),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),

            // Total cost
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF555555),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      _totalPrice.toStringAsFixed(2),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      ' EGP',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(width: 24),

            // Checkout button
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
      ),
    );
  }
}

class _HeaderWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;

    final path = Path();
    path.lineTo(0, size.height - 30);

    // Create a wavy pattern
    final waveWidth = size.width / 4;
    for (var i = 0; i < 4; i++) {
      path.quadraticBezierTo(
        waveWidth * i + waveWidth / 2,
        (i.isEven) ? size.height : size.height - 60,
        waveWidth * (i + 1),
        size.height - 30,
      );
    }

    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
