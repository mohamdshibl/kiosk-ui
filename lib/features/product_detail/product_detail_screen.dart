import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;
  final Map<String, String> _selectedOptions = {};

  // Sample sides data
  final List<Map<String, dynamic>> _sides = [
    {
      'title': 'Side 1',
      'options': [
        {'name': 'Potato', 'price': 0.0},
        {'name': 'Rice', 'price': 0.0},
        {'name': 'Penne 1', 'price': 5.0},
        {'name': 'Penne 2', 'price': 5.0},
        {'name': 'Penne 3', 'price': 5.0},
        {'name': 'Penne 4', 'price': 5.0},
      ],
      'default': 'Potato',
    },
    {
      'title': 'Side 2',
      'options': [
        {'name': 'French fries', 'price': 0.0},
        {'name': 'Option 2', 'price': 3.0},
        {'name': 'Option 3', 'price': 3.0},
        {'name': 'Big size', 'price': 8.0},
        {'name': 'Medium', 'price': 6.0},
        {'name': 'Medium', 'price': 6.0},
        {'name': 'Option', 'price': 5.0},
      ],
      'default': 'French fries',
    },
  ];

  @override
  void initState() {
    super.initState();
    // Initialize with default selections
    for (final side in _sides) {
      _selectedOptions[side['title']] = side['default'];
    }
  }

  void _addToCart() {
    // TODO: Add to cart with selected options
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added ${_quantity}x ${widget.product['name']} to cart'),
        duration: const Duration(milliseconds: 1500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button and time
            _buildHeader(),

            // Main content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Product image
                    _buildProductImage(),

                    // Product info
                    _buildProductInfo(),

                    // Sides sections
                    ..._buildSideSections(),
                  ],
                ),
              ),
            ),

            // Bottom buttons
            _buildBottomButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back,
              size: 24,
              color: Color(0xFF2D2D2D),
            ),
          ),
          Text(
            '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')} ${DateTime.now().hour >= 12 ? 'PM' : 'AM'}',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                widget.product['image'],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(Icons.fastfood, size: 80, color: Colors.grey),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product['name'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF2D2D2D),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'EGP ${widget.product['price'].toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              // Quantity selector
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary, width: 1.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (_quantity > 1) {
                          setState(() => _quantity--);
                        }
                      },
                      child: const SizedBox(
                        width: 32,
                        height: 32,
                        child: Icon(
                          Icons.remove,
                          size: 14,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    Container(
                      color: AppColors.primary.withOpacity(0.1),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        _quantity.toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() => _quantity++);
                      },
                      child: const SizedBox(
                        width: 32,
                        height: 32,
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
            ],
          ),
          const SizedBox(height: 20),
          Divider(color: Colors.grey.withOpacity(0.3), thickness: 1),
        ],
      ),
    );
  }

  List<Widget> _buildSideSections() {
    return _sides.map((side) {
      final title = side['title'] as String;
      final options = side['options'] as List<Map<String, dynamic>>;
      final selected = _selectedOptions[title] ?? '';

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Side title
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: Color(0xFF2D2D2D),
              ),
            ),
            const SizedBox(height: 12),

            // Options horizontal scroll
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: options.map((option) {
                  final optionName = option['name'] as String;
                  final isSelected = selected == optionName;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedOptions[title] = optionName;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withOpacity(0.1)
                              : Colors.white,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : Colors.grey.withOpacity(0.3),
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Checkbox
                            Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : Colors.grey.withOpacity(0.5),
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(3),
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.transparent,
                              ),
                              child: isSelected
                                  ? const Icon(
                                      Icons.check,
                                      size: 12,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              optionName,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? AppColors.primary
                                    : const Color(0xFF555555),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 12),
            Divider(color: Colors.grey.withOpacity(0.3), thickness: 1),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildBottomButtons() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFEAEAEA),
        border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Back to Menu button
            Expanded(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: AppColors.primary, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'Back to Menu',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Add to cart button
            Expanded(
              child: ElevatedButton(
                onPressed: _addToCart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'Add to cart',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
