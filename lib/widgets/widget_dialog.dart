import 'package:flutter/material.dart';
import '../utils/typography.dart';

class ModernDialog extends StatelessWidget {
  final String title;
  final List<String> contentItems;

  const ModernDialog({
    Key? key,
    required this.title,
    required this.contentItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        side: BorderSide(
            color: AppColors.primaryColor, width: 2.0), 
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      backgroundColor: Colors.white,
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: contentItems.map(_buildRequirementText).toList(),
      ),
      actions: [
        Align(
          alignment: Alignment.center,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(AppColors.primaryColor),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              padding: MaterialStateProperty.all<EdgeInsets>(
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
              ),
              textStyle: MaterialStateProperty.all<TextStyle>(
                const TextStyle(fontSize: 18.0),
              ),
            ),
            child: Text(
              'Close',
              style: AppTextStyles.regularWhite,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRequirementText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: AppTextStyles.loginAlert,
        textAlign: TextAlign.center,
      ),
    );
  }
}
