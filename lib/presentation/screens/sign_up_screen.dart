import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/custom_text_field.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController =
      TextEditingController(); // Second password field
  late SharedPreferences prefs;
  final _formKey = GlobalKey<FormState>(); // Form key for validation

  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      String email = emailController.text.trim();
      String password = passwordController.text;

      // Retrieve existing user data from SharedPreferences
      List<String>? userList = prefs.getStringList('users');
      if (userList == null) {
        userList = [];
      }

      // Check if user with the provided email already exists
      bool userExists = userList.contains(email);
      if (userExists) {
        // If user already exists, show error message
        var showSnackBar = ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('User with this email already exists. '
              'Please use a different email.'),
          backgroundColor: Colors.red,
        ));
        return;
      }

      // Add new user to the list of registered users
      userList.add(email);
      prefs.setStringList('users', userList);

      // Store new user's credentials in SharedPreferences
      prefs.setString('email_$email', email);
      prefs.setString('password_$email', password);

      // Navigate to login screen after successful sign up
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );

      print('Sign Up Successful');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          // Wrap form with Form widget
          key: _formKey, // Assign the form key
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                controller: emailController,
                labelText: 'Email',
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[\w-]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  if (prefs.getString('email') == value) {
                    // Check if email already exists
                    return 'User with this email already exists.'
                        ' Please use a different email.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              CustomTextField(
                controller: passwordController,
                labelText: 'Password',
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 8) {
                    return 'Password must be at least 8 characters long';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              CustomTextField(
                controller: confirmPasswordController,
                labelText: 'Confirm Password',
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please re-enter your password';
                  }
                  if (value != passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: _signUp,
                child: Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
