import 'package:dropin/src_exports.dart';

class AppThemes {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: false,
    scaffoldBackgroundColor: const Color(0xFFFFFFFF),
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    ),
    fontFamily: 'Montserrat',
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.appBlackColor,
      ),
      headlineLarge: TextStyle(
        fontSize: 23,
        fontWeight: FontWeight.w700,
        color: AppColors.appBlackColor,
      ),
      headlineMedium: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.appBlackColor,
      ),
      titleMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.appBlackColor,
      ),
      bodySmall: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: AppColors.appBlackColor,
      ),
    ),
  );
  static ThemeData darkTheme = ThemeData();
}
