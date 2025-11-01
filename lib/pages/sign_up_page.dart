import 'package:flutter/material.dart';
import 'package:doctor_gen_app/services/user_service.dart';
import 'package:doctor_gen_app/models/user.dart';
import 'package:intl/intl.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _userService = UserService();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _dobController = TextEditingController();

  String? _selectedGender;
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final newUser = User(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      passwordHash: _passwordController.text.trim(),
      dateOfBirth: _dobController.text.trim(),
      gender: _selectedGender ?? '',
    );

    final success = await _userService.registerUser(newUser);

    setState(() => _isLoading = false);

    if (success > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created successfully!')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email already exists or failed to register.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    'DoctorGen',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 60),
                Text(
                  'Create your account',
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // Full Name
                TextFormField(
                  controller: _nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration('Full Name'),
                  validator:
                      (value) => value!.isEmpty ? 'Enter your name' : null,
                ),
                const SizedBox(height: 20),

                // Email
                TextFormField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration('Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Enter your email';
                    if (!value.contains('@')) return 'Enter a valid email';
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Date of Birth
                TextFormField(
                  controller: _dobController,
                  readOnly: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration('Date of Birth').copyWith(
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.calendar_today,
                        color: Colors.white70,
                      ),
                      onPressed: () => _selectDate(context),
                    ),
                  ),
                  validator:
                      (value) =>
                          value!.isEmpty ? 'Select your date of birth' : null,
                ),
                const SizedBox(height: 20),

                // Gender
                DropdownButtonFormField<String>(
                  value: _selectedGender,
                  dropdownColor: Colors.grey[850],
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration('Gender'),
                  items: const [
                    DropdownMenuItem(value: 'Male', child: Text('Male')),
                    DropdownMenuItem(value: 'Female', child: Text('Female')),
                    DropdownMenuItem(value: 'Other', child: Text('Other')),
                  ],
                  onChanged: (value) => setState(() => _selectedGender = value),
                  validator: (value) => value == null ? 'Select gender' : null,
                ),
                const SizedBox(height: 20),

                // Password
                _passwordField(_passwordController, 'Password'),
                const SizedBox(height: 20),

                // Confirm Password
                _passwordField(
                  _confirmPasswordController,
                  'Confirm Password',
                  confirm: true,
                ),
                const SizedBox(height: 40),

                // Sign Up Button
                ElevatedButton(
                  onPressed: _isLoading ? null : _signUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child:
                      _isLoading
                          ? const CircularProgressIndicator(color: Colors.black)
                          : const Text(
                            'Sign Up',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                ),
                const SizedBox(height: 30),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account?",
                      style: TextStyle(color: Colors.white70),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Log in',
                        style: TextStyle(color: Color(0xff7dd4fb)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white54),
      filled: true,
      fillColor: Colors.grey[850],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _passwordField(
    TextEditingController controller,
    String label, {
    bool confirm = false,
  }) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        TextFormField(
          controller: controller,
          obscureText: !_isPasswordVisible,
          style: const TextStyle(color: Colors.white),
          decoration: _inputDecoration(label),
          validator: (value) {
            if (value == null || value.isEmpty) return 'Enter password';
            if (!confirm && value.length < 6) return 'Password too short';
            if (confirm && value != _passwordController.text)
              return 'Passwords do not match';
            return null;
          },
        ),
        IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.white60,
          ),
          onPressed: () {
            setState(() => _isPasswordVisible = !_isPasswordVisible);
          },
        ),
      ],
    );
  }
}
