import 'package:flutter/material.dart';
import 'package:flutter_caraio/widgets/ballon_dialog.dart';
import '../api/api_signin.dart';
import '../utils/commun.dart';
import '../utils/typography.dart';
import '../widgets/widget_dropdown_page.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _currentEmailController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isPasswordVisible = false;
  final apiSignin = ApiSignin();
  final GlobalKey _passwordFieldKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  final FocusNode _passwordFocusNode = FocusNode();
  String? _emailError;
  String? _newPasswordError;
  String? _confirmPasswordError;

  @override
  void initState() {
    super.initState();
    _passwordFocusNode.addListener(_hideBalloonOnFocusLoss);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      FocusScope.of(context).addListener(_focusChangeHandler);
    });
  }

  @override
  void dispose() {
    _passwordFocusNode.removeListener(_hideBalloonOnFocusLoss);
    FocusScope.of(context).removeListener(_focusChangeHandler);
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _hideBalloonOnFocusLoss() {
    if (!_passwordFocusNode.hasFocus &&
        ValidationUtil.passwordMeetsRequirements(_newPasswordController.text)) {
      _removeBalloon();
    }
    if (!_passwordFocusNode.hasFocus) _removeBalloon();
  }

  void _focusChangeHandler() {
    if (!_passwordFocusNode.hasFocus) {
      _removeBalloon();
    }
  }

  void _showBalloon() {
    _removeBalloon();

    _overlayEntry = OverlayEntry(
      builder: (context) => PasswordBalloon(
        passwordFieldKey: _passwordFieldKey,
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeBalloon() {
    if (_overlayEntry == null) {
      return;
    }
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _hideBalloon() => _removeBalloon();
  void _clearFields() {
    _currentEmailController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();
  }

  Future<void> _changePassword() async {
    final userName = _currentEmailController.text;
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;
    setState(() {
      _emailError = null;
      _newPasswordError = null;
      _confirmPasswordError = null;
    });

    if (_currentEmailController.text.isEmpty) {
      setState(() {
        _emailError = 'Email address cannot be blank!';
      });
      return;
    }
    if (!ValidationUtil.isValidEmail(_currentEmailController.text)) {
      setState(() {
        _emailError = 'Please enter a valid email address!';
      });
      return;
    }

    if (_newPasswordController.text.isEmpty) {
      setState(() {
        _newPasswordError = 'New password cannot be blank!';
      });
      return;
    }

    if (newPassword != confirmPassword) {
      setState(() {
        _confirmPasswordError = 'Password doesn’t match.';
      });
      return;
    }

    final result = await _showDropdownDialog();

    if (result == true) {
      try {
        final responseChange =
            await apiSignin.resetPassword(userName, newPassword);
        if (responseChange['httpStatus'] == 'OK') {
          _showSnackbar('Password changed successfully!');
        } else {
          _showSnackbar(
              responseChange['httpComment'] ?? 'Error changing password!');
        }
      } catch (e) {
        _showSnackbar('Error changing password. Please try again later.');
      }
    }
    _clearFields();
  }

  Future<bool?> _showDropdownDialog() async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return DropdownPage(
          onFirstDropdownChanged: (value) {
            // Handle the first dropdown changed value if necessary
          },
          onSecondDropdownChanged: (value) {
            // Handle the second dropdown changed value if necessary
          },
        );
      },
    );
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void areFieldsValid() {
    // Reset all error messages first
    setState(() {
      _emailError = null;
      _newPasswordError = null;
      _confirmPasswordError = null;
    });

    if (_currentEmailController.text.isEmpty) {
      setState(() {
        _emailError = 'Email address cannot be blank!';
      });
      return;
    }

    if (!ValidationUtil.isValidEmail(_currentEmailController.text)) {
      setState(() {
        _emailError = 'Please enter a valid email address!';
      });
      return;
    }

    if (_newPasswordController.text.isEmpty) {
      setState(() {
        _newPasswordError = 'New password cannot be blank!';
      });
      return;
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      setState(() {
        _confirmPasswordError = 'Passwords don’t match.';
      });
      return;
    }

    if (!ValidationUtil.passwordMeetsRequirements(
        _newPasswordController.text)) {
      setState(() {
        _newPasswordError = 'The password does not meet the required criteria.';
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _hideBalloon();
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 50),
              _buildHeader(),
              const SizedBox(height: 20),
              _buildEmailField(),
              const SizedBox(height: 40.0),
              _buildPasswordField(),
              const SizedBox(height: 40.0),
              _buildConfirmPasswordField(),
              const SizedBox(height: 30.0),
              _buildUpdateButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        Text(
          'Change the password',
          textAlign: TextAlign.left,
          style: AppTextStyles.boldBlack,
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return _buildTextField(
      controller: _currentEmailController,
      labelText: 'Email address',
      errorText: _emailError,
    );
  }

  Widget _buildPasswordField() {
    return _buildTextField(
      focusNode: _passwordFocusNode,
      key: _passwordFieldKey,
      controller: _newPasswordController,
      labelText: 'New password',
      isObscure: !_isPasswordVisible,
      onTap: _showBalloon,
      onChanged: (text) {
        if (!ValidationUtil.passwordMeetsRequirements(text)) {
          _showBalloon();
        } else {
          _hideBalloon();
        }
      },
      suffixIcon: IconButton(
        icon:
            Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
        onPressed: () =>
            setState(() => _isPasswordVisible = !_isPasswordVisible),
      ),
      errorText: _newPasswordError,
    );
  }

  Widget _buildConfirmPasswordField() {
    return _buildTextField(
      controller: _confirmPasswordController,
      labelText: 'Confirm new password',
      isObscure: true,
      errorText: _confirmPasswordError,
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    String? errorText,
    FocusNode? focusNode,
    bool isObscure = false,
    Widget? suffixIcon,
    void Function()? onTap,
    void Function(String)? onChanged,
    Key? key,
  }) {
    return TextFormField(
      key: key,
      focusNode: focusNode,
      controller: controller,
      obscureText: isObscure,
      decoration: InputDecoration(
        labelText: labelText,
        errorText: errorText,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        suffixIcon: suffixIcon,
      ),
      onTap: onTap,
      onChanged: onChanged,
    );
  }

  Widget _buildUpdateButton() {
    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ElevatedButton(
          onPressed: _handleUpdatePress,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(AppColors.primaryColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
            padding: MaterialStateProperty.all<EdgeInsets>(
              const EdgeInsets.symmetric(vertical: 16.0, horizontal: 70.0),
            ),
            textStyle: MaterialStateProperty.all<TextStyle>(
              const TextStyle(fontSize: 18.0),
            ),
          ),
          child: Text('Update', style: AppTextStyles.regularWhite),
        ),
      ),
    );
  }

  void _handleUpdatePress() {
    areFieldsValid();
    if (_emailError == null &&
        _newPasswordError == null &&
        _confirmPasswordError == null) {
      _changePassword();
    }
  }
}
