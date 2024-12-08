import 'package:flutter/material.dart';

import 'package:nfc_01/utils/auth.dart'; // Import the auth.dart file

import 'main_screen.dart'; // Import the main screen to navigate after successful login

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false; // To show loading state during login

// Function to handle login

  Future<void> _handleLogin() async {
    String username = _usernameController.text;

    String password = _passwordController.text;

    setState(() {
      _isLoading = true; // Start loading
    });

    bool success = await Auth.login(username, password);

    setState(() {
      _isLoading = false; // Stop loading
    });

    if (success) {
// If login is successful, navigate to the main screen

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } else {
// If login failed, show an error message

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid username or password')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
// Adding the logo

            Image.asset(
              'assets/images/logo_fb.png', // Đảm bảo không có khoảng trắng dư thừa và chỉ định đúng định dạng tệp (ví dụ .png, .jpg)
              height: 100,
            ),


            const SizedBox(height: 20),

            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),

            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),

            const SizedBox(height: 20),

            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _handleLogin,
                    child: const Text('Log In'),
                  ),
          ],
        ),
      ),
    );
  }
}
