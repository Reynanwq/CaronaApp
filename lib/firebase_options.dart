// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyBO_fdJYFZBlKEZRmVTRTFbLRfl0pH-Zj0',
    appId: '1:155224585719:web:abe8e64e4c1b7b9d7a2af2',
    messagingSenderId: '155224585719',
    projectId: 'appcarona-67a31',
    authDomain: 'appcarona-67a31.firebaseapp.com',
    storageBucket: 'appcarona-67a31.firebasestorage.app',
    measurementId: 'G-8J2LF89LD0',
    databaseURL: "https://appcarona-67a31-default-rtdb.firebaseio.com/",
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAD1MAeEsixndQGjlAX8cuvteq9CQ__1ew',
    appId: '1:155224585719:android:b5bbd808dbf9e2227a2af2',
    messagingSenderId: '155224585719',
    projectId: 'appcarona-67a31',
    storageBucket: 'appcarona-67a31.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyADEKoktjynsjJCbFtpJblJvLBcyAEY6P4',
    appId: '1:155224585719:ios:d2effd5b4b4def877a2af2',
    messagingSenderId: '155224585719',
    projectId: 'appcarona-67a31',
    storageBucket: 'appcarona-67a31.firebasestorage.app',
    iosClientId: '155224585719-6p7tgqq3vsqfatgeqlsmghflka1ad53b.apps.googleusercontent.com',
    iosBundleId: 'com.example.appcarona',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyADEKoktjynsjJCbFtpJblJvLBcyAEY6P4',
    appId: '1:155224585719:ios:d2effd5b4b4def877a2af2',
    messagingSenderId: '155224585719',
    projectId: 'appcarona-67a31',
    storageBucket: 'appcarona-67a31.firebasestorage.app',
    iosClientId: '155224585719-6p7tgqq3vsqfatgeqlsmghflka1ad53b.apps.googleusercontent.com',
    iosBundleId: 'com.example.appcarona',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBO_fdJYFZBlKEZRmVTRTFbLRfl0pH-Zj0',
    appId: '1:155224585719:web:f17d94a99a957cbf7a2af2',
    messagingSenderId: '155224585719',
    projectId: 'appcarona-67a31',
    authDomain: 'appcarona-67a31.firebaseapp.com',
    storageBucket: 'appcarona-67a31.firebasestorage.app',
    measurementId: 'G-6X1SPLZ6VF',
  );

}