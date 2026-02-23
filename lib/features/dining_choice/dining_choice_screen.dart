import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../menu/menu_screen.dart';

class DiningChoiceScreen extends StatefulWidget {
  const DiningChoiceScreen({super.key});

  @override
  State<DiningChoiceScreen> createState() => _DiningChoiceScreenState();
}

class _DiningChoiceScreenState extends State<DiningChoiceScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _slideController;
  late final Animation<Offset> _cardSlideLeft;
  late final Animation<Offset> _cardSlideRight;
  late final Animation<double> _fadeAnimation;

  String _selectedLanguage = 'English';

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _cardSlideLeft =
        Tween<Offset>(begin: const Offset(-1.0, 0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _slideController,
            curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
          ),
        );

    _cardSlideRight =
        Tween<Offset>(begin: const Offset(1.0, 0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _slideController,
            curve: const Interval(0.3, 0.9, curve: Curves.easeOutCubic),
          ),
        );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _slideController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  void _onTakeAway() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const MenuScreen()));
  }

  void _onEatHere() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const MenuScreen()));
  }

  void _onLanguageChanged(String language) {
    setState(() {
      _selectedLanguage = language;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final boundaryY = constraints.maxHeight * (6 / 13);
            return Stack(
              children: [
                Column(
                  children: [
                    // Top white section with logo, question
                    Expanded(
                      flex: 6,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Center(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 24),

                                // Logo
                                _buildLogo(),

                                const SizedBox(height: 24),

                                // Question text
                                FadeTransition(
                                  opacity: _fadeAnimation,
                                  child: const Text(
                                    'Where will you be eating today?',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF2D2D2D),
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 48),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Bottom orange section with burgers image and language buttons
                    Expanded(flex: 7, child: _buildBottomSection()),
                  ],
                ),

                // Option cards row positioned on the wave
                Positioned(
                  top: boundaryY,
                  left: 24,
                  right: 24,
                  child: FractionalTranslation(
                    translation: const Offset(0, -0.55),
                    child: _buildOptionCards(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: [
          // Logo icon
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.restaurant_menu,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(height: 10),
          // Brand name
          const Text(
            'KIOSK',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: AppColors.primary,
              letterSpacing: 4,
            ),
          ),
          const Text(
            'Restaurant management software',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xFF999999),
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCards() {
    return Row(
      children: [
        // Take Away card
        Expanded(
          child: SlideTransition(
            position: _cardSlideLeft,
            child: _buildOptionCard(
              icon: Icons.shopping_bag_outlined,
              title: 'Take Away',
              description:
                  'Busy day? We\'ll pack your\nmeal for you to take away',
              onTap: _onTakeAway,
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Eat Here card
        Expanded(
          child: SlideTransition(
            position: _cardSlideRight,
            child: _buildOptionCard(
              icon: Icons.restaurant_outlined,
              title: 'Eat Here',
              description: 'Enjoy your meal in our\ncomfy seating area',
              onTap: _onEatHere,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOptionCard({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE8E8E8), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon container
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: AppColors.primary, size: 26),
            ),
            const SizedBox(height: 14),
            // Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2D2D2D),
              ),
            ),
            const SizedBox(height: 8),
            // Description
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: Color(0xFF999999),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSection() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(color: AppColors.primary),
      child: Stack(
        children: [
          // Wavy white decoration at top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              size: const Size(double.infinity, 50),
              painter: _WavePainter(),
            ),
          ),

          // Burgers image centered
          Positioned.fill(
            top: 100,
            bottom: 70,
            child: Image.asset(
              'assets/images/burgers.png',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(Icons.fastfood, size: 80, color: Colors.white38),
                );
              },
            ),
          ),

          // Language buttons at the bottom
          Positioned(
            left: 24,
            right: 24,
            bottom: 20,
            child: Row(
              children: [
                Expanded(
                  child: _buildLanguageButton(
                    label: 'English',
                    flag: '🇺🇸',
                    isSelected: _selectedLanguage == 'English',
                    onTap: () => _onLanguageChanged('English'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildLanguageButton(
                    label: 'Arabic',
                    flag: '🇪🇬',
                    isSelected: _selectedLanguage == 'Arabic',
                    onTap: () => _onLanguageChanged('Arabic'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageButton({
    required String label,
    required String flag,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? Colors.white
                : Colors.white.withValues(alpha: 0.4),
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(flag, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isSelected ? AppColors.primary : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height);

    // Smooth convex upward arc covering the orange background
    path.quadraticBezierTo(
      size.width / 2,
      -size.height,
      size.width,
      size.height,
    );

    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
