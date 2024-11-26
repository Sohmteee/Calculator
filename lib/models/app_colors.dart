import 'package:app/res/res.dart';

class AppColors {
  static Color primary(BuildContext context) {
    return Theme.of(context).brightness != Brightness.light
        ? lightPrimary
        : darkPrimary;
  }

  static Color secondary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightSecondary
        : darkSecondary;
  }

  static Color accent(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightAccent
        : darkAccent;
  }

  static Color grey(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightGrey
        : darkGrey;
  }

  static Color red(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightRed
        : darkRed;
  }

  static Color green(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightGreen
        : darkGreen;
  }
}
