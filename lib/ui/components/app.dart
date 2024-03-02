import 'package:flutter/material.dart';
import 'package:main_app/ui/pages/login_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color.fromRGBO(136, 14, 79, 1);
    const primaryColorDark = Color.fromRGBO(96, 0, 39, 1);
    const primaryColorLight = Color.fromRGBO(188, 71, 123, 1);

    return MaterialApp(
      title: 'LoginApp',
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
      theme: ThemeData(
        primaryColor: primaryColor,
        primaryColorDark: primaryColorDark,
        primaryColorLight: primaryColorLight,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: const ColorScheme(
            brightness: Brightness.light,
            primary: primaryColor,
            secondary: primaryColor,
            onPrimary: primaryColor,
            onSecondary: primaryColor,
            error: primaryColorDark,
            onError: primaryColorDark,
            onSecondaryContainer: primaryColorLight,
            background: primaryColorLight,
            onBackground: primaryColorDark,
            surface: primaryColor,
            onSurface: primaryColorDark),
        inputDecorationTheme: const InputDecorationTheme(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: primaryColorLight),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: primaryColorDark),
          ),
          alignLabelWithHint: true,
        ),

        buttonTheme: const ButtonThemeData(
            colorScheme: ColorScheme.light(
              primary: Colors.white,
              secondary: primaryColorLight,
            ),
            buttonColor: primaryColor,
            splashColor: primaryColorLight,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            textTheme: ButtonTextTheme.primary),
        // textTheme: TextTheme(),
      ),
    );
  }
}
