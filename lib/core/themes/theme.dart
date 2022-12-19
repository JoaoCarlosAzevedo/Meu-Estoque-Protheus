import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meuestoque_protheus/core/themes/app_colors.dart';

class AppTheme {
  static ThemeData get defaultTheme {
    return ThemeData(
      canvasColor: AppColors.primary,
      primaryColor: AppColors.primary,
      toggleableActiveColor: AppColors.primaryGrey,
      dialogBackgroundColor: AppColors.secondary,
      disabledColor: Colors.grey,
      colorScheme: const ColorScheme(
        primaryContainer: AppColors.primaryGrey,
        background: AppColors.primaryGrey,
        brightness: Brightness.light,
        error: AppColors.primaryGrey,
        onBackground: AppColors.primaryGrey,
        onError: AppColors.primaryGrey,
        onPrimary: AppColors.primaryGrey,
        onSecondary: AppColors.primaryGrey,
        onSurface: AppColors.primaryGrey,
        primary: AppColors.primaryGrey,
        secondary: AppColors.primaryGrey,
        surface: AppColors.primaryGrey,
        outline: AppColors.primaryGrey,
        inversePrimary: AppColors.primaryGrey,
      ),

      popupMenuTheme: const PopupMenuThemeData(
        color: AppColors.primary,
      ),
      fontFamily: GoogleFonts.poppins().fontFamily,
      scaffoldBackgroundColor: AppColors.primary,
      appBarTheme: const AppBarTheme(
        titleTextStyle: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: AppColors.background,
        ),
        centerTitle: true,
        color: AppColors.primary,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.background),
      ),
      cardColor: AppColors.background,
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      primaryTextTheme: customTextTheme(),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: AppColors.primary,

        labelStyle: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.normal,
            color: AppColors.input),
        floatingLabelStyle: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.normal,
            color: AppColors.heading),
        iconColor: AppColors.grey,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: const BorderSide(
            width: 1,
            color: AppColors.grey,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: const BorderSide(
            width: 0,
            color: AppColors.background,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: const BorderSide(
            width: 0,
            color: AppColors.primaryRed,
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(width: 2, color: AppColors.primaryRed),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(
              width: 4, color: AppColors.grey, style: BorderStyle.solid),
        ),

        //fillColor: AppColors.background,
        prefixIconColor: AppColors.grey,
        suffixIconColor: AppColors.grey,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      )),
      iconTheme: const IconThemeData(color: Colors.white),
      // Define the default `TextTheme`. Use this to specify the default
      // text styling for headlines, titles, bodies of text, and more.
      textTheme: customTextTheme(),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
          circularTrackColor: AppColors.grey, color: AppColors.grey),
    );
  }

  static TextTheme customTextTheme() {
    return TextTheme(
      headline1: const TextStyle(
          fontSize: 36.0, fontWeight: FontWeight.bold, color: AppColors.grey),
      headline2: const TextStyle(
          fontSize: 30.0, fontWeight: FontWeight.bold, color: AppColors.grey),
      headline3: const TextStyle(
          fontSize: 24.0, fontWeight: FontWeight.bold, color: AppColors.grey),
      headline4: const TextStyle(
          fontSize: 20.0, fontWeight: FontWeight.bold, color: AppColors.grey),
      headline5: const TextStyle(
          fontSize: 18.0, fontWeight: FontWeight.bold, color: AppColors.grey),
      headline6: const TextStyle(
          fontSize: 16.0, fontWeight: FontWeight.bold, color: AppColors.grey),
      bodyText1: TextStyle(
          fontSize: 16.0,
          fontFamily: GoogleFonts.poppins().fontFamily,
          color: AppColors.grey),
      bodyText2: TextStyle(
          fontSize: 14.0,
          fontFamily: GoogleFonts.poppins().fontFamily,
          color: AppColors.grey,
          fontWeight: FontWeight.normal), //TextPadrao
      subtitle1: TextStyle(
          fontSize: 14.0,
          fontFamily: GoogleFonts.poppins().fontFamily,
          color: AppColors.grey),
      caption: TextStyle(
          fontSize: 12.0,
          fontFamily: GoogleFonts.poppins().fontFamily,
          color: AppColors.grey,
          fontWeight: FontWeight.bold),
    ).apply(bodyColor: Colors.white);
  }
}
