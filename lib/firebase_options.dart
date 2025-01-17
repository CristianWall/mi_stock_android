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
    apiKey: 'AIzaSyB6ijL23XAvKWlcAdcFJeRI2ZQbm2U03UM',
    appId: '1:159253293203:web:64520ab784ea80770e4566',
    messagingSenderId: '159253293203',
    projectId: 'ecsaapp4',
    authDomain: 'ecsaapp4.firebaseapp.com',
    databaseURL: 'https://ecsaapp4-default-rtdb.firebaseio.com',
    storageBucket: 'ecsaapp4.appspot.com',
    measurementId: 'G-P0KQ7ZHYLM',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDQGI3yb_dtIuyNF9TC6R1gpZsE2JDGbM8',
    appId: '1:159253293203:android:2a1add5cc774d4ce0e4566',
    messagingSenderId: '159253293203',
    projectId: 'ecsaapp4',
    databaseURL: 'https://ecsaapp4-default-rtdb.firebaseio.com',
    storageBucket: 'ecsaapp4.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAZFClxoiBIEEbNVD6fDIcqhbjTJUUiAG8',
    appId: '1:159253293203:ios:db3eb63b741937080e4566',
    messagingSenderId: '159253293203',
    projectId: 'ecsaapp4',
    databaseURL: 'https://ecsaapp4-default-rtdb.firebaseio.com',
    storageBucket: 'ecsaapp4.appspot.com',
    iosBundleId: 'com.example.miStockAndroid',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAZFClxoiBIEEbNVD6fDIcqhbjTJUUiAG8',
    appId: '1:159253293203:ios:db3eb63b741937080e4566',
    messagingSenderId: '159253293203',
    projectId: 'ecsaapp4',
    databaseURL: 'https://ecsaapp4-default-rtdb.firebaseio.com',
    storageBucket: 'ecsaapp4.appspot.com',
    iosBundleId: 'com.example.miStockAndroid',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB6ijL23XAvKWlcAdcFJeRI2ZQbm2U03UM',
    appId: '1:159253293203:web:c8a6346d0dc8410f0e4566',
    messagingSenderId: '159253293203',
    projectId: 'ecsaapp4',
    authDomain: 'ecsaapp4.firebaseapp.com',
    databaseURL: 'https://ecsaapp4-default-rtdb.firebaseio.com',
    storageBucket: 'ecsaapp4.appspot.com',
    measurementId: 'G-ZZZJG1FTJE',
  );
}
