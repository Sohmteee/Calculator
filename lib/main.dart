import 'package:app/res/res.dart';
import 'package:flutter/services.dart';

  void main() {
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarDividerColor: Colors.transparent,
    );

    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, _) {
        return MaterialApp(
          title: 'Equate',
          theme: lightTheme,
          darkTheme: darkTheme,
          home: const CalculatorScreen(),
          debugShowCheckedModeBanner: false,
        );
      }
    );
  }
}

