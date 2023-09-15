import 'package:flutter/material.dart';
import 'package:flutter_caraio/utils/load_json.dart';

import '../utils/typography.dart';

class DropdownPage extends StatelessWidget {
  final void Function(String?)? onFirstDropdownChanged;
  final void Function(String?)? onSecondDropdownChanged;

  const DropdownPage({
    super.key,
    this.onFirstDropdownChanged,
    this.onSecondDropdownChanged,
  });

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
          // Handle the case where data is empty or missing.
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
                  Text(
                    'Select your question',
                    style: AppTextStyles.boldBlack,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(
                        color: Colors.grey, // Customize the line color
                        width: 1.0,
                      ),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: null,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      isExpanded: true,
                      items: secureQuestions.questions.entries.map((entry) {
                        return DropdownMenuItem<String>(
                          value: entry.key,
                          child: Text(entry.value),
                        );
                      }).toList(),
                      onChanged: onFirstDropdownChanged,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Answer your question',
                    style: AppTextStyles.boldBlack,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(16.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: () {},
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
          );
        }
      },
    );
  }
}
