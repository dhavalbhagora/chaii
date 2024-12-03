import 'dart:convert';

import 'package:chaii/Colors/Color.dart';
import 'package:chaii/Screen/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController shopNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // Track password conditions
  bool hasUpperCase = false;
  bool hasLowerCase = false;
  bool hasNumeric = false;
  bool hasSpecialChar = false;
  bool hasMinLength = false;

  // Update conditions as the password changes
  void _updatePasswordConditions(String password) {
    setState(() {
      hasUpperCase = RegExp(r'[A-Z]').hasMatch(password);
      hasLowerCase = RegExp(r'[a-z]').hasMatch(password);
      hasNumeric = RegExp(r'[0-9]').hasMatch(password);
      hasSpecialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);
      hasMinLength = password.length >= 8;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: MyColors.primaryColor,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: const Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: MyColors.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: const Text(
                    'Fill the details below to register your shop.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 30),
                _buildTextField(
                  controller: emailController,
                  label: 'Email',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: shopNameController,
                  label: 'Shop Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your shop name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _buildPasswordField(
                  controller: passwordController,
                  label: 'Password',
                  isPasswordVisible: _isPasswordVisible,
                  onToggleVisibility: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (!hasMinLength ||
                        !hasUpperCase ||
                        !hasLowerCase ||
                        !hasNumeric ||
                        !hasSpecialChar) {
                      return 'Password does not meet the required criteria.';
                    }
                    return null;
                  },
                  onChanged: _updatePasswordConditions,
                ),
                const SizedBox(height: 20),
                _buildPasswordField(
                  controller: confirmPasswordController,
                  label: 'Confirm Password',
                  isPasswordVisible: _isConfirmPasswordVisible,
                  onToggleVisibility: () {
                    setState(() {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.primaryColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final email = emailController.text.trim();
                        final shopName = shopNameController.text.trim();
                        final password = passwordController.text.trim();
                        register(email, shopName, password);
                      }
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Password conditions
                Text(
                  'Password must contain:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                _buildConditionRow('At least 8 characters', hasMinLength),
                _buildConditionRow(
                    'At least one uppercase letter', hasUpperCase),
                _buildConditionRow(
                    'At least one lowercase letter', hasLowerCase),
                _buildConditionRow('At least one numeric digit', hasNumeric),
                _buildConditionRow(
                    'At least one special character', hasSpecialChar),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool obscureText = false,
    required String? Function(String?) validator,
    Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.w500,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: MyColors.primaryColor,
            width: 2,
          ),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool isPasswordVisible,
    required VoidCallback onToggleVisibility,
    required String? Function(String?) validator,
    Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !isPasswordVisible,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.w500,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: onToggleVisibility,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: MyColors.primaryColor,
            width: 2,
          ),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildConditionRow(String condition, bool isMet) {
    return Row(
      children: [
        Icon(
          isMet ? Icons.check_circle : Icons.cancel,
          color: isMet ? Colors.green : Colors.red,
          size: 20,
        ),
        const SizedBox(width: 10),
        Text(condition),
      ],
    );
  }

  Future<void> register(String email, String shopName, String password) async {
    final url = Uri.parse(
        'https://prakrutitech.buzz/Dhaval/register.php'); // API endpoint

    try {
      final response = await http.post(
        url,
        body: {
          'email': email,
          'shopname': shopName,
          'password': password,
        },
      );

      final data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        print('Registration successful! Welcome: ${data['shopname']}');
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      } else {
        print('Error: ${data['message']}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
