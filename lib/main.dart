import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app/theme/app_theme.dart';
import 'features/tap_to_order/tap_to_order_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait for kiosk display
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Hide system UI for kiosk mode
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(const KioskApp());
}

class KioskApp extends StatelessWidget {
  const KioskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kiosk',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const TapToOrderScreen(),
    );
  }
}
