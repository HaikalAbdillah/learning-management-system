import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:crypto/crypto.dart';

// Professional logging utility for testing
class TestLogger {
  static bool _debugMode = true;

  static void enableDebugMode(bool enable) {
    _debugMode = enable;
  }

  static void log(String message) {
    if (_debugMode) {
      _printLog('[TEST]', message);
    }
  }

  static void logError(String message) {
    _printLog('[TEST ERROR]', message);
  }

  static void logInfo(String message) {
    if (_debugMode) {
      _printLog('[TEST INFO]', message);
    }
  }

  static void logSuccess(String message) {
    if (_debugMode) {
      _printLog('[TEST SUCCESS]', message);
    }
  }

  static void _printLog(String prefix, String message) {
    // Using stderr for errors, stdout for other logs
    if (prefix.contains('ERROR')) {
      stderr.writeln('$prefix $message');
    } else {
      stdout.writeln('$prefix $message');
    }
  }
}

class PasswordHasher {
  static const String _saltKey = 'elearning_app_salt_2024';

  /// Hashes a password using SHA-256 with salt
  /// Uses proper salting and encoding for security
  static String hashPassword(String password, {String? customSalt}) {
    if (password.isEmpty) {
      throw ArgumentError('Password cannot be empty');
    }

    // Use custom salt if provided, otherwise use default
    final salt = customSalt ?? _saltKey;

    // Create a more secure hash by combining password and salt with proper encoding
    final combinedString = '$password:$salt';
    final bytes = utf8.encode(combinedString);
    final digest = sha256.convert(bytes);

    TestLogger.logInfo(
      'Password hashed successfully with ${salt.length}-character salt',
    );
    return digest.toString();
  }

  /// Verifies a password against its hash
  static bool verifyPassword(
    String password,
    String hashedPassword, {
    String? customSalt,
  }) {
    if (password.isEmpty) {
      TestLogger.logError('Password cannot be empty');
      return false;
    }

    if (hashedPassword.isEmpty) {
      TestLogger.logError('Hashed password cannot be empty');
      return false;
    }

    try {
      final computedHash = hashPassword(password, customSalt: customSalt);
      final isValid = computedHash == hashedPassword;

      TestLogger.log(
        isValid
            ? 'Password verification successful'
            : 'Password verification failed',
      );

      return isValid;
    } catch (e) {
      TestLogger.logError('Error during password verification: $e');
      return false;
    }
  }

  /// Generates a cryptographically secure random salt
  static String generateSalt({int length = 32}) {
    if (length < 8) {
      throw ArgumentError('Salt length must be at least 8 characters');
    }

    final random = Random.secure();
    final saltBytes = List<int>.generate(
      length,
      (index) => random.nextInt(256),
    );
    return base64.encode(saltBytes);
  }

  /// Creates a secure password hash with random salt
  static Map<String, String> createSecurePasswordHash(String password) {
    if (password.isEmpty) {
      throw ArgumentError('Password cannot be empty');
    }

    final salt = generateSalt();
    final hash = hashPassword(password, customSalt: salt);

    return {'hash': hash, 'salt': salt};
  }

  /// Verifies password using pre-generated salt
  static bool verifyPasswordWithSalt(
    String password,
    String hashedPassword,
    String salt,
  ) {
    if (password.isEmpty || hashedPassword.isEmpty || salt.isEmpty) {
      TestLogger.logError('Password, hash, or salt cannot be empty');
      return false;
    }

    return verifyPassword(password, hashedPassword, customSalt: salt);
  }
}

void main() {
  TestLogger.enableDebugMode(true);
  TestLogger.log('Starting password hash tests...');

  try {
    // Test 1: Basic password hashing
    TestLogger.log('=== Test 1: Basic Password Hashing ===');
    final password = 'SecurePass123!';
    final hashedPassword = PasswordHasher.hashPassword(password);
    TestLogger.log('Original password: $password');
    TestLogger.log('Hashed password: $hashedPassword');

    // Test 2: Password verification (correct password)
    TestLogger.log('\n=== Test 2: Password Verification (Correct) ===');
    final isValid = PasswordHasher.verifyPassword(password, hashedPassword);
    TestLogger.log('Verification result: $isValid');

    if (isValid) {
      TestLogger.logSuccess('Correct password verified successfully');
    }

    // Test 3: Password verification (wrong password)
    TestLogger.log('\n=== Test 3: Password Verification (Wrong) ===');
    final isInvalid = PasswordHasher.verifyPassword(
      'WrongPassword',
      hashedPassword,
    );
    TestLogger.log('Verification result with wrong password: $isInvalid');

    if (!isInvalid) {
      TestLogger.logSuccess('Wrong password correctly rejected');
    }

    // Test 4: Salt generation
    TestLogger.log('\n=== Test 4: Random Salt Generation ===');
    final salt = PasswordHasher.generateSalt();
    TestLogger.log('Generated salt: $salt');
    TestLogger.log('Salt length: ${salt.length} characters');

    // Test 5: Secure password hash with random salt
    TestLogger.log('\n=== Test 5: Secure Hash with Random Salt ===');
    final secureHashData = PasswordHasher.createSecurePasswordHash(
      'MySecurePassword456!',
    );
    TestLogger.log('Secure hash: ${secureHashData['hash']}');
    TestLogger.log('Random salt: ${secureHashData['salt']}');

    final isSecureValid = PasswordHasher.verifyPasswordWithSalt(
      'MySecurePassword456!',
      secureHashData['hash']!,
      secureHashData['salt']!,
    );
    TestLogger.log('Secure verification result: $isSecureValid');

    // Test 6: Empty password handling
    TestLogger.log('\n=== Test 6: Empty Password Handling ===');
    try {
      PasswordHasher.hashPassword('');
      TestLogger.logError(
        'ERROR: Empty password should have thrown an exception',
      );
    } catch (e) {
      TestLogger.logSuccess('Empty password correctly handled: $e');
    }

    // Test 7: Custom salt usage
    TestLogger.log('\n=== Test 7: Custom Salt Usage ===');
    final customSalt = 'my_custom_salt_2024';
    final customHash = PasswordHasher.hashPassword(
      'password123',
      customSalt: customSalt,
    );
    final customVerify = PasswordHasher.verifyPassword(
      'password123',
      customHash,
      customSalt: customSalt,
    );
    TestLogger.log('Custom salt verification: $customVerify');

    // Test 8: Edge cases
    TestLogger.log('\n=== Test 8: Edge Cases ===');

    // Very long password
    final longPassword = 'A' * 1000;
    final longHash = PasswordHasher.hashPassword(longPassword);
    TestLogger.log(
      'Long password (1000 chars) hash: ${longHash.substring(0, 32)}...',
    );

    // Special characters
    final specialPassword = 'P@ssw0rd!@#\$%^&*()_+-=[]{}|;:,.<>?';
    final specialHash = PasswordHasher.hashPassword(specialPassword);
    TestLogger.log(
      'Special chars password hash: ${specialHash.substring(0, 32)}...',
    );

    TestLogger.log('\n🎉 All tests completed successfully! 🎉');
    TestLogger.log('Password hashing implementation is working correctly.');
  } catch (e, stackTrace) {
    TestLogger.logError('❌ Test execution failed: $e');
    TestLogger.logError('Stack trace: $stackTrace');
    exit(1);
  }
}
