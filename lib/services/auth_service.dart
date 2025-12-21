import 'package:flutter/foundation.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import '../models/user.dart';

class AuthException implements Exception {
  final String message;
  final String code;
  final int? statusCode;

  const AuthException({
    required this.message,
    required this.code,
    this.statusCode,
  });

  @override
  String toString() => 'AuthException($code): $message';
}

class AuthService {
  // Note: Currently using mock authentication data
  // For real API implementation, uncomment and configure these:
  // static const String _baseUrl = 'https://api.example.com';
  // static const Duration _timeout = Duration(seconds: 10);

  // Mock users for demonstration - In production, replace with API calls
  static final List<Map<String, dynamic>> _mockUsers = [
    {
      'id': '1',
      'email': 'admin@example.com',
      'password':
          '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', // admin123 (SHA-256)
      'name': 'Administrator',
      'role': 'admin',
      'createdAt': '2024-01-01T00:00:00Z',
    },
    {
      'id': '2',
      'email': 'teacher@example.com',
      'password':
          'cde383eee8ee7a4400adf7a15f716f179a2eb97646b37e089eb8d6d04e663416', // teacher123 (SHA-256)
      'name': 'John Teacher',
      'role': 'teacher',
      'createdAt': '2024-01-02T00:00:00Z',
    },
    {
      'id': '3',
      'email': 'student@example.com',
      'password':
          '703b0a3d6ad75b649a28adde7d83c6251da457549263bc7ff45ec709b0a8448b', // student123 (SHA-256)
      'name': 'Jane Student',
      'role': 'student',
      'createdAt': '2024-01-03T00:00:00Z',
    },
  ];

  /// Login user with email and password
  ///
  /// [email] - User's email or username
  /// [password] - User's password
  ///
  /// Returns [User] object on successful login
  ///
  /// Throws [AuthException] on authentication failure
  Future<User> login(String email, String password) async {
    try {
      // Input validation
      if (email.trim().isEmpty) {
        throw const AuthException(
          message: 'Email cannot be empty',
          code: 'EMPTY_EMAIL',
        );
      }

      if (password.isEmpty) {
        throw const AuthException(
          message: 'Password cannot be empty',
          code: 'EMPTY_PASSWORD',
        );
      }

      if (!_isValidEmail(email)) {
        throw const AuthException(
          message: 'Please enter a valid email address',
          code: 'INVALID_EMAIL',
        );
      }

      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 800));

      // For demonstration, we'll use mock data
      // In production, replace this with actual HTTP POST request
      final user = await _authenticateWithMockData(email, password);

      return user;
    } on AuthException {
      rethrow;
    } catch (e) {
      throw const AuthException(
        message: 'An unexpected error occurred. Please try again.',
        code: 'UNKNOWN_ERROR',
      );
    }
  }

  /// Authenticate using mock data (replace with real API in production)
  Future<User> _authenticateWithMockData(String email, String password) async {
    // Hash the input password for comparison
    final hashedPassword = _hashPassword(password);

    final userData = _mockUsers.firstWhere(
      (user) => user['email'] == email && user['password'] == hashedPassword,
      orElse: () => {},
    );

    if (userData.isEmpty) {
      // More specific error messages based on the attempt
      final userExists = _mockUsers.any((user) => user['email'] == email);

      if (!userExists) {
        throw const AuthException(
          message: 'Email not found. Please check your email address.',
          code: 'USER_NOT_FOUND',
        );
      } else {
        throw const AuthException(
          message: 'Incorrect password. Please try again.',
          code: 'INVALID_PASSWORD',
        );
      }
    }

    // Create User object and update last login
    final userJson = Map<String, dynamic>.from(userData);
    userJson['lastLoginAt'] = DateTime.now().toIso8601String();

    return User.fromJson(userJson);
  }

  /// Real API implementation example (commented out for now)
  /*
  Future<User> _authenticateWithAPI(String email, String password) async {
    // Configure these when implementing real API:
    // static const String _baseUrl = 'https://api.example.com';
    // static const Duration _timeout = Duration(seconds: 10);
    
    final response = await http.post(
      Uri.parse('YOUR_API_URL/auth/login'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    ).timeout(Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      
      if (data['success'] == true && data['data'] != null) {
        return User.fromJson(data['data']);
      } else {
        throw AuthException(
          message: data['message'] ?? 'Login failed',
          code: data['code'] ?? 'LOGIN_FAILED',
          statusCode: response.statusCode,
        );
      }
    } else if (response.statusCode == 401) {
      throw const AuthException(
        message: 'Invalid email or password',
        code: 'INVALID_CREDENTIALS',
        statusCode: 401,
      );
    } else if (response.statusCode == 422) {
      throw const AuthException(
        message: 'Invalid input data',
        code: 'VALIDATION_ERROR',
        statusCode: 422,
      );
    } else {
      throw AuthException(
        message: 'Server error. Please try again later.',
        code: 'SERVER_ERROR',
        statusCode: response.statusCode,
      );
    }
  }
  */

  /// Logout user (clear session, token, etc.)
  Future<void> logout() async {
    try {
      // In production, implement token revocation on the server
      // await http.post(Uri.parse('YOUR_API_URL/auth/logout'));

      // Clear any stored tokens or session data
      // await _storage.deleteToken();

      // Simulate logout delay
      await Future.delayed(const Duration(milliseconds: 300));
    } catch (e) {
      // Logout should not throw errors in most cases
      if (kDebugMode) {
        debugPrint('Logout error: $e');
      }
    }
  }

  /// Check if user is currently logged in
  ///
  /// In production, this would check for valid tokens, etc.
  Future<bool> isLoggedIn() async {
    try {
      // Check for stored tokens or session data
      // final token = await _storage.getToken();
      // return token != null && !_isTokenExpired(token);

      // For now, return false (not logged in)
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Get current user information
  ///
  /// In production, this would fetch user data using stored token
  Future<User?> getCurrentUser() async {
    try {
      // final token = await _storage.getToken();
      // if (token != null && !_isTokenExpired(token)) {
      //   // Configure API URL when implementing:
      //   final response = await http.get(
      //     Uri.parse('YOUR_API_URL/auth/me'),
      //     headers: {'Authorization': 'Bearer $token'},
      //   );
      //   if (response.statusCode == 200) {
      //     final data = jsonDecode(response.body);
      //     return User.fromJson(data['data']);
      //   }
      // }

      return null;
    } catch (e) {
      return null;
    }
  }

  /// Validate email format
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  /// Hash password using SHA-256
  ///
  /// Note: For production use, consider using bcrypt or Argon2
  /// with proper salt generation. This implementation uses SHA-256
  /// for demonstration purposes.
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Check password strength
  /// Returns true if password meets minimum requirements
  bool isPasswordStrong(String password) {
    if (password.length < 6) return false;

    // At least one uppercase, one lowercase, one number
    final hasUpper = password.contains(RegExp(r'[A-Z]'));
    final hasLower = password.contains(RegExp(r'[a-z]'));
    final hasNumber = password.contains(RegExp(r'[0-9]'));

    return hasUpper && hasLower && hasNumber;
  }

  /// Get password strength feedback
  String getPasswordStrengthFeedback(String password) {
    if (password.length < 6) {
      return 'Password must be at least 6 characters long';
    }

    final feedback = <String>[];
    if (!password.contains(RegExp(r'[A-Z]'))) {
      feedback.add('Add at least one uppercase letter');
    }
    if (!password.contains(RegExp(r'[a-z]'))) {
      feedback.add('Add at least one lowercase letter');
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      feedback.add('Add at least one number');
    }

    if (feedback.isEmpty) {
      return 'Strong password';
    }

    return feedback.join(', ');
  }
}
