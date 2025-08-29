// app_lock_manager.dart
// Simple biometric lock using local_auth with a secure flag stored locally

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

class AppLockManager {
  AppLockManager._();
  static final AppLockManager instance = AppLockManager._();

  static const _keyEnabled = 'app_lock_enabled';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> isEnabled() async {
    final v = await _storage.read(key: _keyEnabled);
    return v == 'true';
  }

  Future<void> setEnabled(bool enabled) async {
    await _storage.write(key: _keyEnabled, value: enabled ? 'true' : 'false');
  }

  Future<void> enforceLockIfEnabled() async {
    final enabled = await isEnabled();
    if (!enabled) return;
    try {
      final canCheck = await _auth.canCheckBiometrics || await _auth.isDeviceSupported();
      if (!canCheck) return;
      await _auth.authenticate(
        localizedReason: 'Unlock to access your finance data',
        options: const AuthenticationOptions(biometricOnly: false, stickyAuth: true),
      );
    } catch (e) {
      debugPrint('Biometric auth failed: $e');
    }
  }
}

