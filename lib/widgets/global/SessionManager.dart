import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:total_energies/screens/Auth/loginPage.dart';

class SessionManager extends StatefulWidget {
  final Widget child;
  final Duration timeoutDuration;

  const SessionManager({
    super.key,
    required this.child,
    this.timeoutDuration = const Duration(minutes: 20), // default 5 min
  });

  @override
  State<SessionManager> createState() => _SessionManagerState();
}

class _SessionManagerState extends State<SessionManager> {
  Timer? _inactivityTimer;

  @override
  void initState() {
    super.initState();
    _resetTimer();
  }

  void _resetTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(widget.timeoutDuration, _handleTimeout);
  }

  void _handleTimeout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // log out user

    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  void dispose() {
    _inactivityTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      // Reset timer whenever the user interacts
      onPointerDown: (_) => _resetTimer(),
      child: widget.child,
    );
  }
}
