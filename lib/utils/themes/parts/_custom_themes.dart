part of '../app_resources.dart';

class _CustomTheme {
  final ThemeData whiteTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppResources.colors.white,
    appBarTheme: AppBarTheme(
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarBrightness: Brightness.light, // iOS (dark text/icons)
        statusBarIconBrightness: Brightness.light, // Android (dark icons)
      ),
      backgroundColor: AppResources.colors.blue800,
      foregroundColor: Colors.white,
      elevation: 1,
      shadowColor: Colors.black.withOpacity(0.5),
      centerTitle: true,
      titleTextStyle: AppResources.fonts.heading4
          .copyWith(color: AppResources.colors.white),
    ),
    buttonTheme: const ButtonThemeData(
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        elevation: const WidgetStatePropertyAll(0),
        fixedSize: const WidgetStatePropertyAll(Size.fromWidth(1000)),
        shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.r))),
        backgroundColor: WidgetStatePropertyAll(AppResources.colors.primary),
        foregroundColor: WidgetStatePropertyAll(AppResources.colors.white),
        textStyle: WidgetStatePropertyAll(
          AppResources.fonts.body2,
        ),
        padding: WidgetStatePropertyAll(EdgeInsets.all(8.r)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: const WidgetStatePropertyAll(Color(0xff939393)),
        textStyle: WidgetStatePropertyAll(
          AppResources.fonts.body3,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
          backgroundColor: const WidgetStatePropertyAll(Colors.white),
          foregroundColor: const WidgetStatePropertyAll(Colors.black),
          side: const WidgetStatePropertyAll(
            BorderSide(
              color: Color(0xffF1F5F9),
            ),
          ),
          textStyle: WidgetStatePropertyAll(
            AppResources.fonts.body3,
          )),
    ),
  );
}
