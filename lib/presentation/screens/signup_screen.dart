import 'package:flow/core/common/custom.button.dart';
import 'package:flow/core/common/custom_text_field.dart';
import 'package:flow/data/repositories/auth_repository.dart';
import 'package:flow/data/services/service_locator.dart';
import 'package:flow/presentation/screens/auth/login_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  final _nameFocus = FocusNode();
  final _usernameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _passwordFocus = FocusNode();

  @override
  void dispose() {
    nameController.dispose();
    userNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    _nameFocus.dispose();
    _usernameFocus.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your full name ';
    }
    return null;
  }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your username ';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email address ';
    }
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    );
    if (!emailRegex.hasMatch(value)) {
      return "Please enter valid email address ( e.g., example@gmail.com)";
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }

    // Must be exactly 10 digits
    if (!RegExp(r'^\d{10}$').hasMatch(value)) {
      return 'Phone number must be 10 digits';
    }

    return null; // Valid
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }

    return null;
  }

  Future<void> handleSignup() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() ?? false) {
      try {
        getIt<AuthRepository>().signUp(
          fullName: nameController.text,
          username: userNameController.text,
          email: emailController.text,
          phoneNumber: phoneController.text,
          password: passwordController.text,
        );
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } else {
      print('form validation failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),

                Text(
                  'Create Account',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Please fill in the details to continue',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                ),
                SizedBox(height: 30),
                CustomTextField(
                  controller: nameController,
                  hintText: 'Full Name',
                  preficIcon: Icon(Icons.person_2_outlined),
                  focusNode: _nameFocus,
                  validator: _validateName,
                ),
                SizedBox(height: 16),
                CustomTextField(
                  controller: userNameController,
                  hintText: 'Username',
                  preficIcon: Icon(Icons.alternate_email),
                  focusNode: _usernameFocus,
                  validator: _validateUsername,
                ),
                SizedBox(height: 16),
                CustomTextField(
                  controller: emailController,
                  hintText: 'Email',
                  preficIcon: Icon(Icons.email_outlined),
                  focusNode: _emailFocus,
                  validator: _validateEmail,
                ),
                SizedBox(height: 16),
                CustomTextField(
                  controller: phoneController,
                  hintText: 'Phone Number',
                  preficIcon: Icon(Icons.phone_outlined),
                  focusNode: _phoneFocus,
                  validator: _validatePhone,
                ),
                SizedBox(height: 16),
                CustomTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: !_isPasswordVisible,
                  preficIcon: Icon(Icons.lock_open_outlined),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                    icon: _isPasswordVisible
                        ? Icon(Icons.visibility_off)
                        : Icon(Icons.visibility),
                  ),
                  focusNode: _passwordFocus,
                  validator: _validatePassword,
                ),
                SizedBox(height: 30),
                CustomButton(onPressed: handleSignup, text: 'Create Account'),
                SizedBox(height: 20),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: "Already have an account? ",
                      style: TextStyle(color: Colors.grey[600]),
                      children: [
                        TextSpan(
                          text: 'Login',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pop(context);
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
