import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class AuthService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> canCheckBiometrics() async {
    try {
      final canCheck = await _auth.canCheckBiometrics;
      final isDeviceSupported = await _auth.isDeviceSupported();
      return canCheck && isDeviceSupported;
    } on PlatformException catch (_) {
      return false;
    }
  }

  Future<bool> authenticate() async {
    try {
      if (!await canCheckBiometrics()) return false;

      return await _auth.authenticate(
        localizedReason: 'Autentique-se para acessar o PsicoLog',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false, // Allows PIN/Pattern as fallback
        ),
      );
    } on PlatformException catch (_) {
      return false;
    }
  }
}
