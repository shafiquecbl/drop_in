// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCiEqowiQo6vJY_2_b4R0NJknaxdiHHpio',
    appId: '1:509913894226:web:74e78236b302dd5daebe8b',
    messagingSenderId: '509913894226',
    projectId: 'dropin-378716',
    authDomain: 'dropin-378716.firebaseapp.com',
    storageBucket: 'dropin-378716.appspot.com',
    measurementId: 'G-N5D1EZNEK0',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAnTXWgsdrsByrwXcjH_XEzVWuqGYLLpD0',
    appId: '1:509913894226:android:dab16fafcd908dceaebe8b',
    messagingSenderId: '509913894226',
    projectId: 'dropin-378716',
    storageBucket: 'dropin-378716.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCyZlraDibbzN5LvEuioB98nQeVeoQvPKg',
    appId: '1:509913894226:ios:ee4de22b7036c78eaebe8b',
    messagingSenderId: '509913894226',
    projectId: 'dropin-378716',
    storageBucket: 'dropin-378716.appspot.com',
    iosClientId: '509913894226-ohuj4b6udrj4o725lir6ki9dhs6k7qbe.apps.googleusercontent.com',
    iosBundleId: 'com.dropin.mobileapp',
  );
}