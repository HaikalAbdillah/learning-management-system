import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../config/routes.dart';
import '../../core/utils/validators.dart';
import '../../core/constants/assets.dart';
import '../../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Use the AuthService for authentication
      final authService = AuthService();
      final user = await authService.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (mounted) {
        // Show success message briefly
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Welcome back, ${user.name}!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 1),
          ),
        );

        // Navigate to home screen
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          Navigator.pushReplacementNamed(context, AppRoutes.home);
        }
      }
    } on AuthException catch (e) {
      if (mounted) {
        // Show specific error messages based on error code
        String errorMessage = e.message;

        // Customize error messages for better UX
        switch (e.code) {
          case 'USER_NOT_FOUND':
            errorMessage = 'Akun tidak ditemukan. Pastikan email Anda benar.';
            break;
          case 'INVALID_PASSWORD':
            errorMessage = 'Password salah. Silakan coba lagi.';
            break;
          case 'EMPTY_EMAIL':
          case 'EMPTY_PASSWORD':
            errorMessage = 'Email dan password tidak boleh kosong.';
            break;
          case 'INVALID_EMAIL':
            errorMessage = 'Format email tidak valid.';
            break;
          case 'SERVER_ERROR':
            errorMessage = 'Server sedang mengalami gangguan. Coba lagi nanti.';
            break;
          case 'UNKNOWN_ERROR':
          default:
            errorMessage =
                'Terjadi kesalahan. Pastikan koneksi internet Anda stabil.';
            break;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'Coba Lagi',
              textColor: Colors.white,
              onPressed: _login,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login gagal: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showForgotPasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Lupa Password'),
          content: const Text(
            'Hubungi administrator untuk mengatur ulang password Anda.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDemoCredentialsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Demo Credentials (untuk testing):',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          _buildDemoCredentialTile('Admin', 'admin@example.com', 'admin123'),
          const SizedBox(height: 4),
          _buildDemoCredentialTile(
            'Teacher',
            'teacher@example.com',
            'teacher123',
          ),
          const SizedBox(height: 4),
          _buildDemoCredentialTile(
            'Student',
            'student@example.com',
            'student123',
          ),
        ],
      ),
    );
  }

  Widget _buildDemoCredentialTile(String role, String email, String password) {
    return InkWell(
      onTap: () {
        setState(() {
          _emailController.text = email;
          _passwordController.text = password;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            SizedBox(
              width: 60,
              child: Text(
                role,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.blue,
                ),
              ),
            ),
            Expanded(
              child: Text(
                email,
                style: const TextStyle(fontSize: 12, color: Colors.black87),
              ),
            ),
            Text(
              password,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header with curved shape and logo
            Container(
              height: 250,
              decoration: const BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Try to load logo image, fallback to icon if not available
                    FutureBuilder<bool>(
                      future: _checkAssetExists(AppAssets.logo),
                      builder: (context, snapshot) {
                        if (snapshot.data == true) {
                          return AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            child: Image.asset(
                              AppAssets.logo,
                              height: 80,
                              width: 80,
                              color: Colors.white,
                              errorBuilder: (context, error, stackTrace) {
                                return _buildLogoPlaceholder();
                              },
                            ),
                          );
                        } else {
                          return _buildLogoPlaceholder();
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Ce-Loe",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Masuk untuk melanjutkan pembelajaran',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(height: 30),
                    // Email Input
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: Validators.validateEmail,
                      decoration: const InputDecoration(
                        labelText: 'ID / Email',
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Password Input
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      keyboardType: TextInputType.visiblePassword,
                      validator: Validators.validatePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _showForgotPasswordDialog,
                        child: const Text('Lupa Password?'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Text(
                                'MASUK',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.help);
                        },
                        child: const Text('Bantuan?'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Demo credentials section
                    _buildDemoCredentialsSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _checkAssetExists(String assetPath) async {
    try {
      // Simple implementation - for production, you might want to use
      // rootBundle.load(assetPath) to actually check if the asset exists
      // For now, we'll assume common assets exist based on path patterns
      if (assetPath.contains('logo') || assetPath.contains('icon')) {
        return true; // Assume common UI assets exist
      }
      return false; // For other assets, be conservative
    } catch (e) {
      return false;
    }
  }

  Widget _buildLogoPlaceholder() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Icon(Icons.school_outlined, size: 50, color: Colors.white),
    );
  }
}
