import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'utils/app_colors.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:revivegoods/api_url.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _signUp() async {
    var urlSignup = ApiUrl.SignUpUrl;
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      print('Sending request...');
      final response = await http.post(
        Uri.parse(urlSignup),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'name': _nameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseData['message'] ?? 'Registration successful!'),
            backgroundColor: Colors.green,
          ),
        );
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseData['message'] ?? 'Registration failed.'),
            backgroundColor: Colors.red,
          ),
        );
      }

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              // App logo/name
              Center(
                child: Column(
                  children: const [
                    Text(
                      'Revive Goods',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'From You, For Good',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 60),

              // Login form
              const Text(
                'Sign up',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),

              const SizedBox(height: 24),

              // Name field
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter your name',
                  prefixIcon: const Icon(Icons.email, color: AppColors.primary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primary, width: 2),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              // Email field
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  prefixIcon: const Icon(Icons.email, color: AppColors.primary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primary, width: 2),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 16),

              // Password field
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  prefixIcon: const Icon(Icons.lock, color: AppColors.primary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primary, width: 2),
                  ),
                ),
                obscureText: true,
              ),

              const SizedBox(height: 12),

              // Confirm Password field
              TextField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  hintText: 'Confirm your password',
                  prefixIcon: const Icon(Icons.lock, color: AppColors.primary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primary, width: 2),
                  ),
                ),
                obscureText: true,
              ),

              const SizedBox(height: 24),

              // Login button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _signUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : const Text(
                    'Sign up',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Sign up link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account? ",
                    style: TextStyle(
                      color: AppColors.textGrey,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                      );
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
