import 'package:app/res/res.dart';

final lightTheme = ThemeData(
  useMaterial3: false,
  fontFamily: 'Poppins',
  primaryColor: darkPrimary,
  scaffoldBackgroundColor: lightPrimary,
  canvasColor: lightSecondary,
  cardColor: lightAccent,
  textTheme: TextTheme(
    bodySmall: TextStyle(
      color: darkPrimary,
      fontSize: 14.sp,
    ),
    bodyMedium: TextStyle(
      color: darkPrimary,
      fontSize: 16.sp,
    ),
  ),
);

final darkTheme = ThemeData(
  useMaterial3: false,
  fontFamily: 'Poppins',
  primaryColor: lightPrimary,
  scaffoldBackgroundColor: darkPrimary,
  canvasColor: darkSecondary,
  cardColor: darkAccent,
  textTheme: TextTheme(
    bodySmall: TextStyle(
      color: lightPrimary,
      fontSize: 14.sp,
    ),
    bodyMedium: TextStyle(
      color: lightPrimary,
      fontSize: 16.sp,
    ),
  ),
);
