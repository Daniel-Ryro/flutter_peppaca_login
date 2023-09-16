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
    // Obtenha as dimensões do dispositivo
    final Size screenSize = MediaQuery.of(context).size;
    
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        side: BorderSide(color: AppColors.primaryColor, width: 2.0),
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      backgroundColor: Colors.white,
      title: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 0.025 * screenSize.width,  // ~2.5% da largura da tela
        ),
      ),
      content: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: contentItems.map(_buildRequirementText).toList(),
              ),
            ),
          );
        },
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
                EdgeInsets.symmetric(
                  vertical: 0.01 * screenSize.height,   // ~1% da altura da tela
                  horizontal: 0.05 * screenSize.width, // ~5% da largura da tela
                ),
              ),
              textStyle: MaterialStateProperty.all<TextStyle>(
                TextStyle(fontSize: 0.022 * screenSize.width), // ~2.2% da largura da tela
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
