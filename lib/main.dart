import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app/theme/app_theme.dart';
import 'features/timeout/timeout_screen.dart';
import 'features/tap_to_order/tap_to_order_screen.dart';
import 'app/services/inactivity_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const KioskApp());
}

class KioskApp extends StatefulWidget {
  const KioskApp({super.key});

  @override
  State<KioskApp> createState() => _KioskAppState();
}

class _KioskAppState extends State<KioskApp> {
  final InactivityService _service = InactivityService();
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _service.addListener(_onServiceUpdate);
    _service.resetTimer();
  }

  @override
  void dispose() {
    _service.removeListener(_onServiceUpdate);
    _service.dispose();
    super.dispose();
  }

  void _onServiceUpdate() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => _service.resetTimer(),
      behavior: HitTestBehavior.translucent,
      child: MaterialApp(
        navigatorKey: _navigatorKey,
        title: 'Kiosk',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        builder: (context, child) {
          return Stack(
            children: [
              if (child != null) child,
              if (_service.isTimeoutActive)
                TimeoutScreen(
                  onContinue: () => _service.dismissTimeout(),
                  onTimeout: () {
                    _service.completeTimeout();
                    _navigatorKey.currentState?.pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (_) => const TapToOrderScreen(),
                      ),
                      (route) => false,
                    );
                  },
                ),
            ],
          );
        },
        home: const TapToOrderScreen(),
      ),
    );
  }
}
