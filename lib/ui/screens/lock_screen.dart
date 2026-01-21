import 'package:flutter/material.dart';
import '../../logic/services/auth_service.dart';

class LockScreen extends StatefulWidget {
  final VoidCallback onAuthenticated;

  const LockScreen({super.key, required this.onAuthenticated});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final AuthService _authService = AuthService();
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    if (await _authService.canCheckBiometrics()) {
      _authenticate();
    } else {
      // If no biometrics available, bypass lock or use PIN?
      // For MVP, if no biometrics, we bypass.
      widget.onAuthenticated();
    }
  }

  Future<void> _authenticate() async {
    setState(() => _isAuthenticating = true);
    final isAuthenticated = await _authService.authenticate();
    if (mounted) {
      setState(() => _isAuthenticating = false);
      if (isAuthenticated) {
        widget.onAuthenticated();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock_outline,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'PsicoLog Protegido',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 48),
            if (!_isAuthenticating)
              FilledButton.icon(
                onPressed: _authenticate,
                icon: const Icon(Icons.fingerprint),
                label: const Text('DESBLOQUEAR'),
              ),
            if (_isAuthenticating) const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
