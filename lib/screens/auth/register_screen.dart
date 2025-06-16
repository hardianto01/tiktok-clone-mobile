// lib/screens/auth/register_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
 // Ganti bagian build method di RegisterScreen
@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.black,
    body: SafeArea( // Tambah SafeArea
      child: Stack(
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

          // Main register modal
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width > 600 
                  ? 380  // Kurangi dari 400 ke 380
                  : MediaQuery.of(context).size.width * 0.85, // Kurangi dari 0.9 ke 0.85
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.9,
              ),
              margin: const EdgeInsets.symmetric(horizontal: 16), // Tambah margin
              padding: const EdgeInsets.all(20), // Kurangi dari 24 ke 20
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Row(
                      children: [
                        const SizedBox(width: 24),
                        const Expanded( // Gunakan Expanded untuk mencegah overflow
                          child: Text(
                            'Mendaftar TikTok',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18, // Kurangi dari 20 ke 18
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis, // Tambah overflow handling
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.close, color: Colors.white, size: 24),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24), // Kurangi dari 32 ke 24

                    // Email/Phone option
                    _buildRegisterOption(
                      icon: Icons.person_outline,
                      title: 'Gunakan nomor telepon atau alamat email',
                      onTap: () => _showEmailRegisterModal(),
                    ),

                    // Rest of the options dengan spacing yang dikurangi
                    const SizedBox(height: 12), // Kurangi dari 16 ke 12
                    _buildSocialRegisterOption(
                      icon: Icons.facebook,
                      iconColor: Colors.blue,
                      title: 'Lanjutkan dengan Facebook',
                      onTap: () {},
                    ),

                    const SizedBox(height: 12),
                    _buildSocialRegisterOption(
                      icon: Icons.g_mobiledata,
                      iconColor: Colors.red,
                      title: 'Lanjutkan dengan Google',
                      onTap: () {},
                    ),

                    const SizedBox(height: 12),
                    _buildSocialRegisterOption(
                      icon: Icons.chat_bubble_outline,
                      iconColor: Colors.green,
                      title: 'Lanjutkan dengan LINE',
                      onTap: () {},
                    ),

                    const SizedBox(height: 12),
                    _buildSocialRegisterOption(
                      icon: Icons.chat,
                      iconColor: Colors.yellow[700]!,
                      title: 'Lanjutkan dengan KakaoTalk',
                      onTap: () {},
                    ),

                    const SizedBox(height: 24), // Kurangi dari 32 ke 24

                    // Terms - dengan proper container
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 4), // Kurangi padding
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(color: Colors.grey[400], fontSize: 10), // Kurangi font
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

                    const SizedBox(height: 20), // Kurangi dari 24 ke 20

                    // Login link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Sudah memiliki akun? ',
                          style: TextStyle(color: Colors.grey[400], fontSize: 13), // Kurangi font
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Text(
                            'Masuk',
                            style: TextStyle(color: Colors.red, fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

 Widget _buildRegisterOption({
  required IconData icon,
  required String title,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12), // Kurangi padding
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[700]!, width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20), // Kurangi icon size
          const SizedBox(width: 12), // Kurangi spacing
          Expanded( // Gunakan Expanded untuk mencegah overflow
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white, 
                fontSize: 14, // Kurangi font size
                fontWeight: FontWeight.w600
              ),
              overflow: TextOverflow.ellipsis, // Handle overflow
              maxLines: 1,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildSocialRegisterOption({
  required IconData icon,
  required Color iconColor,
  required String title,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12), // Kurangi padding
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[700]!, width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 20), // Kurangi icon size
          const SizedBox(width: 12), // Kurangi spacing
          Expanded( // Gunakan Expanded untuk mencegah overflow
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white, 
                fontSize: 14, // Kurangi font size
                fontWeight: FontWeight.w500
              ),
              overflow: TextOverflow.ellipsis, // Handle overflow
              maxLines: 1,
            ),
          ),
        ],
      ),
    ),
  );
}


void _showEmailRegisterModal() {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16), // Tambah inset padding
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 380, // Fixed max width yang lebih kecil
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16), // Kurangi padding lagi
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(12),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header yang compact
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    const Flexible( // Ganti Expanded dengan Flexible
                      child: Text(
                        'Daftar',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Username field
                const Text('Username', style: TextStyle(color: Colors.white, fontSize: 14)),
                const SizedBox(height: 6),
                TextField(
                  controller: _usernameController,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Masukkan username',
                    hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
                    filled: true,
                    fillColor: Colors.grey[800],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6), 
                      borderSide: BorderSide.none
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    isDense: true, // Tambah isDense
                  ),
                ),

                const SizedBox(height: 16),

                // Email field
                const Text('Email atau nomor telepon', 
                  style: TextStyle(color: Colors.white, fontSize: 14)
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Email atau nomor',
                    hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
                    filled: true,
                    fillColor: Colors.grey[800],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6), 
                      borderSide: BorderSide.none
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    isDense: true,
                  ),
                ),

                const SizedBox(height: 16),

                // Password field
                const Text('Password', style: TextStyle(color: Colors.white, fontSize: 14)),
                const SizedBox(height: 6),
                TextField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Min. 8 karakter',
                    hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
                    filled: true,
                    fillColor: Colors.grey[800],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6), 
                      borderSide: BorderSide.none
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    isDense: true,
                    suffixIcon: GestureDetector(
                      onTap: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          _isPasswordVisible ? Icons.visibility : Icons.visibility_off, 
                          color: Colors.grey[500],
                          size: 18,
                        ),
                      ),
                    ),
                    suffixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 40), // Batasi ukuran icon
                  ),
                ),

                const SizedBox(height: 16),

                // Confirm Password field
                const Text('Konfirmasi Password', style: TextStyle(color: Colors.white, fontSize: 14)),
                const SizedBox(height: 6),
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: !_isConfirmPasswordVisible,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Konfirmasi password',
                    hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
                    filled: true,
                    fillColor: Colors.grey[800],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6), 
                      borderSide: BorderSide.none
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    isDense: true,
                    suffixIcon: GestureDetector(
                      onTap: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off, 
                          color: Colors.grey[500],
                          size: 18,
                        ),
                      ),
                    ),
                    suffixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                  ),
                ),

                const SizedBox(height: 8),

                // Password requirements - lebih compact
                Text(
                  '• Min. 8 karakter\n• Kombinasi huruf & angka',
                  style: TextStyle(color: Colors.grey[500], fontSize: 11),
                ),

                const SizedBox(height: 24),

                // Register button
                SizedBox(
                  width: double.infinity,
                  height: 44, // Kurangi tinggi button
                  child: Consumer<AuthProvider>(
                    builder: (context, authProvider, child) {
                      return ElevatedButton(
                        onPressed: authProvider.isLoading ? null : _handleRegister,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        ),
                        child: authProvider.isLoading
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Daftar',
                                style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

  Future<void> _handleRegister() async {
  // Validation
  if (_usernameController.text.isEmpty || 
      _emailController.text.isEmpty || 
      _passwordController.text.isEmpty || 
      _confirmPasswordController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mohon lengkapi semua field'), backgroundColor: Colors.red),
    );
    return;
  }

  if (_passwordController.text.length < 8) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Password minimal 8 karakter'), backgroundColor: Colors.red),
    );
    return;
  }

  if (_passwordController.text != _confirmPasswordController.text) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Password tidak sama'), backgroundColor: Colors.red),
    );
    return;
  }

  // Email validation
  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(_emailController.text) &&
      !RegExp(r'^[0-9]{10,13}$').hasMatch(_emailController.text)) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Format email atau nomor telepon tidak valid'), backgroundColor: Colors.red),
    );
    return;
  }

  // Use AuthProvider for actual registration
  final authProvider = Provider.of<AuthProvider>(context, listen: false);
  
  final success = await authProvider.register(
    username: _usernameController.text.trim(),
    email: _emailController.text.trim(),
    password: _passwordController.text,
    passwordConfirmation: _confirmPasswordController.text,
  );

  if (!mounted) return;

  if (success) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pendaftaran berhasil!'), backgroundColor: Colors.green),
    );
    Navigator.pop(context); // Close modal
    Navigator.pushReplacementNamed(context, '/home');
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(authProvider.errorMessage ?? 'Pendaftaran gagal'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}