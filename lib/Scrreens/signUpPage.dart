import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _email;
  String? _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          // Navy blue gradient background
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade900,  // Navy Blue
              Colors.blue.shade500,  // Lighter Blue
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Sign Up Title with Navy Accent
                  Text(
                    '𝕊𝕀𝔾ℕ 𝕌ℙ',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      fontSize: 36,
                    ),
                  ),
                  SizedBox(height: 30),

                  // Name Field with Navy Blue Gradient Border
                  _buildGradientTextField(
                    label: 'Name',
                    icon: Icons.person,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _name = value;
                    },
                  ),
                  SizedBox(height: 20),

                  // Email Field with Navy Blue Gradient Border
                  _buildGradientTextField(
                    label: 'Email',
                    icon: Icons.email,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _email = value;
                    },
                  ),
                  SizedBox(height: 20),

                  // Password Field with Navy Blue Gradient Border
                  _buildGradientTextField(
                    label: 'Password',
                    icon: Icons.lock,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      } else if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _password = value;
                    },
                  ),
                  SizedBox(height: 30),

                  // Gradient Sign Up Button
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade900, Colors.blue.shade600],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shadowColor: Colors.black.withOpacity(0.3),
                        elevation: 5,
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Sign Up Successful!\nName: $_name\nEmail: $_email',
                              ),
                            ),
                          );
                        }
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Navigate to Login Page
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(color: Colors.white),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.yellowAccent,
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
        ),
      ),
    );
  }

  // Custom TextField with Navy Gradient Border
  Widget _buildGradientTextField({
    required String label,
    required IconData icon,
    bool obscureText = false,
    required String? Function(String?) validator,
    required void Function(String?) onSaved,
  }) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade800, Colors.blue.shade600],  // Navy gradient border
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.all(2),  // Padding for gradient
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),  // Background color
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextFormField(
              style: TextStyle(color: Colors.white),
              obscureText: obscureText,
              decoration: InputDecoration(
                labelText: label,
                labelStyle: TextStyle(color: Colors.white),
                prefixIcon: Icon(icon, color: Colors.white),
                border: InputBorder.none,  // No default border
                contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 18),
              ),
              validator: validator,
              onSaved: onSaved,
            ),
          ),
        ),
      ],
    );
  }
}
