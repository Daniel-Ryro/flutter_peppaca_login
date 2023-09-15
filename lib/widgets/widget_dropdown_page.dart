import 'package:flutter/material.dart';
import 'package:flutter_caraio/screens/login_screen.dart';
import 'package:flutter_caraio/utils/load_json.dart';
import 'package:flutter_caraio/widgets/widget_dialog.dart';

import '../utils/typography.dart';

class DropdownPage extends StatelessWidget {
  final void Function(String?)? onFirstDropdownChanged;
  final void Function(String?)? onSecondDropdownChanged;

  DropdownPage({
    super.key,
    this.onFirstDropdownChanged,
    this.onSecondDropdownChanged,
  });
  final _questionController = ValueNotifier<String?>(null);
  final _formKey = GlobalKey<FormState>();
  final _answerController = TextEditingController();
  final _dropdownErrorNotifier = ValueNotifier<String?>(null);
  final _incorrectAttemptsNotifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SecureQuestions>(
      future: SecureQuestions.load(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return const Text('Error loading secure questions');
        } else if (!snapshot.hasData ||
            snapshot.data?.questions.isEmpty == true) {
          return const Text('No secure questions available');
        } else {
          final secureQuestions = snapshot.data!;

          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Container(
              width: 400,
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const Icon(
                          Icons.close,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                    Text(
                      'Please answer the security question:',
                      style: AppTextStyles.regularBlack,
                    ),
                    const SizedBox(height: 20),
                    Text.rich(
                      TextSpan(
                        text: 'Select your question ',
                        style: AppTextStyles.boldBlack,
                        children: const [
                          TextSpan(
                            text: '*',
                            style: TextStyle(color: Colors.orange),
                          ),
                        ],
                      ),
                    ),
                    ValueListenableBuilder<String?>(
                      valueListenable: _dropdownErrorNotifier,
                      builder: (context, dropdownError, _) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              border: Border.all(
                                color: dropdownError == null
                                    ? Colors.grey
                                    : Colors.red,
                                width: 1.0,
                              ),
                            ),
                            child: DropdownButtonFormField<String>(
                              value: _questionController.value,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                errorStyle: TextStyle(height: 0),
                              ),
                              isExpanded: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  _dropdownErrorNotifier.value =
                                      'You must select one option.';
                                  return '';
                                }
                                _dropdownErrorNotifier.value = null;
                                return null;
                              },
                              items: secureQuestions.questions.entries
                                  .map((entry) {
                                return DropdownMenuItem<String>(
                                  value: entry.key,
                                  child: Text(entry.value),
                                );
                              }).toList(),
                              onChanged: (value) {
                                _questionController.value = value;
                                _dropdownErrorNotifier.value = null;
                                if (onFirstDropdownChanged != null) {
                                  onFirstDropdownChanged!(value);
                                }
                              },
                            ),
                          ),
                          if (dropdownError != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                dropdownError,
                                style: const TextStyle(
                                    color: Colors.red, fontSize: 12),
                              ),
                            )
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text.rich(
                      TextSpan(
                        text: 'Answer your question ',
                        style: AppTextStyles.boldBlack,
                        children: const [
                          TextSpan(
                            text: '*',
                            style: TextStyle(color: Colors.orange),
                          ),
                        ],
                      ),
                    ),
                    TextFormField(
                      controller: _answerController,
                      onChanged: (value) {
                        _formKey.currentState
                            ?.validate(); // Isso re-validará o campo
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(16.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'The answer doesn’t match.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: () {
                          _dropdownErrorNotifier.value = null;
                          if (_formKey.currentState!.validate()) {
                            Navigator.pop(context, true);
                          } else {
                            _incorrectAttemptsNotifier.value++;
                            if (_incorrectAttemptsNotifier.value >= 5) {
                              Navigator.of(context).pop();
                              showDialog(
                                context: context,
                                builder: (context) => const ModernDialog(
                                  title: "",
                                  contentItems: [
                                    "You have made 5 unsuccessful login attempts, reaching the maximum\n"
                                        "limit. Please try again after one hour.\n\n\n"
                                        "If you require assistance, please\n"
                                        "contact Peppaca customer support at support@zenational.com.",
                                  ],
                                ),
                              );
                              _incorrectAttemptsNotifier.value = 0;
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20),
                          backgroundColor: AppColors.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        child: Text(
                          'Submit',
                          style: AppTextStyles.regularWhite,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
