// ignore_for_file: unnecessary_import, prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_print, sort_child_properties_last

import 'package:digitalskill/user/Userdashboard/user_dashboard.dart';
import 'package:digitalskill/admin/admindashboard/admin_dashboard.dart';
import 'package:digitalskill/colors/color.dart';
import 'package:digitalskill/loginsignup/signup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false;

  Widget _buildHeader() {
    return Column(
      children: [
        SizedBox(height: 120.0), // Adjust the height as needed
        Text(
          'Login',
          style: TextStyle(
            fontSize: 40.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 10.0),
        Text(
          'Welcome Back!',
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 30.0),
      ],
    );
  }

  Widget _buildTextField({
    required String labelText,
    required bool obscureText,
    required TextEditingController controller,
    required String? Function(String?) validator,
    Widget? suffixIcon,
    IconData? prefixIcon,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle:
            TextStyle(color: Color.fromARGB(255, 175, 183, 230)), // Blue color
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color: Color.fromARGB(255, 175, 183, 230)), // Blue color
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color: Color.fromARGB(255, 175, 183, 230)), // Light blue color
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red), // Red color for errors
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red), // Red color for errors
        ),
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: Color.fromARGB(255, 175, 183, 230))
            : null,
      ),
      obscureText: obscureText,
      validator: validator,
    );
  }

  Widget _buildForgotPasswordButton() {
    return TextButton(
      onPressed: () {
        // Navigate to forgot password screen
        print('Forgot Password pressed!');
      },
      child: Text(
        'Forgot Password?',
        style: TextStyle(color: Color.fromARGB(255, 175, 183, 230)),
      ),
      style: TextButton.styleFrom(
        padding: EdgeInsets.all(0.0),
      ),
    );
  }

  Widget _buildLoginButton(double width) {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          // Form is valid, proceed with login
          _login();
        }
      },
      child: const Text(
        'Login',
        style: TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: width * 0.3, vertical: 20.0),
        backgroundColor: AppColors.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
    );
  }

  void _login() {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email == "admin@gmail.com" && password == "Admin123") {
      // Navigate to admin dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminDashboard()),
      );
    } else if (email == "user@gmail.com" && password == "User123456") {
      // Navigate to user dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UserDashboard()),
      );
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid email or password')),
      );
    }
  }

  Widget _buildLoginForm(double width) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildTextField(
            labelText: 'Enter your email',
            obscureText: false,
            controller: _emailController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
            prefixIcon: Icons.email,
          ),
          SizedBox(height: 20.0),
          _buildTextField(
            labelText: 'Enter your password',
            obscureText: !_passwordVisible,
            controller: _passwordController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
            suffixIcon: IconButton(
              icon: Icon(
                _passwordVisible ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _passwordVisible = !_passwordVisible;
                });
              },
            ),
            prefixIcon: Icons.lock,
          ),
          SizedBox(height: 20.0),
          _buildLoginButton(width),
          _buildForgotPasswordButton(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an account?",
                style: TextStyle(color: Color.fromARGB(255, 175, 183, 230)),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to sign up screen
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignUpScreen()));
                },
                child: Text(
                  ' Sign up',
                  style: TextStyle(color: AppColors.backgroundColor),
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.all(0.0),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        color: AppColors.backgroundColor,
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 30.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: _buildLoginForm(size.width),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
