// lib/screens/auth/login_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // Background
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.purple.withOpacity(0.3),
                    Colors.blue.withOpacity(0.4),
                    Colors.pink.withOpacity(0.3),
                  ],
                ),
              ),
            ),
            Container(color: Colors.black.withOpacity(0.7)),

            // Main login modal
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width > 600 
                    ? 400 
                    : MediaQuery.of(context).size.width * 0.9,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 24),
                        const Text(
                          'Masuk ke TikTok',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pushReplacementNamed(context, '/home'),
                          child: const Icon(Icons.close, color: Colors.white, size: 24),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // QR Code option
                    _buildLoginOption(
                      icon: Icons.qr_code_scanner,
                      title: 'Gunakan kode QR',
                      subtitle: 'Login terakhir',
                      onTap: () {},
                    ),

                    const SizedBox(height: 16),

                    // Phone/Email option
                    _buildLoginOption(
                      icon: Icons.person_outline,
                      title: 'Gunakan nomor telepon/email/nama pengguna',
                      onTap: () => _showPhoneLoginModal(),
                    ),

                    const SizedBox(height: 16),

                    // Social login options
                    _buildSocialLoginOption(
                      icon: Icons.facebook,
                      iconColor: Colors.blue,
                      title: 'Lanjutkan dengan Facebook',
                      onTap: () => _handleSocialLogin('facebook'),
                    ),

                    const SizedBox(height: 16),

                    _buildSocialLoginOption(
                      icon: Icons.g_mobiledata,
                      iconColor: Colors.red,
                      title: 'Lanjutkan dengan Google',
                      onTap: () => _handleSocialLogin('google'),
                    ),

                    const SizedBox(height: 32),

                    // Terms
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(color: Colors.grey[400], fontSize: 11),
                          children: const [
                            TextSpan(text: 'Dengan menggunakan akun yang berlokasi di '),
                            TextSpan(text: 'Indonesia', style: TextStyle(color: Colors.white)),
                            TextSpan(text: ', Anda menyetujui '),
                            TextSpan(text: 'Ketentuan Layanan', style: TextStyle(color: Colors.white)),
                            TextSpan(text: ' kami dan menyatakan bahwa Anda telah membaca '),
                            TextSpan(text: 'Kebijakan Privasi', style: TextStyle(color: Colors.white)),
                            TextSpan(text: ' kami.'),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Register link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Belum memiliki akun? ', style: TextStyle(color: Colors.grey[400], fontSize: 14)),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/register'),
                          child: const Text(
                            'Daftar',
                            style: TextStyle(color: Colors.red, fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginOption({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[700]!, width: 1),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(10)),
                      child: Text(subtitle, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500)),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialLoginOption({
    required IconData icon,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[700]!, width: 1),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 22),
            const SizedBox(width: 16),
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  void _showPhoneLoginModal() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width > 600 ? 400 : null,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  const Text('Login', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                ],
              ),

              const SizedBox(height: 24),

              // Email/Phone input
              const Text('Email atau nomor telepon', style: TextStyle(color: Colors.white, fontSize: 16)),
              const SizedBox(height: 8),
              TextField(
                controller: _phoneController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Masukkan email atau nomor telepon',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                ),
              ),

              const SizedBox(height: 20),

              // Password input
              const Text('Password', style: TextStyle(color: Colors.white, fontSize: 16)),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Masukkan password',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                  suffixIcon: GestureDetector(
                    onTap: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                    child: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.grey[500]),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Login button
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  return SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: authProvider.isLoading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: authProvider.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Masuk', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (_phoneController.text.isEmpty || _passwordController.text.isEmpty) {
      _showMessage('Mohon lengkapi semua field', isError: true);
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    final success = await authProvider.login(_phoneController.text.trim(), _passwordController.text);
    
    if (!mounted) return;
    
    if (success) {
      Navigator.pop(context); // Close modal
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      _showMessage(authProvider.errorMessage ?? 'Login gagal', isError: true);
    }
  }

  void _handleSocialLogin(String provider) {
    // Simulate social login success
    _showMessage('Login dengan $provider berhasil!');
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}