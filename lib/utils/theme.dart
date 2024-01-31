import 'package:flutter/material.dart';

import './constants.dart';

ThemeData basicTheme() => ThemeData(
      textTheme: TextTheme(
        titleLarge: TextStyle(
          fontFamily: 'Roboto',
          fontSize: largeTextSize,
          letterSpacing: 3.0,
          color: kSecondaryColor,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Roboto',
          fontSize: mediumTextSize,
          letterSpacing: 2.0,
          fontWeight: FontWeight.w500,
          color: kSecondaryColor,
        ),
        headlineLarge: TextStyle(
          fontFamily: 'Roboto',
          fontSize: mediumTextSize,
          letterSpacing: 2.0,
          fontWeight: FontWeight.w500,
          color: kAccentColor,
        ),
        headlineSmall: TextStyle(
          fontFamily: 'Roboto',
          fontSize: smallTextSize,
          letterSpacing: 1.0,
          color: kSecondaryColor,
        ),
        bodySmall: TextStyle(
          fontFamily: 'Roboto',
          fontSize: textFieldSize,
          letterSpacing: 1.0,
          color: kSecondaryColor,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: kAccentColor,
      ),
    );
