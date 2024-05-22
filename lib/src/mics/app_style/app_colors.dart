import 'package:dropin/src_exports.dart';

///This class will be used for storing colors that will be used in app
///[exampleColor] will be your color name and assign value of you color
class AppColors {
  static const Color primary = Color(0xFF494949);
  static const Color dark = Color(0xFF313144);
  static const Color appButtonColor = Color(0xFFFC8233);
  static const Color locationcolor = Color(0xFFD66115);
  static const Color messageNotificationColor = Color(0xFFFD0D1B);
  static const Color coverphotocolor = Color(0xffE6e6e6);
  static const Color appBlackColor = Colors.black;
  static const Color transparent = Colors.transparent;
  static const Color appWhiteColor = Colors.white;
  static const Color textFieldColor = Color(0xFFEBEBEB);
  static const Color grey = Color(0xFF979797);
  static const Color greyLight = Color(0xFF676767);
  static const Color greyColor = Color(0xFFD9D9D9);
  static const Color purpale = Color(0xFF96B3FF);
  static const Color purpaleLight = Color(0xFFD0DDFF);
  static const Color black = Color(0xFF1E1E1E);
  static const Color brightBlue = Color(0xFF007AFF);
  static const Color navyBlue = Color(0xFF4BACD6);
  static const Color listviewcolor = Color(0xFFD0DDFF);
  static const Color red = Color(0xFF9A0B13);

  static const Color containercolor = Color(0xFFC6C6C6);
  static const Color hintColor = Color(0xFFADB2B6);
  static const Color timeStamp = Color(0xFF696776);
  static const Color tileColor = Color(0xFF69B0C8);
  static const Color chatcolor1 = Color(0xFF81B3C4);
  static const Color chatcolor = Color(0xFF6CC3EA);
  static const Color redcolor = Color(0xFFE02424);
  static const Color searchBgColor = Color(0xFFD0DDFF);
  static const Color darkWhite = Color(0xFFEAEAEA);
  static const Color chatcolors = Color(0xFF1C6DC1);
  static const Color iconcolor = Color(0xFFF6F6F6);
  static const Color barcolor = Color(0xFF3A57E8);
  static const Color barcolor1 = Color(0xFF85F4FA);
  static const Color buttonColor1 = Color(0xFF0078D4);
  static const Color buttonColor2 = Color(0xFF3F2F1);
  static const Color mapColor = Color(0xFFDF681c);
  static const Color profilecolor = Color(0xFFFc8233);
  static const Color chatColor2 = Color(0xFFE46E20);

  static LinearGradient appGradientColor = const LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.bottomRight,
    colors: <Color>[
      Color(0xFFFC8233),
      Color(0xFFC25006),
    ],
  );

  static LinearGradient background = const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF068BB7),
      Color(0xFF004257),
    ],
  );

  static LinearGradient backgroundTransperent = const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[Colors.transparent, Colors.transparent],
  );

  static LinearGradient buttonColor = const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[
      Color(0xFFFC8233),
      Color(0xFF453124),
    ],
  );
  static LinearGradient rateBussinesscolor = const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[
      Color(0xFFFC8233),
      Color(0xFF453124),
    ],
  );

  ///admin panel colors
  static const Color drawerColor = Color(0xFFF1F1F1);
  static const Color selectdeaweclr = Color(0xFF0832DE);
  static const Color admingreycolor = Color(0xFF7D7D7D);
}
