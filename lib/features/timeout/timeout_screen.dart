import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';

class TimeoutScreen extends StatefulWidget {
  final int initialCountdown;
  final VoidCallback onContinue;
  final VoidCallback onTimeout;

  const TimeoutScreen({
    super.key,
    this.initialCountdown = 10,
    required this.onContinue,
    required this.onTimeout,
  });

  @override
  State<TimeoutScreen> createState() => _TimeoutScreenState();
}

class _TimeoutScreenState extends State<TimeoutScreen>
    with SingleTickerProviderStateMixin {
  late int _countdownValue;
  Timer? _timer;
  late AnimationController _pulseController;
  late Animation<double> _pulseScale;
  late Animation<double> _pulseOpacity;

  @override
  void initState() {
    super.initState();
    _countdownValue = widget.initialCountdown;

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _pulseScale = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _pulseOpacity = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_countdownValue > 0) {
          _countdownValue--;
        } else {
          timer.cancel();
          widget.onTimeout();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: widget.onContinue,
        behavior: HitTestBehavior.opaque,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withOpacity(0.8),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated "Touch" hint icon
                  Icon(
                    Icons.touch_app,
                    color: Colors.white.withOpacity(0.5),
                    size: 64,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Touch anywhere to continue',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -0.5,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'The order will be cancelled in $_countdownValue seconds',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Big pulse countdown number
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseScale.value,
                        child: Opacity(
                          opacity: _pulseOpacity.value,
                          child: Text(
                            '$_countdownValue',
                            style: const TextStyle(
                              fontSize: 140,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              height: 1,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
