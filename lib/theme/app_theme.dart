import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

 class AppTheme {
  //
  ThemeData lightTheme() {
    return ThemeData(
      fontFamily: GoogleFonts.sourceSansPro().fontFamily,
      primaryColor: AppColor.primaryColor,
      primaryColorLight: AppColor.primaryColor,
      primaryColorDark: AppColor.primaryColorDark,
      backgroundColor: Colors.white,
      textTheme: const TextTheme(
        headline3: TextStyle(
          color: Colors.white,
        ),
        bodyText1: TextStyle(
          color: Colors.white,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor:  Color(0xff061C2D),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.white,
      ),
      brightness: Brightness.light,
      // CUSTOMIZE showDatePicker Colors
      dialogBackgroundColor: Colors.white,
      colorScheme: ColorScheme.light(primary: AppColor.primaryColor),
      buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
      highlightColor: Colors.grey[400],
    );
  }


}
