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
  String _selectedCookingMethod = 'Method 1';
  String _selectedExtras = 'Medium';
  List<String> _removedToppings = [];
  bool _isMeal = true;
  final double _mealPrice = 29.99;

  void _showSelectionDialog({
    required String title,
    required String subtitle,
    required List<String> options,
    required List<String> currentValues,
    required Function(List<String>) onSelected,
    bool isMultiSelect = false,
  }) {
    List<String> tempSelected = List.from(currentValues);
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF2D2D2D),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                subtitle,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF777777),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close, color: Colors.black54),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Flexible(
                      child: SingleChildScrollView(
                        child: Column(
                          children: options.map((option) {
                            final isSelected = tempSelected.contains(option);
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: InkWell(
                                onTap: () {
                                  setDialogState(() {
                                    if (!isMultiSelect) {
                                      tempSelected = [option];
                                    } else {
                                      if (isSelected) {
                                        tempSelected.remove(option);
                                      } else {
                                        tempSelected.add(option);
                                      }
                                    }
                                  });
                                  if (!isMultiSelect) {
                                    onSelected(tempSelected);
                                    Navigator.pop(context);
                                  }
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: const Color(0xFFEEEEEE),
                                      width: 1.5,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        option,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF444444),
                                        ),
                                      ),
                                      Container(
                                        width: 22,
                                        height: 22,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: isSelected
                                                ? AppColors.primary
                                                : const Color(0xFFDDDDDD),
                                            width: 2,
                                          ),
                                          color: isSelected
                                              ? AppColors.primary
                                              : Colors.transparent,
                                        ),
                                        child: isSelected
                                            ? const Icon(
                                                Icons.circle,
                                                size: 10,
                                                color: Colors.white,
                                              )
                                            : null,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          onSelected(tempSelected);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Confirm Selection',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  double _calculateTotal() {
    double total = widget.product['price'] * _quantity;
    if (_isMeal) {
      total += _mealPrice * _quantity;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black54),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Choosing Item',
          style: TextStyle(
            color: Color(0xFF777777),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Summary Card
                  _buildProductSummaryCard(),
                  const SizedBox(height: 20),

                  // Options sections
                  _buildOptionSelectionRow(
                    title: 'Cooking Method',
                    isRequired: true,
                    currentValue: _selectedCookingMethod,
                    onTap: () => _showSelectionDialog(
                      title: 'Choose your Cooking Method',
                      subtitle: 'Required • Select one option',
                      options: ['Method 1', 'Method 2', 'Method 3', 'Method 4'],
                      currentValues: [_selectedCookingMethod],
                      onSelected: (val) =>
                          setState(() => _selectedCookingMethod = val.first),
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildOptionSelectionRow(
                    title: 'Extras',
                    isRequired: false,
                    currentValue: _selectedExtras,
                    onTap: () => _showSelectionDialog(
                      title: 'Extras...',
                      subtitle: 'Optional • Select extras',
                      options: ['Medium', 'Large', 'Extra Large'],
                      currentValues: [_selectedExtras],
                      onSelected: (val) =>
                          setState(() => _selectedExtras = val.first),
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildOptionSelectionRow(
                    title: 'Remove Ingredients',
                    isRequired: false,
                    currentValue: _removedToppings.isEmpty
                        ? 'None'
                        : _removedToppings.join(', '),
                    onTap: () => _showSelectionDialog(
                      title: 'Remove Toppings...',
                      subtitle: 'Optional • Select toppings to remove',
                      isMultiSelect: true,
                      options: [
                        'Lettuce',
                        'Onion',
                        'Pickles',
                        'Cheddar Slice',
                        'Beef Bacon',
                        'Tomatoes',
                      ],
                      currentValues: _removedToppings,
                      onSelected: (val) =>
                          setState(() => _removedToppings = val),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Meal selection
                  _buildMealSelectionCard(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Bottom Bar
          _buildBottomActionBar(),
        ],
      ),
    );
  }

  Widget _buildProductSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFFF9F9F9),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(8),
            child: Image.asset(
              widget.product['image'],
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.fastfood, size: 40, color: Colors.grey),
            ),
          ),
          const SizedBox(width: 16),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.product['name'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF2D2D2D),
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: widget.product['price'].toStringAsFixed(2),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                          ),
                          const TextSpan(
                            text: ' EGP',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'A juicy, grilled beef patty nestled between two toasted burger buns, layered with crisp lettuce and fresh tomato slices. Topped with a slice of melted cheddar cheese and a generous dollop of creamy mayonnaise',
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFF999999),
                    height: 1.4,
                  ),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                // Quantity Selector
                Row(
                  children: [
                    _buildQtyBtn(Icons.remove, () {
                      if (_quantity > 1) setState(() => _quantity--);
                    }),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        '$_quantity',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    _buildQtyBtn(
                      Icons.add,
                      () => setState(() => _quantity++),
                      isPrimary: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQtyBtn(
    IconData icon,
    VoidCallback onTap, {
    bool isPrimary = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isPrimary ? AppColors.primary : const Color(0xFFF2F2F2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 18,
          color: isPrimary ? Colors.white : Colors.black54,
        ),
      ),
    );
  }

  Widget _buildOptionSelectionRow({
    required String title,
    required bool isRequired,
    required String currentValue,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title (${isRequired ? "Required" : "Optional"})',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2D2D2D),
            ),
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF9F9F9),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFEEEEEE)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    currentValue,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF555555),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Text(
                    'Change >',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF999999),
                      fontWeight: FontWeight.w500,
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

  Widget _buildMealSelectionCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Make it a meal? (Required)',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2D2D2D),
                ),
              ),
              Icon(Icons.keyboard_arrow_up, color: Colors.black54),
            ],
          ),
          const SizedBox(height: 16),
          _buildMealOption(
            title: 'Yes, meal please',
            price: '+EGP 29.99',
            isSelected: _isMeal,
            onTap: () => setState(() => _isMeal = true),
          ),
          const SizedBox(height: 12),
          _buildMealOption(
            title: 'No, just the main',
            price: '',
            isSelected: !_isMeal,
            onTap: () => setState(() => _isMeal = false),
          ),
        ],
      ),
    );
  }

  Widget _buildMealOption({
    required String title,
    required String price,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? AppColors.primary : const Color(0xFFDDDDDD),
                width: 2,
              ),
            ),
            padding: const EdgeInsets.all(3),
            child: isSelected
                ? Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected
                  ? const Color(0xFF2D2D2D)
                  : const Color(0xFF777777),
            ),
          ),
          const Spacer(),
          if (price.isNotEmpty)
            Text(
              price,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF777777),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFE5E5E5), width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 18),
              ),
              child: const Text(
                'Cancel order',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Added to cart')));
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 18),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_bag, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    '${_calculateTotal().toStringAsFixed(2)} EGP',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                  const VerticalDivider(color: Colors.white54, width: 20),
                  const Text(
                    'Add to cart',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
