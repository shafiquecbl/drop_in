import 'dart:async';
import 'package:dropin/firebase_options.dart';
import 'package:dropin/src/service/NotificationService.dart';
import 'package:dropin/src_exports.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  ErrorWidget.builder = (FlutterErrorDetails e) {
    return const SizedBox();
  };
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await GetStorage.init();
  Get.put(AppService());
  Get.put(PrefService());

  if (kIsWeb) {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } else {
    await Future<void>.delayed(const Duration(seconds: 1));
  }
  runApp(kIsWeb ? WebAdmin() : const MyApp());
}

class WebAdmin extends StatelessWidget {
  const WebAdmin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'DropIn',
      scrollBehavior: const ScrollBehavior().copyWith(overscroll: false),
      debugShowCheckedModeBanner: false,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      fallbackLocale: LocalizationService.fallbackLocale,
      locale: LocalizationService.locale,
      translations: LocalizationService(),
      initialRoute: Routes.WebLogin,
      getPages: Pages.adminPages,
      defaultTransition: Transition.rightToLeft,
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // FocusScope.of(Get.context!).unfocus();
      },
      child: GetMaterialApp(
        title: 'DropIn',
        scrollBehavior: const ScrollBehavior().copyWith(overscroll: false),
        debugShowCheckedModeBanner: false,
        theme: AppThemes.lightTheme,
        darkTheme: AppThemes.darkTheme,
        fallbackLocale: LocalizationService.fallbackLocale,
        locale: LocalizationService.locale,
        translations: LocalizationService(),
        initialRoute: Routes.SplashScreen,
        getPages: Pages.pages,
        defaultTransition: Transition.rightToLeft,
      ),
    );
  }
}
