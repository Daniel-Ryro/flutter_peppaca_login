import 'package:flutter/material.dart';
import 'package:flutter_caraio/utils/localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../api/api_signin.dart';
import '../utils/typography.dart';
import '../widgets/widget_dialog.dart';
import 'reset_password_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final ApiSignin apiSignin = ApiSignin();
  bool _isPasswordVisible = false;
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _emailError;
  String? _passwordError;
  int _failedLoginAttempts = 0;

  @override
  void dispose() {
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    _clearErrors();

    !_validateInput(email, password)
        ? _updateInputErrors(email, password)
        : await _attemptLogin(email, password);
  }

  bool _validateInput(String email, String password) {
    return email.isNotEmpty && password.isNotEmpty;
  }

  void _clearErrors() {
    setState(() {
      _emailError = null;
      _passwordError = null;
    });
  }

  void _updateInputErrors(String email, String password) {
    setState(() {
      _emailError = email.isEmpty ? 'Email can’t be blank.' : null;
      _passwordError = password.isEmpty ? 'Password can’t be blank.' : null;
    });
  }

  Future<void> _attemptLogin(String email, String password) async {
    try {
      final response = await apiSignin.userSignIn(email, password);

      if (!mounted) return;

      _handleApiResponse(response);
    } catch (e) {
      _handleLoginError(e);
    }
  }

  void _handleApiResponse(Map<String, dynamic> response) {
    response['httpStatus'] == "OK"
        ? ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Login successful!')))
        : _handleApiError(response);
  }

  void _handleApiError(Map<String, dynamic> response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response['httpComment'] ?? 'Error logging in.')));
    _failedLoginAttempts++;
    if (_failedLoginAttempts >= 5) {
      _showLoginAttemptWarning();
      _failedLoginAttempts = 0;
    }
  }

  void _handleLoginError(dynamic error) {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error logging in. Try again later.')));
  }

  void _showLoginAttemptWarning() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const ModernDialog(
          title: "",
          contentItems: [
            "You have made 5 unsuccessful login attempts, reaching the maximum\n"
                "limit. Please try again after one hour.\n\n\n"
                "If you require assistance, please\n"
                "contact Peppaca customer support at support@zenational.com."
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RegisterScreen()),
              );
            },
            child: Text(
              AppLocalizations.of(context)!.translate(
                    'Register',
                  ) ??
                  "Register",
            ),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Text(
                  AppLocalizations.of(context)!.translate(
                        'Welcome Seller',
                      ) ??
                      "Welcome Seller",
                  style: AppTextStyles.title,
                ),
                const SizedBox(height: 50),
                TextFormField(
                  controller: _emailController,
                  onChanged: (value) {
                    setState(() {
                      _emailError = null;
                    });
                  },
                  decoration: InputDecoration(
                    labelText:
                        (AppLocalizations.of(context)!.translate('Email') ??
                            "Email"),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                    errorText: _emailError,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email can’t be blank.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      _passwordError = null;
                    });
                  },
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    errorText: _passwordError,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password can’t be blank.';
                    }
                    return null;
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ChangePassword()),
                      );
                    },
                    child: Text(
                        AppLocalizations.of(context)!.translate(
                              'ForgotPassword',
                            ) ??
                            "Forgot Password?",
                        style: AppTextStyles.link),
                  ),
                ),
                const SizedBox(height: 10),
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: double.infinity,
                    minWidth: double.infinity,
                    minHeight: 56.0,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      handleLogin();
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(AppColors.primaryColor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.translate(
                            'Login',
                          ) ??
                          "Login",
                      style: AppTextStyles.buttonLabel,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Expanded(child: Divider(color: Colors.grey)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text("or", style: AppTextStyles.link),
                    ),
                    const Expanded(child: Divider(color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 20),
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: double.infinity,
                    minWidth: double.infinity,
                    minHeight: 56.0,
                  ),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(AppColors.networkColors),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('TODO: login with google')));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 80.0),
                      child: Row(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: SvgPicture.asset('assets/icons/google.svg',
                                height: 24, width: 24),
                          ),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: Text(
                              AppLocalizations.of(context)!.translate(
                                    'GoogleSignIn',
                                  ) ??
                                  "Continue with google",
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: double.infinity,
                    minWidth: double.infinity,
                    minHeight: 56.0,
                  ),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(AppColors.networkColors),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('TODO: login with facebook')));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 72.0),
                      child: Row(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: SvgPicture.asset('assets/icons/facebook.svg',
                                height: 24, width: 24),
                          ),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: Text(
                              AppLocalizations.of(context)!.translate(
                                    'FacebookSignIn',
                                  ) ??
                                  "Continue with facebook",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: double.infinity,
                    minWidth: double.infinity,
                    minHeight: 56.0,
                  ),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(AppColors.networkColors),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('TODO: login with apple')));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 80.0),
                      child: Row(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: SvgPicture.asset('assets/icons/apple.svg',
                                height: 24, width: 24),
                          ),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: Text(
                              AppLocalizations.of(context)!.translate(
                                    'AppleSignIn',
                                  ) ??
                                  "Continue with Apple",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                      children: [
                        TextSpan(
                          text: AppLocalizations.of(context)!.translate(
                                'TermsSpan0',
                              ) ??
                              "By signing up, you agree to Peppaca’s",
                        ),
                        TextSpan(
                          text: AppLocalizations.of(context)!.translate(
                                'TermsSpan1',
                              ) ??
                              "Terms",
                          style: const TextStyle(
                              decoration: TextDecoration.underline),
                        ),
                        TextSpan(
                          text: AppLocalizations.of(context)!.translate(
                                'TermsSpan2',
                              ) ??
                              ",",
                        ),
                        TextSpan(
                          text: AppLocalizations.of(context)!.translate(
                                'TermsSpan3',
                              ) ??
                              "Privacy Policy",
                          style: const TextStyle(
                              decoration: TextDecoration.underline),
                        ),
                        TextSpan(
                          text: AppLocalizations.of(context)!.translate(
                                'TermsSpan2',
                              ) ??
                              ",",
                        ),
                        TextSpan(
                          text: AppLocalizations.of(context)!.translate(
                                'TermsSpan4',
                              ) ??
                              "\nand",
                        ),
                        TextSpan(
                          text: AppLocalizations.of(context)!.translate(
                                'TermsSpan5',
                              ) ??
                              "Cookie Use",
                          style: const TextStyle(
                              decoration: TextDecoration.underline),
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
