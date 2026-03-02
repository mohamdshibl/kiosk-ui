import 'dart:async';
import 'package:flutter/material.dart';

class InactivityService extends ChangeNotifier {
  static final InactivityService _instance = InactivityService._internal();
  factory InactivityService() => _instance;
  InactivityService._internal();

  Timer? _inactivityTimer;
  bool _isTimeoutActive = false;
  static const int inactivityDuration = 30; // 30 seconds

  bool get isTimeoutActive => _isTimeoutActive;

  void resetTimer() {
    if (_isTimeoutActive) return;
    _stopTimer();
    _startTimer();
  }

  void _startTimer() {
    _inactivityTimer = Timer(const Duration(seconds: inactivityDuration), () {
      _isTimeoutActive = true;
      notifyListeners();
    });
  }

  void _stopTimer() {
    _inactivityTimer?.cancel();
  }

  void dismissTimeout() {
    _isTimeoutActive = false;
    resetTimer();
    notifyListeners();
  }

  void completeTimeout() {
    _isTimeoutActive = false;
    _stopTimer();
    notifyListeners();
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }
}
