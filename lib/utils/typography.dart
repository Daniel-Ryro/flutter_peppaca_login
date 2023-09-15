import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  
  static TextStyle title = GoogleFonts.openSans(
      fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primaryColor);

  static TextStyle titleChange = GoogleFonts.openSans(
      fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black);

  static TextStyle regularBlack = GoogleFonts.openSans(
    fontSize: 16,
    color: Colors.black,
  );

  static TextStyle regularAlert =
      GoogleFonts.openSans(fontSize: 12, color: AppColors.primaryColor);

  static TextStyle loginAlert =
      GoogleFonts.openSans(fontSize: 14, color: AppColors.primaryColor);

  static TextStyle boldBlack = GoogleFonts.openSans(
      fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold);

  static TextStyle regularWhite = GoogleFonts.openSans(
      fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold);

  static TextStyle buttonLabel = GoogleFonts.openSans(
    fontSize: 18,
    color: Colors.white,
  );

  static TextStyle link = GoogleFonts.openSans(
    fontSize: 16,
    color: Colors.grey,
  );
}

class AppColors {
  static const primaryColor = Color(0xffC2612C);
  static const networkColors = Color.fromARGB(255, 224, 224, 224);
}
