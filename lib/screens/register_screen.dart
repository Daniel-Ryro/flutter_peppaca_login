import 'package:flutter/material.dart';

import '../utils/typography.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key})
      : super(key: key); // Corrected the constructor

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> handleRegister() async {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully registered')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Login',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Create your Account', style: AppTextStyles.title),
                const SizedBox(height: 50),
                _buildEmailTextField(),
                const SizedBox(height: 30),
                _buildPasswordTextField(),
                const SizedBox(height: 30),
                _buildConfirmPasswordTextField(),
                const SizedBox(height: 30),
                _buildRegisterButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField _buildEmailTextField() {
    return TextFormField(
      controller: _emailController,
      decoration: _inputDecoration('Email address'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Email can’t be blank.';
        }
        return null;
      },
    );
  }

  TextFormField _buildPasswordTextField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
      decoration: _inputDecoration(
        'Password',
        IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password can’t be blank.';
        }
        return null;
      },
    );
  }

  TextFormField _buildConfirmPasswordTextField() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: !_isPasswordVisible,
      decoration: _inputDecoration(
        'Confirm Password',
        IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Confirm password can’t be blank.';
        }
        if (value != _passwordController.text) {
          return 'Passwords do not match.';
        }
        return null;
      },
    );
  }

  ConstrainedBox _buildRegisterButton() {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: double.infinity,
        minWidth: double.infinity,
        minHeight: 56.0,
      ),
      child: ElevatedButton(
        onPressed: handleRegister,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(AppColors.primaryColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
        ),
        child: Text('Register', style: AppTextStyles.buttonLabel),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, [Widget? suffixIcon]) {
    return InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey, width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
      suffixIcon: suffixIcon,
    );
  }
}
