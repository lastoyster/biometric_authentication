import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthApi {
  static final _auth = LocalAuthentication();

  static Future<bool> hasBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print("Error checking biometrics: $e");
      return false;
    }
  }

  static Future<List<BiometricType>> getBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print("Error getting available biometrics: $e");
      return <BiometricType>[];
    }
  }

  static Future<bool> authenticate() async {
    final isAvailable = await hasBiometrics();
    if (!isAvailable) return false;

    try {
      return await authenticateWithBiometrics();
    } on PlatformException catch (e) {
      print("Error authenticating with biometrics: $e");
      return false;
    }
  }

  static Future<bool> authenticateWithBiometrics() async {
    try {
      // ignore: unused_local_variable
      var bool = await _auth.authenticate(
        localizedReason: 'Scan Fingerprint to Authenticate',
        useErrorDialogs: true,
        stickyAuth: true,
      );
      return true;
    } on PlatformException catch (e) {
      print("Error authenticating with biometrics: $e");
      return false;
    }
  }
}
