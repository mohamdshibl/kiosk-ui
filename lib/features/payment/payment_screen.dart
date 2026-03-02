import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../menu/menu_screen.dart';

enum PaymentStep {
  chooseMethod,
  cashSummary,
  visaSwipe,
  visaDetails,
  orderComplete,
  paymentFailed,
}

enum PaymentMethod { cash, visa }

class PaymentScreen extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final double total;

  const PaymentScreen({super.key, required this.items, required this.total});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen>
    with TickerProviderStateMixin {
  PaymentStep _step = PaymentStep.chooseMethod;
  PaymentMethod _selectedMethod = PaymentMethod.cash;
  final TextEditingController _cardController = TextEditingController();
  late AnimationController _checkAnimController;
  late Animation<double> _checkScaleAnim;

  static const int _orderNumber = 125;

  @override
  void initState() {
    super.initState();
    _checkAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _checkScaleAnim = CurvedAnimation(
      parent: _checkAnimController,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _checkAnimController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  void _continue() {
    setState(() {
      switch (_step) {
        case PaymentStep.chooseMethod:
          _step = _selectedMethod == PaymentMethod.cash
              ? PaymentStep.cashSummary
              : PaymentStep.visaSwipe;
          break;
        case PaymentStep.cashSummary:
          _step = PaymentStep.orderComplete;
          _checkAnimController.forward(from: 0);
          break;
        case PaymentStep.visaSwipe:
          _step = PaymentStep.visaDetails;
          break;
        case PaymentStep.visaDetails:
          // Simulate ~30% chance of failure for demo; in production use real API result
          final failed = _cardController.text.isEmpty;
          if (failed) {
            _step = PaymentStep.paymentFailed;
          } else {
            _step = PaymentStep.orderComplete;
            _checkAnimController.forward(from: 0);
          }
          break;
        case PaymentStep.paymentFailed:
          // Retry — go back to choose method
          _step = PaymentStep.chooseMethod;
          _cardController.clear();
          break;
        case PaymentStep.orderComplete:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: Column(
        children: [
          _buildHeader(),
          if (_step != PaymentStep.orderComplete &&
              _step != PaymentStep.paymentFailed)
            _buildBackRow(),
          Expanded(child: _buildBody()),
          if (_step != PaymentStep.paymentFailed) _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: 160,
      child: Image.asset(
        'assets/images/banner.png',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: AppColors.primary,
          child: const Center(
            child: Text(
              'Fire Fresh',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (_step == PaymentStep.chooseMethod) {
                Navigator.pop(context);
              } else {
                setState(() {
                  switch (_step) {
                    case PaymentStep.cashSummary:
                    case PaymentStep.visaSwipe:
                      _step = PaymentStep.chooseMethod;
                      break;
                    case PaymentStep.visaDetails:
                      _step = PaymentStep.visaSwipe;
                      break;
                    default:
                      break;
                  }
                });
              }
            },
            child: const Icon(
              Icons.arrow_back,
              color: Color(0xFF2D2D2D),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'How would you like to pay?',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xFF2D2D2D),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_step) {
      case PaymentStep.chooseMethod:
        return _buildChooseMethod();
      case PaymentStep.cashSummary:
        return _buildOrderSummary();
      case PaymentStep.visaSwipe:
        return _buildVisaSwipe();
      case PaymentStep.visaDetails:
        return _buildVisaDetails();
      case PaymentStep.orderComplete:
        return _buildOrderComplete();
      case PaymentStep.paymentFailed:
        return _buildPaymentFailed();
    }
  }

  // ── STEP 1: Choose Method ──────────────────────────────
  Widget _buildChooseMethod() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildMethodCard(
                label: 'Cash',
                icon: Icons.payments_outlined,
                selected: _selectedMethod == PaymentMethod.cash,
                onTap: () =>
                    setState(() => _selectedMethod = PaymentMethod.cash),
              ),
              const SizedBox(width: 24),
              _buildMethodCard(
                label: 'Credit Card',
                isVisa: true,
                selected: _selectedMethod == PaymentMethod.visa,
                onTap: () =>
                    setState(() => _selectedMethod = PaymentMethod.visa),
              ),
            ],
          ),
          const SizedBox(height: 28),
          // Order Summary always visible
          _buildOrderSummaryContent(),
        ],
      ),
    );
  }

  Widget _buildMethodCard({
    required String label,
    IconData? icon,
    bool isVisa = false,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 130,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: selected ? AppColors.primary : const Color(0xFFEEEEEE),
                width: selected ? 2 : 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isVisa)
                  const Text(
                    'VISA',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1A1F71),
                      letterSpacing: 1,
                    ),
                  )
                else
                  Icon(icon, size: 40, color: const Color(0xFF555555)),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: selected
                        ? AppColors.primary
                        : const Color(0xFF555555),
                  ),
                ),
              ],
            ),
          ),
          if (selected)
            Positioned(
              top: -8,
              right: -8,
              child: Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 12),
              ),
            ),
        ],
      ),
    );
  }

  // ── STEP 2 (Cash): Order Summary full screen ──────────
  Widget _buildOrderSummary() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: _buildOrderSummaryContent(),
    );
  }

  // ── Reusable order summary content ───────────────────
  Widget _buildOrderSummaryContent() {
    return Column(
      //crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Order Summary:',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: Color(0xFF2D2D2D),
          ),
        ),
        const SizedBox(height: 12),
        ...widget.items.map((item) {
          final total = (item['price'] as double) * (item['quantity'] as int);
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  '${item['quantity']}x ${item['name']}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  '${total.toStringAsFixed(2)} EGP',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // ── STEP 3 (Visa): Swipe Card ─────────────────────────
  Widget _buildVisaSwipe() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          const Text(
            'Please tap, insert or swipe your card!',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF555555),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTerminalIcon(Icons.contactless, 'Tap'),
              const SizedBox(width: 24),
              _buildTerminalIcon(Icons.credit_card, 'Insert'),
              const SizedBox(width: 24),
              _buildTerminalIcon(Icons.swipe, 'Swipe'),
            ],
          ),
          const SizedBox(height: 28),
          _buildOrderSummaryContent(),
        ],
      ),
    );
  }

  Widget _buildTerminalIcon(IconData icon, String label) {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(icon, color: AppColors.primary, size: 32),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Color(0xFF888888),
          ),
        ),
      ],
    );
  }

  // ── STEP 4 (Visa): Card Details ───────────────────────
  Widget _buildVisaDetails() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Credit Card',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Color(0xFF2D2D2D),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFEEEEEE)),
            ),
            child: Row(
              children: [
                const Text(
                  'VISA',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1A1F71),
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _cardController,
                    keyboardType: TextInputType.number,
                    maxLength: 16,
                    decoration: const InputDecoration(
                      hintText: '•••• •••• •••• ••••',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        letterSpacing: 2,
                      ),
                      border: InputBorder.none,
                      counterText: '',
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      letterSpacing: 2,
                      color: Color(0xFF2D2D2D),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildOrderSummaryContent(),
        ],
      ),
    );
  }

  // ── STEP 5: Order Complete ────────────────────────────
  Widget _buildOrderComplete() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _checkScaleAnim,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary, width: 4),
                ),
                child: const Icon(
                  Icons.check,
                  color: AppColors.primary,
                  size: 64,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Order Completed!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Color(0xFF2D2D2D),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _selectedMethod == PaymentMethod.cash
                  ? 'You can receive your receipt and\npay at the counter'
                  : 'You can pick up your order from the cash register',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF888888),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Text(
                    'Your Order Number',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$_orderNumber',
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── PAYMENT FAILED ────────────────────────────────────
  Widget _buildPaymentFailed() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Large orange X
            Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                color: AppColors.primary,
                size: 80,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Payment Failed',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: Color(0xFF2D2D2D),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Please try again!',
              style: TextStyle(fontSize: 14, color: Color(0xFF888888)),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _continue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Try Again',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── BOTTOM BAR ────────────────────────────────────────
  Widget _buildBottomBar() {
    if (_step == PaymentStep.orderComplete) {
      return SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const MenuScreen()),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'New Order',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: const BoxDecoration(
        color: Color(0xFFEAEAEA),
        border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Total
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
                    '${widget.total.toStringAsFixed(2)} EGP',
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
          // Action Button
          ElevatedButton(
            onPressed: _continue,
            style: ElevatedButton.styleFrom(
              backgroundColor: _step == PaymentStep.cashSummary
                  ? Colors.grey.shade400
                  : AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              _step == PaymentStep.cashSummary
                  ? 'Pay at the counter'
                  : 'Continue',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
